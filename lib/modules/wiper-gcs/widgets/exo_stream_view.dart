import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Controls one native ExoPlayer view (see ExoStreamView.kt).
class ExoStreamController {
  MethodChannel? _ch;
  String? _pendingUrl;

  /// Called when ExoPlayer reports a real playback error.
  void Function(String message)? onError;

  bool get isAttached => _ch != null;

  void _attach(int id) {
    _ch = MethodChannel('exo_stream_view_$id');
    _ch!.setMethodCallHandler((call) async {
      if (call.method == 'onError') {
        onError?.call(call.arguments?.toString() ?? 'Unknown player error');
      }
    });
    final url = _pendingUrl;
    _pendingUrl = null;
    if (url != null) play(url);
  }

  /// Call when the native view is going away (e.g. fullscreen dialog closed).
  void detach() {
    _ch?.setMethodCallHandler(null);
    _ch = null;
    _pendingUrl = null;
  }

  /// Plays an rtsp:// or udp:// URL. If the view isn't created yet, it plays once it is.
  Future<void> play(String url) async {
    final ch = _ch;
    if (ch == null) {
      _pendingUrl = url;
      return;
    }
    try {
      await ch.invokeMethod('play', {'url': url});
    } catch (e) {
      debugPrint('ExoStream play error: $e');
    }
  }

  Future<void> stop() async {
    _pendingUrl = null;
    try {
      await _ch?.invokeMethod('stop');
    } catch (e) {
      debugPrint('ExoStream stop error: $e');
    }
  }

  /// Current frame as PNG bytes at the video's native resolution.
  Future<Uint8List?> snapshot() async {
    try {
      return await _ch?.invokeMethod<Uint8List>('snapshot');
    } catch (e) {
      debugPrint('ExoStream snapshot error: $e');
      return null;
    }
  }
}

class ExoStreamView extends StatelessWidget {
  final ExoStreamController controller;

  /// true = fill and crop (like BoxFit.cover), false = letterbox (like BoxFit.contain)
  final bool cover;

  const ExoStreamView({super.key, required this.controller, this.cover = true});

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'exo_stream_view',
      creationParams: {'fit': cover ? 'cover' : 'contain'},
      creationParamsCodec: const StandardMessageCodec(),
      hitTestBehavior: PlatformViewHitTestBehavior.transparent,
      onPlatformViewCreated: controller._attach,
    );
  }
}






