import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_ce/hive.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vivid_mapping_sandbox/core/db/isar_service.dart';
import 'package:vivid_mapping_sandbox/core/utils/device_id.dart';
import 'package:vivid_mapping_sandbox/shared/bot_select.dart';
import 'package:vivid_mapping_sandbox/shared/login.dart';

import 'modules/wiper-gcs/widgets/camera_view.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    MediaKit.ensureInitialized();
    FlutterForegroundTask.initCommunicationPort();

    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'vivid_gcs_record',
        channelName: 'Vivid GCS Recording',
        channelDescription: 'Keeps RTSP stream active in background',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        eventAction: ForegroundTaskEventAction.repeat(5000),
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
        stopWithTask: false,
      ),
    );

    await IsarService.init();
    await DeviceId.get();

    final dir = await getApplicationSupportDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    Hive.init(dir.path);
    final box = await Hive.openBox('graphql_cache');

    final HttpLink httpLink = HttpLink('http://100.115.125.63:8000/graphql/');

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore(box)),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (Platform.isAndroid || Platform.isIOS) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    runApp(
      GraphQLProvider(
        client: client,
        child: WithForegroundTask(child: MyApp(isLoggedIn: isLoggedIn)),
      ),
    );
  } catch (e, stacktrace) {
    debugPrint('FATAL ERROR: $e');
    runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFA00000),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                'APP FAILED TO START\n\nERROR:\n$e\n\nSTACKTRACE:\n$stacktrace',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _pipStreamIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivid GCS v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
      ),
      builder: (context, child) {
        final size = MediaQuery.of(context).size;
        final isPip = size.height < 350;

        final activeUrls = GlobalStreamCache.players.keys.toList();
        String? pipUrl;

        if (activeUrls.isNotEmpty) {
          if (_pipStreamIndex >= activeUrls.length) _pipStreamIndex = 0;
          pipUrl = activeUrls[_pipStreamIndex];
        }

        return Stack(
          children: [
            Offstage(offstage: isPip, child: child ?? const SizedBox.shrink()),
            if (isPip)
              Positioned.fill(
                child: Material(
                  color: Colors.black,
                  child: pipUrl != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Video(
                              controller: GlobalStreamCache.getController(
                                pipUrl,
                              ),
                              controls: NoVideoControls,
                              fit: BoxFit.cover,
                            ),

                            // REC Indicator for currently viewed camera
                            if (GlobalRecordingManager.isCameraRecording(
                              pipUrl,
                            ))
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      color: Colors.redAccent,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'REC',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            Positioned(
                              bottom: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'WIPER ACTIVE',
                                  style: TextStyle(
                                    color: Colors.cyan,
                                    fontSize: 9,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            // 👉 DUAL CAMERA PIP SWITCHER
                            if (activeUrls.length > 1)
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pipStreamIndex =
                                          (_pipStreamIndex + 1) %
                                          activeUrls.length;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.switch_video_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )
                      : const Center(
                          child: Text(
                            'VIVID GCS\nSTANDBY',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                ),
              ),
          ],
        );
      },
      home: widget.isLoggedIn ? const BotSelectScreen() : const LoginScreen(),
    );
  }
}