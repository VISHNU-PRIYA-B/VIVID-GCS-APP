package com.example.vivid_mapping_sandbox

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import android.view.TextureView
import android.view.View
import androidx.annotation.OptIn
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.VideoSize
import androidx.media3.common.util.UnstableApi
import androidx.media3.exoplayer.DefaultLoadControl
import androidx.media3.exoplayer.ExoPlayer
import androidx.media3.exoplayer.rtsp.RtspMediaSource
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.ByteArrayOutputStream

/**
 * Native ExoPlayer view for Flutter.
 *  - rtsp://  -> RtspMediaSource with RTP over TCP
 *  - udp://   -> plain MediaItem (recording relay)
 * Uses a TextureView so snapshots can be taken with getBitmap().
 *
 * Added:
 *  1. Small load-control buffers  -> much lower start-up / steady latency
 *  2. Native frame watchdog       -> if no new frame is rendered for a few seconds
 *                                    (silent stall on a weak link), the stream is
 *                                    restarted automatically, no Dart round-trip.
 *  3. Gentle catch-up             -> plays 1.1x while a backlog is buffered, so delay
 *                                    does not build up after a link hiccup.
 */
@OptIn(UnstableApi::class)
class ExoStreamView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    private val cover: Boolean
) : PlatformView, MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "ExoStreamView"

        private const val CHECK_MS = 250L             // watchdog / latency tick
        private const val STALL_CONNECT_MS = 10000L   // allowed time to get the FIRST frame
        private const val STALL_PLAYING_MS = 4000L    // allowed gap once frames were flowing
        private const val CATCHUP_SOFT_MS = 500L      // backlog above this: play 1.2x
        private const val CATCHUP_HARD_MS = 1000L     // backlog above this: play 1.5x
        private const val RESYNC_MS = 2500L           // backlog above this: jump to live
        private const val LOG_EVERY_MS = 2000L
    }

    private val textureView = TextureView(context)
    private val channel = MethodChannel(messenger, "exo_stream_view_$id")

    // Small buffers = low latency. (min, max, startPlayback, resumeAfterRebuffer)
    private val player: ExoPlayer = ExoPlayer.Builder(context)
        .setLoadControl(
            DefaultLoadControl.Builder()
                .setBufferDurationsMs(500, 1500, 150, 300)
                .build()
        )
        .build()

    private var videoW = 0
    private var videoH = 0

    // ── watchdog state ──────────────────────────────────────────────────────
    private val handler = Handler(Looper.getMainLooper())
    private var lastUrl: String? = null     // non-null while we WANT playback
    private var lastFrames = -1L
    private var stalledMs = 0L
    private var hasRendered = false
    private var logAccMs = 0L
    private var lastResyncAt = 0L

    private val watchdog = object : Runnable {
        override fun run() {
            if (lastUrl != null) {
                val counters = player.videoDecoderCounters
                counters?.ensureUpdated()
                val frames = (counters?.renderedOutputBufferCount ?: 0).toLong()

                if (frames != lastFrames) {
                    if (frames > 0) hasRendered = true
                    lastFrames = frames
                    stalledMs = 0L
                } else {
                    stalledMs += CHECK_MS
                    val limit = if (hasRendered) STALL_PLAYING_MS else STALL_CONNECT_MS
                    if (stalledMs >= limit) {
                        Log.w(TAG, "No new frame for ${stalledMs}ms -> restarting stream")
                        restart()
                    }
                }

                // Catch-up: avoid accumulating delay after a stall
                val buffered = player.totalBufferedDuration
                logAccMs += CHECK_MS
                if (logAccMs >= LOG_EVERY_MS) {
                    logAccMs = 0L
                    Log.d(TAG, "buffered=${buffered}ms speed=${player.playbackParameters.speed} state=${player.playbackState}")
                }

                val now = SystemClock.elapsedRealtime()
                if (buffered > RESYNC_MS && hasRendered && now - lastResyncAt > 10000L) {
                    Log.w(TAG, "Backlog ${buffered}ms -> jumping to live")
                    lastResyncAt = now
                    restart()
                } else {
                    val wantSpeed = when {
                        buffered > CATCHUP_HARD_MS -> 1.5f
                        buffered > CATCHUP_SOFT_MS -> 1.2f
                        else -> 1.0f
                    }
                    if (player.playbackParameters.speed != wantSpeed) {
                        player.setPlaybackSpeed(wantSpeed)
                    }
                }
            }
            handler.postDelayed(this, CHECK_MS)
        }
    }

    init {
        player.setVideoTextureView(textureView)
        player.addListener(object : Player.Listener {
            override fun onPlayerError(error: PlaybackException) {
                Log.w(TAG, "Player error: ${error.errorCodeName} ${error.message}")
                channel.invokeMethod("onError", error.message ?: error.errorCodeName)
            }

            override fun onVideoSizeChanged(videoSize: VideoSize) {
                videoW = (videoSize.width * videoSize.pixelWidthHeightRatio).toInt()
                videoH = videoSize.height
                textureView.post { applyTransform() }
            }
        })
        textureView.addOnLayoutChangeListener { _, _, _, _, _, _, _, _, _ -> applyTransform() }
        channel.setMethodCallHandler(this)
        handler.postDelayed(watchdog, CHECK_MS)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "play" -> {
                val url = call.argument<String>("url")
                if (url.isNullOrEmpty()) {
                    result.error("NO_URL", "url is required", null)
                } else {
                    play(url)
                    result.success(null)
                }
            }
            "stop" -> {
                lastUrl = null                // watchdog stands down
                player.stop()
                player.clearMediaItems()
                result.success(null)
            }
            "snapshot" -> {
                val bmp: Bitmap? = if (videoW > 0 && videoH > 0) {
                    textureView.getBitmap(videoW, videoH)
                } else {
                    textureView.bitmap
                }
                if (bmp == null) {
                    result.success(null)
                } else {
                    val out = ByteArrayOutputStream()
                    bmp.compress(Bitmap.CompressFormat.PNG, 100, out)
                    result.success(out.toByteArray())
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun play(url: String) {
        lastUrl = url
        lastFrames = -1L
        stalledMs = 0L
        hasRendered = false

        player.stop()
        player.clearMediaItems()
        player.setPlaybackSpeed(1.0f)
        val item = MediaItem.fromUri(url)
        if (url.startsWith("rtsp", ignoreCase = true)) {
            val source = RtspMediaSource.Factory()
                .setForceUseRtpTcp(true)
                .createMediaSource(item)
            player.setMediaSource(source)
        } else {
            player.setMediaItem(item)
        }
        player.prepare()
        player.playWhenReady = true
    }

    private fun restart() {
        val url = lastUrl ?: return
        play(url)
    }

    // TextureView stretches by default; this keeps the correct aspect ratio (cover or contain)
    private fun applyTransform() {
        val w = textureView.width.toFloat()
        val h = textureView.height.toFloat()
        if (videoW == 0 || videoH == 0 || w == 0f || h == 0f) return
        val videoAspect = videoW.toFloat() / videoH
        val viewAspect = w / h
        var sx = 1f
        var sy = 1f
        if (cover) {
            if (videoAspect > viewAspect) sx = videoAspect / viewAspect else sy = viewAspect / videoAspect
        } else {
            if (videoAspect > viewAspect) sy = viewAspect / videoAspect else sx = videoAspect / viewAspect
        }
        val m = Matrix()
        m.setScale(sx, sy, w / 2f, h / 2f)
        textureView.setTransform(m)
    }

    override fun getView(): View = textureView

    override fun dispose() {
        handler.removeCallbacks(watchdog)
        lastUrl = null
        channel.setMethodCallHandler(null)
        player.release()
    }
}

class ExoStreamViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<*, *>
        val cover = params?.get("fit") != "contain"
        return ExoStreamView(context, messenger, viewId, cover)
    }
}