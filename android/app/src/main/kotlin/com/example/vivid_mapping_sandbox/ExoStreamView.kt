package com.example.vivid_mapping_sandbox   // TODO: change to your app's package (same as MainActivity.kt)

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Matrix
import android.view.TextureView
import android.view.View
import androidx.media3.common.MediaItem
import androidx.media3.common.PlaybackException
import androidx.media3.common.Player
import androidx.media3.common.VideoSize
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
 * Native ExoPlayer view for Flutter. Same playback logic as the working Kotlin app:
 *  - rtsp://  -> RtspMediaSource with RTP over TCP (no gray pixel tearing)
 *  - udp://   -> plain MediaItem (ExoPlayer's TS extractor waits for the first keyframe)
 * Uses a TextureView so snapshots can be taken with getBitmap().
 */
class ExoStreamView(
    context: Context,
    messenger: BinaryMessenger,
    id: Int,
    private val cover: Boolean
) : PlatformView, MethodChannel.MethodCallHandler {

    private val textureView = TextureView(context)
    private val channel = MethodChannel(messenger, "exo_stream_view_$id")
    private val player = ExoPlayer.Builder(context).build()
    private var videoW = 0
    private var videoH = 0

    init {
        player.setVideoTextureView(textureView)
        player.addListener(object : Player.Listener {
            override fun onPlayerError(error: PlaybackException) {
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

    // Identical to playStream() in the Kotlin app
    private fun play(url: String) {
        player.stop()
        player.clearMediaItems()
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


