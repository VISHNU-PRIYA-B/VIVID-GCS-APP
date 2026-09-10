import 'package:flutter_foreground_task/flutter_foreground_task.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(EmptyRecordShield());
}

// This acts purely as an Android Wakelock to prevent the OS from killing the app when minimized. FFmpeg runs safely in the Main UI.
class EmptyRecordShield extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {}

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {}

  @override
  void onReceiveData(Object data) {}

  @override
  void onNotificationPressed() {}

  @override
  void onNotificationButtonPressed(String id) {}
}