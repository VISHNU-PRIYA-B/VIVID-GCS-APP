package com.example.vivid_mapping_sandbox

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "vivid_mapping_sandbox/pip"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.platformViewsController.registry.registerViewFactory(
            "exo_stream_view",
            ExoStreamViewFactory(flutterEngine.dartExecutor.binaryMessenger)
        )


        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "enterPipMode") {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val params = PictureInPictureParams.Builder()
                            .setAspectRatio(Rational(16, 9))
                            .build()
                        val entered = enterPictureInPictureMode(params)
                        result.success(entered)
                    } else {
                        result.error("UNAVAILABLE", "PiP requires Android 8.0+", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
}