// // // // import 'dart:async';
// // // // import 'dart:io';
// // // // import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// // // // import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// // // // import 'package:flutter/material.dart';
// // // // import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// // // // import 'package:google_fonts/google_fonts.dart';
// // // // import 'package:media_kit/media_kit.dart';
// // // // import 'package:media_kit_video/media_kit_video.dart';
// // // // import 'package:path_provider/path_provider.dart';
// // // // import 'package:screenshot/screenshot.dart';
// // // // import '../../../core/services/recording_service.dart';
// // // // import '../../../ui/app_theme.dart';
// // // // import '../../../ui/gcs_widgets.dart';

// // // // class RecordSessionState {
// // // //   FFmpegSession? session;
// // // //   String url = '';
// // // //   DateTime? chunkStartTime;
// // // //   Duration accumulatedTime = Duration.zero;
// // // //   int startNum = 0;
// // // //   bool isRecording = false;
// // // //   bool isPaused = false;
// // // // }

// // // // class GlobalRecordingManager {
// // // //   static final Map<String, RecordSessionState> sessions = {};
// // // //   static final Set<String> registeredFiles = {};

// // // //   static bool isCameraRecording(String url) {
// // // //     return sessions.values.any((s) => s.url == url && s.isRecording);
// // // //   }

// // // //   static Future<void> stopAll() async {
// // // //     for (var s in sessions.values) {
// // // //       // saamplee
// // // //       s.isRecording = false;
// // // //       s.isPaused = false;
// // // //       if (s.session != null) {
// // // //         await FFmpegKit.cancel(s.session!.getSessionId());
// // // //       }
// // // //     }
// // // //     sessions.clear();
// // // //   }
// // // // }

// // // // class GlobalStreamCache {
// // // //   static final Map<String, Player> players = {};
// // // //   static final Map<String, VideoController> controllers = {};

// // // //   static String? get activeStreamUrl => players.keys.firstOrNull;

// // // //   static VideoController getController(String url) {
// // // //     if (players.containsKey(url)) {
// // // //       players[url]!.play();
// // // //       return controllers[url]!;
// // // //     }

// // // //     final player = Player(
// // // //       configuration: const PlayerConfiguration(
// // // //         bufferSize: 1024 * 1024 * 4,
// // // //         logLevel: MPVLogLevel.error,
// // // //       ),
// // // //     );

// // // //     final controller = VideoController(player);

// // // //     try {
// // // //       final mpv = player.platform as dynamic;
// // // //       mpv.setProperty('profile', 'low-latency');
// // // //       mpv.setProperty('audio', 'no');
// // // //       mpv.setProperty('hwdec', 'auto');
// // // //       mpv.setProperty('network-timeout', '3');
// // // //       mpv.setProperty('cache-pause', 'no');
// // // //     } catch (e) {
// // // //       debugPrint("MPV Config Error: $e");
// // // //     }

// // // //     // 👉 DEBUG: log everything about this stream's lifecycle
// // // //     player.stream.error.listen((e) => debugPrint("🔥 [$url] ERROR: $e"));
// // // //     player.stream.width.listen((w) => debugPrint("📐 [$url] Width: $w"));
// // // //     player.stream.height.listen((h) => debugPrint("📐 [$url] Height: $h"));
// // // //     player.stream.playing.listen((p) => debugPrint("▶️ [$url] Playing: $p"));
// // // //     player.stream.buffering.listen((b) => debugPrint("⏳ [$url] Buffering: $b"));

// // // //     debugPrint("🎬 [$url] Attempting to open stream...");
// // // //     player.open(Media(url), play: true);
// // // //     players[url] = player;
// // // //     controllers[url] = controller;

// // // //     return controller;
// // // //   }

// // // //   // 👉 NEW: release just ONE stream (used when a camera's IP/URL changes).
// // // //   // Skips disposal if that URL is currently being recorded, so an
// // // //   // in-progress FFmpeg capture is never interrupted.
// // // //   static Future<void> releaseStream(String url) async {
// // // //     if (url.isEmpty) return;
// // // //     if (GlobalRecordingManager.isCameraRecording(url)) {
// // // //       debugPrint("⚠️ Skipping release for $url — recording in progress.");
// // // //       return;
// // // //     }
// // // //     final player = players.remove(url);
// // // //     controllers.remove(url);
// // // //     if (player != null) {
// // // //       debugPrint("🗑️ Releasing stream for $url");
// // // //       await player.dispose();
// // // //     }
// // // //   }
// // // //       // s11
// // // //   static Future<void> reopenStream(String url) async {
// // // //     final player = players[url];
// // // //     if(player == null) return;
// // // //     debugPrint("🔄 Reopening stream for $url");
// // // //     await player.open(Media(url), play: true);
// // // //   }

// // // //   static Future<void> releaseAll() async {
// // // //     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) {
// // // //       return;
// // // //     }

// // // //     for (var p in players.values) {
// // // //       p.dispose();
// // // //     }
// // // //     players.clear();
// // // //     controllers.clear();
// // // //     FlutterForegroundTask.stopService();
// // // //   }
// // // // }

// // // // class CameraView extends StatefulWidget {
// // // //   final String url;
// // // //   final String label;
// // // //   final String taskName;
// // // //   final int faceNumber;
// // // //   final Function(String, DateTime, String, bool, String)? onSnapshot;
// // // //   final Function(String, DateTime, String)? onVideoRecorded;

// // // //   const CameraView({
// // // //     super.key,
// // // //     required this.url,
// // // //     required this.label,
// // // //     required this.taskName,
// // // //     this.faceNumber = 1,
// // // //     this.onSnapshot,
// // // //     this.onVideoRecorded,
// // // //   });

// // // //   @override
// // // //   State<CameraView> createState() => _CameraViewState();
// // // // }

// // // // class _CameraViewState extends State<CameraView>
// // // //     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
// // // //   final ScreenshotController _smallController = ScreenshotController();
// // // //   final ScreenshotController _fsController = ScreenshotController();

// // // //   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
// // // //   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
// // // //   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

// // // //   bool _isTakingSnap = false;

// // // //   // 👉 FIX: no longer `late final` — must be reassignable when the URL changes.
// // // //   VideoController? controller;
// // // //   String? _boundUrl; // tracks which URL `controller` currently points to

// // // //   bool isError = false;
// // // //   bool _isStreamReady = false;

// // // //   Timer? _uiTimer;
// // // //   Timer? _chunkScannerTimer;
// // // //   String? _lastKnownRecordingPath;

// // // //   RecordSessionState get session {
// // // //     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
// // // //       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
// // // //     }
// // // //     return GlobalRecordingManager.sessions[widget.label]!;
// // // //   }

// // // //   @override
// // // //   bool get wantKeepAlive => true;

// // // //   @override
// // // //   void initState() {
// // // //     super.initState();
// // // //     WidgetsBinding.instance.addObserver(this);
// // // //     _recoverRecordingState();
// // // //     _startTimers();

// // // //     WidgetsBinding.instance.addPostFrameCallback((_) {
// // // //       Future.delayed(const Duration(milliseconds: 300), () {
// // // //         if (mounted) _initStream();
// // // //       });
// // // //     });
// // // //   }

// // // //   @override
// // // //   void didUpdateWidget(covariant CameraView oldWidget) {
// // // //     super.didUpdateWidget(oldWidget);
// // // //     if (widget.url != oldWidget.url) {
// // // //       _switchStream(oldWidget.url);
// // // //     }
// // // //   }

// // // //   Future<void> _switchStream(String oldUrl) async {
// // // //     debugPrint("🔁 [${widget.label}] URL changed: $oldUrl -> ${widget.url}");

// // // //     // Release the old stream first (unless it's actively recording)
// // // //     if (oldUrl.isNotEmpty) {
// // // //       await GlobalStreamCache.releaseStream(oldUrl);
// // // //     }

// // // //     if (!mounted) return;
// // // //     setState(() {
// // // //       _isStreamReady = false;
// // // //       isError = false;
// // // //       controller = null;
// // // //     });

// // // //     _initStream();
// // // //   }
// // // //   @override
// // // //   void didChangeAppLifecycleState(AppLifecycleState state) {
// // // //     if (state == AppLifecycleState.resumed && _isStreamReady && mounted && widget.url.isNotEmpty) {
// // // //       GlobalStreamCache.reopenStream(widget.url);
// // // //     }
// // // //   }

// // // //   void _startTimers() {
// // // //     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
// // // //       if (!mounted) return;
// // // //       final s = session;
// // // //       if (s.isRecording) {
// // // //         Duration d = s.accumulatedTime;
// // // //         if (!s.isPaused && s.chunkStartTime != null) {
// // // //           d += DateTime.now().difference(s.chunkStartTime!);
// // // //         }
// // // //         String h = d.inHours.toString().padLeft(2, '0');
// // // //         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
// // // //         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
// // // //         _timerText.value = "$h:$m:$sec";
// // // //       }
// // // //     });

// // // //     // The scanner runs every 15 seconds and registers ALL files immediately
// // // //     // so you don't have to wait to see the video appear in the UI.
// // // //     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 15), (_) async {
// // // //       if (session.isRecording) {
// // // //         await _registerCompletedChunks(onlyFinished: true);
// // // //       }
// // // //     });
// // // //   }

// // // //   void _initStream() {
// // // //     if (widget.url.isNotEmpty && mounted) {
// // // //       try {
// // // //         final newController = GlobalStreamCache.getController(widget.url);
// // // //         _boundUrl = widget.url;
// // // //         setState(() {
// // // //           controller = newController;
// // // //           isError = false;
// // // //           _isStreamReady = true;
// // // //         });
// // // //       } catch (e) {
// // // //         setState(() {
// // // //           isError = true;
// // // //           _isStreamReady = true;
// // // //         });
// // // //       }
// // // //     } else {
// // // //       if (mounted) {
// // // //         setState(() {
// // // //           controller = null;
// // // //           _boundUrl = null;
// // // //           _isStreamReady = true;
// // // //         });
// // // //       }
// // // //     }
// // // //   }

// // // //   void _recoverRecordingState() {
// // // //     final s = session;
// // // //     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
// // // //       _isRecording.value = s.isRecording;
// // // //       _isPaused.value = s.isPaused;
// // // //     }
// // // //   }

// // // //   Future<int> _getNextSequenceNumber(String dirPath, String basePrefix) async {
// // // //     final dir = Directory(dirPath);
// // // //     int maxNum = -1;
// // // //     if (await dir.exists()) {
// // // //       final files = dir.listSync();
// // // //       for (var file in files) {
// // // //         final name = file.path.split(Platform.pathSeparator).last;
// // // //         // sample1
// // // //         if (name.startsWith(basePrefix) && name.endsWith('.ts') && !name.contains('_merged_')) {
// // // //           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
// // // //           if (match != null) {
// // // //             final num = int.tryParse(match.group(1)!) ?? -1;
// // // //             if (num > maxNum) maxNum = num;
// // // //           }
// // // //         }
// // // //       }
// // // //     }
// // // //     return maxNum + 1;
// // // //   }

// // // //   Future<String?> _getLatestCompletedRecordingPath() async {
// // // //     try {
// // // //       for (var attempt = 0; attempt < 3; attempt++) {
// // // //         final dir = await getApplicationDocumentsDirectory();
// // // //         final safeTaskName = widget.taskName
// // // //             .replaceAll('/', '-')
// // // //             .replaceAll('\\', '-')
// // // //             .replaceAll('"', '')
// // // //             .replaceAll("'", '')
// // // //             .replaceAll(':', '');
// // // //             // saample
// // // //         final safeLabel = widget.label.replaceAll(' ', '_');
// // // //         final basePrefix = '$safeTaskName Face ${widget.faceNumber} $safeLabel vid';

// // // //         final matchedFiles = dir
// // // //             .listSync(recursive: true, followLinks: false)
// // // //             .whereType<File>()
// // // //             .where((file) {
// // // //               final name = file.path.split(Platform.pathSeparator).last;
// // // //               return name.startsWith(basePrefix) &&
// // // //                   name.endsWith('.ts') &&
// // // //                   // sample1
// // // //                   !name.contains('_merged_') &&
// // // //                   file.existsSync() &&
// // // //                   file.lengthSync() > 0;
// // // //             })
// // // //             .toList();

// // // //         if (matchedFiles.isNotEmpty) {
// // // //           matchedFiles.sort((a, b) {
// // // //             final aName = a.path.split(Platform.pathSeparator).last;
// // // //             final bName = b.path.split(Platform.pathSeparator).last;
// // // //             final aMatch = RegExp(r'_(\d{3})\.ts$').firstMatch(aName);
// // // //             final bMatch = RegExp(r'_(\d{3})\.ts$').firstMatch(bName);
// // // //             final aNum = int.tryParse(aMatch?.group(1) ?? '') ?? -1;
// // // //             final bNum = int.tryParse(bMatch?.group(1) ?? '') ?? -1;

// // // //             if (aNum != bNum) {
// // // //               return aNum.compareTo(bNum);
// // // //             }
// // // //             return a.lastModifiedSync().compareTo(b.lastModifiedSync());
// // // //           });

// // // //           final latestPath = matchedFiles.last.path;
// // // //           _lastKnownRecordingPath = latestPath;
// // // //           return latestPath;
// // // //         }

// // // //         if (_lastKnownRecordingPath != null) {
// // // //           final fallbackFile = File(_lastKnownRecordingPath!);
// // // //           if (fallbackFile.existsSync() && fallbackFile.lengthSync() > 0) {
// // // //             return _lastKnownRecordingPath;
// // // //           }
// // // //         }

// // // //         if (attempt < 2) {
// // // //           await Future.delayed(const Duration(milliseconds: 800));
// // // //         }
// // // //       }

// // // //       return null;
// // // //     } catch (e) {
// // // //       debugPrint('Recording path lookup error: $e');
// // // //       return null;
// // // //     }
// // // //   }

// // // //   Future<void> _registerCompletedChunks({required bool onlyFinished}) async {
// // // //     try {
// // // //       final dir = await getApplicationDocumentsDirectory();

// // // //       // Sanitize task name fully to prevent FFmpeg crashes
// // // //       final safeTaskName = widget.taskName
// // // //           .replaceAll('/', '-')
// // // //           .replaceAll('\\', '-')
// // // //           .replaceAll('"', '')
// // // //           .replaceAll("'", '')
// // // //           .replaceAll(':', '');
// // // //           // saample
// // // //       final safeLabel = widget.label.replaceAll(' ', '_');

// // // //       final basePrefix = '$safeTaskName Face ${widget.faceNumber} $safeLabel vid';
// // // //       final files = dir.listSync();
// // // //       List<File> matchedFiles = [];

// // // //       for (var file in files) {
// // // //         final name = file.path.split(Platform.pathSeparator).last;
// // // //         if (name.startsWith(basePrefix) && name.endsWith('.ts') && !name.contains('_merged_')) {
// // // //           matchedFiles.add(File(file.path));
// // // //         }
// // // //       }

// // // //       if (matchedFiles.isEmpty) return;

// // // //       // Sort by path name instead of modify time. Much more reliable for chunks.
// // // //       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

// // // //       int cutoff = onlyFinished ? matchedFiles.length - 1 : matchedFiles.length;

// // // //       for (int i = 0; i < cutoff; i++) {
// // // //         String path = matchedFiles[i].path;
// // // //         if (!GlobalRecordingManager.registeredFiles.contains(path)) {
// // // //           try {
// // // //             if (matchedFiles[i].lengthSync() > 0) {
// // // //               GlobalRecordingManager.registeredFiles.add(path);
// // // //               _lastKnownRecordingPath = path;
// // // //               widget.onVideoRecorded?.call(
// // // //                 path,
// // // //                 matchedFiles[i].lastModifiedSync(),
// // // //                 widget.label,
// // // //               );
// // // //             }
// // // //           } catch (fileError) {
// // // //             debugPrint("File access error for $path: $fileError");
// // // //           }
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       debugPrint("Scanner Error: $e");
// // // //     }
// // // //   }
// // // //   Future<String?> _mergeChunksIntoSingleFile() async {
// // // //   try {
// // // //     final dir = await getApplicationDocumentsDirectory();
// // // //     final safeTaskName = widget.taskName
// // // //         .replaceAll('/', '-')
// // // //         .replaceAll('\\', '-')
// // // //         .replaceAll('"', '')
// // // //         .replaceAll("'", '')
// // // //         .replaceAll(':', '');
// // // //     final safeLabel = widget.label.replaceAll(' ', '_');
// // // //     final basePrefix = '$safeTaskName Face ${widget.faceNumber} $safeLabel vid';

// // // //     // Find all chunk files for this session
// // // //     final matchedFiles = dir
// // // //         .listSync()
// // // //         .whereType<File>()
// // // //         .where((file) {
// // // //           final name = file.path.split(Platform.pathSeparator).last;
// // // //           return name.startsWith(basePrefix) &&
// // // //               name.endsWith('.ts') &&
// // // //               // sample1
// // // //               !name.contains('_merged_') &&
// // // //               file.existsSync() &&
// // // //               file.lengthSync() > 0;
// // // //         })
// // // //         .toList();

// // // //     if (matchedFiles.isEmpty) return null;

// // // //     // Sort by chunk number
// // // //     matchedFiles.sort((a, b) {
// // // //       final aName = a.path.split(Platform.pathSeparator).last;
// // // //       final bName = b.path.split(Platform.pathSeparator).last;
// // // //       final aMatch = RegExp(r'_(\d{3})\.ts$').firstMatch(aName);
// // // //       final bMatch = RegExp(r'_(\d{3})\.ts$').firstMatch(bName);
// // // //       final aNum = int.tryParse(aMatch?.group(1) ?? '') ?? -1;
// // // //       final bNum = int.tryParse(bMatch?.group(1) ?? '') ?? -1;
// // // //       return aNum.compareTo(bNum);
// // // //     });

// // // //     // If there's only one chunk, no need to merge — just use it directly
// // // //     if (matchedFiles.length == 1) {
// // // //       final singleFile = matchedFiles.first;
// // // //       final timestamp = DateTime.now().millisecondsSinceEpoch;
// // // //       final taggedPath = '${dir.path}/${basePrefix}_merged_$timestamp.ts'.replaceAll('\\', '/');
// // // //       try{
// // // //         final taggedFile = await singleFile.rename(taggedPath);
// // // //         return taggedFile.path;
// // // //       } catch (e) {
// // // //         debugPrint("Failed to create tagged file: $e");
// // // //       }
// // // //       return singleFile.path;
// // // //     }

// // // //     // Build the concat list file required by ffmpeg's concat demuxer
// // // //     final timestamp = DateTime.now().millisecondsSinceEpoch;
// // // //     final concatListPath = '${dir.path}/concat_list_$timestamp.txt';
// // // //     final concatListFile = File(concatListPath);

// // // //     final buffer = StringBuffer();
// // // //     for (var file in matchedFiles) {
// // // //       // ffmpeg concat file format requires escaped single quotes
// // // //       final escapedPath = file.path.replaceAll("'", r"'\''");
// // // //       buffer.writeln("file '$escapedPath'");
// // // //     }
// // // //     await concatListFile.writeAsString(buffer.toString());

// // // //     final mergedPath = '${dir.path}/${basePrefix}_merged_$timestamp.ts'
// // // //         .replaceAll('\\', '/');

// // // //     final command =
// // // //         '-y -f concat -safe 0 -i "$concatListPath" -c copy "$mergedPath"';

// // // //     final session = await FFmpegKit.execute(command);
// // // //     final returnCode = await session.getReturnCode();

// // // //     // Clean up the concat list file regardless of outcome
// // // //     if (await concatListFile.exists()) {
// // // //       await concatListFile.delete();
// // // //     }

// // // //     if (returnCode != null && returnCode.isValueSuccess()) {
// // // //       final mergedFile = File(mergedPath);
// // // //       if (mergedFile.existsSync() && mergedFile.lengthSync() > 0) {
// // // //         // Delete original chunks now that merge succeeded
// // // //         for (var file in matchedFiles) {
// // // //           try {
// // // //             await file.delete();
// // // //           } catch (e) {
// // // //             debugPrint("Failed to delete chunk ${file.path}: $e");
// // // //           }
// // // //         }
// // // //         return mergedPath;
// // // //       }
// // // //     }

// // // //     debugPrint("Merge failed, falling back to latest chunk.");
// // // //     return matchedFiles.last.path;
// // // //   } catch (e) {
// // // //     debugPrint("Merge error: $e");
// // // //     return null;
// // // //   }
// // // // }

// // // //   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
// // // //     final s = session;
// // // //     if (s.isRecording && !s.isPaused) return;
// // // //     // img breaking
// // // //     controller?.player.pause(); 


// // // //     try {
// // // //       if (Platform.isAndroid) {
// // // //         if (await FlutterForegroundTask.checkNotificationPermission() !=
// // // //             NotificationPermission.granted) {
// // // //           await FlutterForegroundTask.requestNotificationPermission();
// // // //         }
// // // //         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
// // // //           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
// // // //         }
// // // //       }

// // // //       final dir = await getApplicationDocumentsDirectory();
// // // //       final safeTaskName = widget.taskName
// // // //           .replaceAll('/', '-')
// // // //           .replaceAll('\\', '-')
// // // //           .replaceAll('"', '')
// // // //           .replaceAll("'", '')
// // // //           .replaceAll(':', '');
// // // //           // saample
// // // //       final safeLabel = widget.label.replaceAll(' ', '_');

// // // //       final basePrefix = '$safeTaskName Face ${widget.faceNumber} $safeLabel vid';

// // // //       final startNum = await _getNextSequenceNumber(dir.path, basePrefix);
// // // //       final segmentPattern = '${dir.path}/${basePrefix}_%03d.ts'.replaceAll(
// // // //         '\\',
// // // //         '/',
// // // //       );

// // // //       if (Platform.isAndroid && !await FlutterForegroundTask.isRunningService) {
// // // //         await FlutterForegroundTask.startService(
// // // //           notificationTitle: 'Vivid GCS Recording',
// // // //           notificationText: 'Background stream active...',
// // // //           callback: startCallback,
// // // //         );
// // // //       }

// // // //       s.url = widget.url;
// // // //       if (!s.isRecording) s.startNum = startNum;
// // // //       s.chunkStartTime = DateTime.now();
// // // //       s.isRecording = true;
// // // //       s.isPaused = false;
// // // //       _isRecording.value = true;
// // // //       _isPaused.value = false;

// // // //       // START THE AUTO-HEALER
// // // //       _spawnFFmpegProcess(s, segmentPattern, startNum);

// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(
// // // //             content: Text(
// // // //               'Recording Started (Stream Copy Active)',
// // // //               style: GoogleFonts.jetBrainsMono(fontSize: 12),
// // // //             ),
// // // //             backgroundColor: AppTheme.green,
// // // //           ),
// // // //         );
// // // //       }
// // // //       updateDialog?.call();

// // // //       // Trigger an immediate scan 2 seconds later so it pops up in the UI quickly
// // // //       Future.delayed(const Duration(seconds: 2), () {
// // // //         if (mounted) _registerCompletedChunks(onlyFinished: true);
// // // //       });
// // // //     } catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
// // // //         );
// // // //       }
// // // //     }
// // // //   }

// // // //   void _spawnFFmpegProcess(
// // // //     RecordSessionState s,
// // // //     String segmentPattern,
// // // //     int currentStartNum,
// // // //   ) async {
// // // //     if (!s.isRecording || s.isPaused) return;

// // // //     // -stimeout 10000000 (10 seconds) prevents instant crashes.
// // // //     // -c:v copy (Stream Copy) prevents the CPU from melting and failing the render.
// // // //     // final command ='-y -timeout 10000000 -i "${widget.url}" '
// // // //     // '-c:v copy -an '
// // // //     // // instead of 15 mins given for 24hrs in sec 86400
// // // //     // '-fflags +genpts -f segment -segment_time 86400 -segment_start_number $currentStartNum -reset_timestamps 1 "$segmentPattern"';
// // // //     // image breaking
// // // //     final command = '-y -timeout 10000000 -rtsp_transport tcp -i "${widget.url}" -c:v copy -an -fflags +genpts -f segment -segment_time 86400 -segment_start_number $currentStartNum -reset_timestamps 1 "$segmentPattern"';


// // // //     s.session = await FFmpegKit.executeAsync(command, (finishedSession) async {
// // // //       if (s.isRecording && !s.isPaused) {
// // // //         debugPrint(
// // // //           " RTSP STREAM HUNG! FFmpeg timed out. Auto-healing in 2 seconds...",
// // // //         );

// // // //         // await Future.delayed(const Duration(seconds: 2));

// // // //         final dir = await getApplicationDocumentsDirectory();
// // // //         final safeTaskName = widget.taskName
// // // //             .replaceAll('/', '-')
// // // //             .replaceAll('\\', '-')
// // // //             .replaceAll('"', '')
// // // //             .replaceAll("'", '')
// // // //             .replaceAll(':', '');
// // // //             // saamplee
// // // //         final safeLabel = widget.label.replaceAll(' ', '_');
// // // //         final basePrefix = '$safeTaskName Face ${widget.faceNumber} $safeLabel vid';
// // // //         final nextNum = await _getNextSequenceNumber(dir.path, basePrefix);
                       
// // // //         _spawnFFmpegProcess(s, segmentPattern, nextNum);
// // // //       }
// // // //     });
// // // //   }

// // // //   Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
// // // //     final s = session;
// // // //     if (s.session != null) {
// // // //       await FFmpegKit.cancel(s.session!.getSessionId());
// // // //       s.session = null;
// // // //     }

// // // //     if (s.chunkStartTime != null) {
// // // //       s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
// // // //     }
// // // //     s.isPaused = true;
// // // //     _isPaused.value = true;

// // // //     if (mounted) {
// // // //       ScaffoldMessenger.of(context).showSnackBar(
// // // //         SnackBar(
// // // //           content: Text(
// // // //             'Recording Paused. Finalizing chunk...',
// // // //             style: GoogleFonts.jetBrainsMono(fontSize: 12),
// // // //           ),
// // // //           backgroundColor: AppTheme.amber,
// // // //         ),
// // // //       );
// // // //     }
// // // //     await Future.delayed(const Duration(milliseconds: 200));
// // // //     await _registerCompletedChunks(onlyFinished: true);
// // // //     updateDialog?.call();
// // // //   }
// // // //   bool _isStopping = false;

// // // //   Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
// // // //     // sample1
// // // //     if(_isStopping) return;
// // // //     _isStopping = true;
// // // //     try {
// // // //       final s = session;
// // // //       // saamplee
// // // //       s.isRecording = false;
// // // //       s.isPaused = false;
// // // //       if (s.session != null) {
// // // //         await FFmpegKit.cancel(s.session!.getSessionId());
// // // //       }

// // // //       GlobalRecordingManager.sessions.remove(widget.label);
// // // //       if (!GlobalRecordingManager.sessions.values.any(
// // // //         (sess) => sess.isRecording,
// // // //       )) {
// // // //         await FlutterForegroundTask.stopService();
// // // //       }

// // // //       _isRecording.value = false;
// // // //       _isPaused.value = false;
// // // //       _timerText.value = "00:00:00";

// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(
// // // //             content: Text(
// // // //               'Merging Video Chunks...',
// // // //               style: GoogleFonts.jetBrainsMono(
// // // //                 fontSize: 12,
// // // //                 color: AppTheme.textHi,
// // // //               ),
// // // //             ),
// // // //             backgroundColor: AppTheme.amber,
// // // //             duration: const Duration(seconds: 1),
// // // //           ),
// // // //         );
        
// // // //       }
// // // //       await Future.delayed(const Duration(milliseconds: 1500));
// // // // // merge all chunks into a single file
// // // //       final mergedPath = await _mergeChunksIntoSingleFile();

// // // //       if (mounted) {
// // // //         await showDialog<void>(
// // // //           context: context,
// // // //           barrierDismissible: false,
// // // //           builder: (dialogContext) {
// // // //             return AlertDialog(
// // // //               backgroundColor: AppTheme.bgPanel,
// // // //               title: Text(
// // // //                 'Recording Finished',
// // // //                 style: TextStyle(color: AppTheme.textHi),
// // // //               ),
// // // //               content: Text(
// // // //                 'Save this recording to the database?',
// // // //                 style: TextStyle(color: AppTheme.textMid),
// // // //               ),
// // // //               actions: [
// // // //                 TextButton(
// // // //                   onPressed: () {
// // // //                     Navigator.pop(dialogContext);
// // // //                     if (mergedPath != null) {
// // // //                       widget.onVideoRecorded?.call(
// // // //                         mergedPath,
// // // //                         DateTime.now(),
// // // //                         widget.label,
// // // //                       );
// // // //                     } else {
// // // //                       if (mounted) {
// // // //                         ScaffoldMessenger.of(context).showSnackBar(
// // // //                           const SnackBar(
// // // //                             content: Text('No completed recording file found.'),
// // // //                           ),
// // // //                         );
// // // //                       }
// // // //                     }
// // // //                   },
// // // //                   child: Text(
// // // //                     'SAVE TO DB',
// // // //                     style: TextStyle(color: AppTheme.cyan),
// // // //                   ),
// // // //                 ),
// // // //                 TextButton(
// // // //                   onPressed: () {
// // // //                     Navigator.pop(dialogContext);
// // // //                   },
// // // //                   child: Text(
// // // //                     'CANCEL',
// // // //                     style: TextStyle(color: AppTheme.textMid),
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             );
// // // //           },
// // // //         );
// // // //       }
// // // //     }  catch (e) {
// // // //       if (mounted) {
// // // //         ScaffoldMessenger.of(context).showSnackBar(
// // // //           SnackBar(
// // // //             content: Text('Error stopping video: $e'),
// // // //             backgroundColor: AppTheme.red,
// // // //           ),
// // // //         );
// // // //       }
// // // //     }
// // // //     finally{
// // // //       _isStopping = false;
// // // //     }
// // // //     updateDialog?.call();
// // // //   }

// // // //   Future<void> _takeSnapshot(
// // // //     ScreenshotController targetController, {
// // // //     VoidCallback? updateDialog,
// // // //   }) async {
// // // //     if (_isTakingSnap || !_isStreamReady) return;
// // // //     _isTakingSnap = true;
// // // //     if (mounted) setState(() {});
// // // //     updateDialog?.call();

// // // //     try {
// // // //       final bytes = await targetController.capture(pixelRatio: 4.0);
// // // //       if (bytes != null) {
// // // //         final dir = await getApplicationDocumentsDirectory();
// // // //         final timestamp = DateTime.now();
// // // //         final filePath =
// // // //             '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
// // // //         await File(filePath).writeAsBytes(bytes);

// // // //         _isTakingSnap = false;
// // // //         if (mounted) setState(() {});
// // // //         updateDialog?.call();

// // // //         if (mounted) {
// // // //           bool isIssue = false;
// // // //           TextEditingController descCtrl = TextEditingController();
// // // //           await showDialog(
// // // //             context: context,
// // // //             barrierDismissible: false,
// // // //             builder: (ctx) => StatefulBuilder(
// // // //               builder: (context, setModalState) => AlertDialog(
// // // //                 backgroundColor: AppTheme.bgPanel,
// // // //                 title: Text(
// // // //                   'Snapshot Captured',
// // // //                   style: TextStyle(color: AppTheme.textHi),
// // // //                 ),
// // // //                 content: Column(
// // // //                   mainAxisSize: MainAxisSize.min,
// // // //                   children: [
// // // //                     SwitchListTile(
// // // //                       title: Text(
// // // //                         'Flag as Maintenance Issue?',
// // // //                         style: TextStyle(color: AppTheme.textMid, fontSize: 12),
// // // //                       ),
// // // //                       activeColor: AppTheme.red,
// // // //                       value: isIssue,
// // // //                       onChanged: (v) => setModalState(() => isIssue = v),
// // // //                     ),
// // // //                     if (isIssue)
// // // //                       TextField(
// // // //                         controller: descCtrl,
// // // //                         style: TextStyle(color: AppTheme.textHi, fontSize: 12),
// // // //                         decoration: InputDecoration(
// // // //                           hintText: "Describe the damage/issue....",
// // // //                           hintStyle: TextStyle(color: AppTheme.textLo),
// // // //                         ),
// // // //                       ),
// // // //                   ],
// // // //                 ),
// // // //                 actions: [
// // // //                   TextButton(
// // // //                     onPressed: () {
// // // //                       Navigator.pop(ctx);
// // // //                       widget.onSnapshot?.call(
// // // //                         filePath,
// // // //                         timestamp,
// // // //                         widget.label,
// // // //                         isIssue,
// // // //                         descCtrl.text,
// // // //                       );
// // // //                     },
// // // //                     child: Text(
// // // //                       'SAVE TO DB',
// // // //                       style: TextStyle(color: AppTheme.cyan),
// // // //                     ),
// // // //                   ),
                
// // // //                 TextButton(
// // // //                   onPressed: () {
// // // //                     Navigator.pop(ctx);
// // // //                   },
// // // //                   child: Text(
// // // //                     'CANCEL',
// // // //                     style: TextStyle(color: AppTheme.textMid),
// // // //                   ),
// // // //                 ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //           );
// // // //         }
// // // //       }
// // // //     } catch (e) {
// // // //       _isTakingSnap = false;
// // // //       if (mounted) setState(() {});
// // // //       updateDialog?.call();
// // // //     }
// // // //   }

// // // //   Widget _buildRecordingControls(VoidCallback updateState) {
// // // //     return ValueListenableBuilder<bool>(
// // // //       valueListenable: _isRecording,
// // // //       builder: (context, isRec, _) {
// // // //         return ValueListenableBuilder<bool>(
// // // //           valueListenable: _isPaused,
// // // //           builder: (context, isPau, _) {
// // // //             return Row(
// // // //               mainAxisSize: MainAxisSize.min,
// // // //               children: [
// // // //                 if (!isRec && !isPau)
// // // //                   GestureDetector(
// // // //                     onTap: () =>
// // // //                         _startOrResumeRecording(updateDialog: updateState),
// // // //                     child: Container(
// // // //                       padding: const EdgeInsets.all(8),
// // // //                       decoration: const BoxDecoration(
// // // //                         color: Colors.black54,
// // // //                         shape: BoxShape.circle,
// // // //                       ),
// // // //                       child: const Icon(
// // // //                         Icons.videocam_rounded,
// // // //                         color: Colors.white,
// // // //                         size: 16,
// // // //                       ),
// // // //                     ),
// // // //                   )
// // // //                 else ...[
// // // //                   GestureDetector(
// // // //                     onTap: () => _stopEntirely(updateDialog: updateState),
// // // //                     child: Container(
// // // //                       padding: const EdgeInsets.all(8),
// // // //                       decoration: const BoxDecoration(
// // // //                         color: Colors.black54,
// // // //                         shape: BoxShape.circle,
// // // //                       ),
// // // //                       child: Icon(
// // // //                         Icons.stop_rounded,
// // // //                         color: AppTheme.red,
// // // //                         size: 16,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                   const SizedBox(width: 10),
// // // //                   GestureDetector(
// // // //                     onTap: () {
// // // //                       if (isRec && !isPau) {
// // // //                         _pauseRecording(updateDialog: updateState);
// // // //                       } else {
// // // //                         _startOrResumeRecording(updateDialog: updateState);
// // // //                       }
// // // //                     },
// // // //                     child: Container(
// // // //                       padding: const EdgeInsets.all(8),
// // // //                       decoration: BoxDecoration(
// // // //                         color: isPau ? AppTheme.amber : Colors.white,
// // // //                         shape: BoxShape.circle,
// // // //                       ),
// // // //                       child: Icon(
// // // //                         isPau ? Icons.play_arrow_rounded : Icons.pause_rounded,
// // // //                         color: Colors.black,
// // // //                         size: 16,
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ],
// // // //               ],
// // // //             );
// // // //           },
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   void _showFloatingScreen() {
// // // //     if (controller == null) return;
// // // //     showGeneralDialog(
// // // //       context: context,
// // // //       barrierColor: Colors.black.withOpacity(0.95),
// // // //       barrierDismissible: true,
// // // //       barrierLabel: 'LiveFeed',
// // // //       transitionDuration: const Duration(milliseconds: 250),
// // // //       pageBuilder: (ctx, anim1, anim2) {
// // // //         return SafeArea(
// // // //           child: Scaffold(
// // // //             backgroundColor: Colors.transparent,
// // // //             body: StatefulBuilder(
// // // //               builder: (context, setDialogState) {
// // // //                 return Stack(
// // // //                   children: [
// // // //                     Center(
// // // //                       child: AspectRatio(
// // // //                         aspectRatio: 16 / 9,
// // // //                         child: Screenshot(
// // // //                           controller: _fsController,
// // // //                           child: (_isStreamReady && controller != null)
// // // //                               ? Video(
// // // //                                   controller: controller!,
// // // //                                   fit: BoxFit.contain,
// // // //                                   controls: NoVideoControls,
// // // //                                 )
// // // //                               : Center(
// // // //                                   child: CircularProgressIndicator(
// // // //                                     color: AppTheme.cyan,
// // // //                                   ),
// // // //                                 ),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                     Positioned(
// // // //                       top: 16,
// // // //                       right: 16,
// // // //                       child: IconButton(
// // // //                         icon: const Icon(
// // // //                           Icons.close_rounded,
// // // //                           color: Colors.white,
// // // //                           size: 36,
// // // //                         ),
// // // //                         onPressed: () => Navigator.pop(ctx),
// // // //                       ),
// // // //                     ),
// // // //                     Positioned(
// // // //                       top: 24,
// // // //                       left: 24,
// // // //                       child: Row(
// // // //                         children: [
// // // //                           Container(
// // // //                             padding: const EdgeInsets.symmetric(
// // // //                               horizontal: 12,
// // // //                               vertical: 6,
// // // //                             ),
// // // //                             decoration: BoxDecoration(
// // // //                               color: AppTheme.bgCard.withOpacity(0.8),
// // // //                               borderRadius: BorderRadius.circular(6),
// // // //                               border: Border.all(color: AppTheme.cyan),
// // // //                             ),
// // // //                             child: Text(
// // // //                               '${widget.label} (LIVE)',
// // // //                               style: GoogleFonts.jetBrainsMono(
// // // //                                 color: AppTheme.cyan,
// // // //                                 fontWeight: FontWeight.bold,
// // // //                               ),
// // // //                             ),
// // // //                           ),

// // // //                           ValueListenableBuilder<bool>(
// // // //                             valueListenable: _isRecording,
// // // //                             builder: (context, isRec, _) {
// // // //                               return ValueListenableBuilder<bool>(
// // // //                                 valueListenable: _isPaused,
// // // //                                 builder: (context, isPau, _) {
// // // //                                   if (!isRec && !isPau) {
// // // //                                     return const SizedBox.shrink();
// // // //                                   }
// // // //                                   return Row(
// // // //                                     children: [
// // // //                                       const SizedBox(width: 12),
// // // //                                       Container(
// // // //                                         padding: const EdgeInsets.symmetric(
// // // //                                           horizontal: 12,
// // // //                                           vertical: 6,
// // // //                                         ),
// // // //                                         decoration: BoxDecoration(
// // // //                                           color: AppTheme.red.withOpacity(0.8),
// // // //                                           borderRadius: BorderRadius.circular(
// // // //                                             6,
// // // //                                           ),
// // // //                                           border: Border.all(
// // // //                                             color: AppTheme.red,
// // // //                                           ),
// // // //                                         ),
// // // //                                         child: Row(
// // // //                                           children: [
// // // //                                             const Icon(
// // // //                                               Icons.circle,
// // // //                                               color: Colors.white,
// // // //                                               size: 10,
// // // //                                             ),
// // // //                                             const SizedBox(width: 6),
// // // //                                             ValueListenableBuilder<String>(
// // // //                                               valueListenable: _timerText,
// // // //                                               builder: (ctx, time, _) => Text(
// // // //                                                 'REC $time',
// // // //                                                 style:
// // // //                                                     GoogleFonts.jetBrainsMono(
// // // //                                                       color: Colors.white,
// // // //                                                       fontWeight:
// // // //                                                           FontWeight.bold,
// // // //                                                     ),
// // // //                                               ),
// // // //                                             ),
// // // //                                           ],
// // // //                                         ),
// // // //                                       ),
// // // //                                       if (isPau) ...[
// // // //                                         const SizedBox(width: 12),
// // // //                                         Container(
// // // //                                           padding: const EdgeInsets.symmetric(
// // // //                                             horizontal: 12,
// // // //                                             vertical: 6,
// // // //                                           ),
// // // //                                           decoration: BoxDecoration(
// // // //                                             color: AppTheme.amber.withOpacity(
// // // //                                               0.8,
// // // //                                             ),
// // // //                                             borderRadius: BorderRadius.circular(
// // // //                                               6,
// // // //                                             ),
// // // //                                             border: Border.all(
// // // //                                               color: AppTheme.amber,
// // // //                                             ),
// // // //                                           ),
// // // //                                           child: Text(
// // // //                                             'PAUSED',
// // // //                                             style: GoogleFonts.jetBrainsMono(
// // // //                                               color: Colors.black,
// // // //                                               fontWeight: FontWeight.bold,
// // // //                                             ),
// // // //                                           ),
// // // //                                         ),
// // // //                                       ],
// // // //                                     ],
// // // //                                   );
// // // //                                 },
// // // //                               );
// // // //                             },
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                     Positioned(
// // // //                       bottom: 30,
// // // //                       right: 30,
// // // //                       child: Row(
// // // //                         children: [
// // // //                           Transform.scale(
// // // //                             scale: 1.5,
// // // //                             child: _buildRecordingControls(
// // // //                               () => setDialogState(() {}),
// // // //                             ),
// // // //                           ),
// // // //                           const SizedBox(width: 40),
// // // //                           GestureDetector(
// // // //                             onTap: () => _takeSnapshot(
// // // //                               _fsController,
// // // //                               updateDialog: () => setDialogState(() {}),
// // // //                             ),
// // // //                             child: Container(
// // // //                               padding: const EdgeInsets.all(16),
// // // //                               decoration: BoxDecoration(
// // // //                                 color: _isTakingSnap
// // // //                                     ? Colors.grey
// // // //                                     : AppTheme.cyan,
// // // //                                 shape: BoxShape.circle,
// // // //                                 boxShadow: const [
// // // //                                   BoxShadow(
// // // //                                     color: Colors.black45,
// // // //                                     blurRadius: 8,
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                               child: _isTakingSnap
// // // //                                   ? const SizedBox(
// // // //                                       width: 28,
// // // //                                       height: 28,
// // // //                                       child: CircularProgressIndicator(
// // // //                                         strokeWidth: 3,
// // // //                                         color: Colors.white,
// // // //                                       ),
// // // //                                     )
// // // //                                   : const Icon(
// // // //                                       Icons.camera_alt_rounded,
// // // //                                       color: Colors.white,
// // // //                                       size: 28,
// // // //                                     ),
// // // //                             ),
// // // //                           ),
// // // //                         ],
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 );
// // // //               },
// // // //             ),
// // // //           ),
// // // //         );
// // // //       },
// // // //     );
// // // //   }

// // // //   @override
// // // //   void dispose() {
// // // //     WidgetsBinding.instance.removeObserver(this);
// // // //     _uiTimer?.cancel();
// // // //     _chunkScannerTimer?.cancel();
// // // //     super.dispose();
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     super.build(context);
// // // //     final hasUrl = widget.url.isNotEmpty;
// // // //     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

// // // //     return GestureDetector(
// // // //       onTap: (hasUrl && !isError) ? _showFloatingScreen : null,
// // // //       child: Container(
// // // //         height: h,
// // // //         decoration: BoxDecoration(
// // // //           color: AppTheme.bgRaised,
// // // //           borderRadius: BorderRadius.circular(8),
// // // //           border: Border.all(color: AppTheme.borderDim),
// // // //         ),
// // // //         child: Stack(
// // // //           children: [
// // // //             if (hasUrl && !isError)
// // // //               Screenshot(
// // // //                 controller: _smallController,
// // // //                 child: ClipRRect(
// // // //                   borderRadius: BorderRadius.circular(8),
// // // //                   child: (_isStreamReady && controller != null)
// // // //                       ? Video(
// // // //                           controller: controller!,
// // // //                           fit: BoxFit.cover,
// // // //                           controls: NoVideoControls,
// // // //                         )
// // // //                       : Center(
// // // //                           child: CircularProgressIndicator(
// // // //                             color: AppTheme.cyan,
// // // //                           ),
// // // //                         ),
// // // //                 ),
// // // //               )
// // // //             else
// // // //               Center(
// // // //                 child: Text(
// // // //                   'NO STREAM CONFIGURED',
// // // //                   style: TextStyle(color: AppTheme.red),
// // // //                 ),
// // // //               ),

// // // //             Positioned(
// // // //               top: 10,
// // // //               left: 10,
// // // //               child: Row(
// // // //                 children: [
// // // //                   StatusBadge(
// // // //                     label: hasUrl ? (isError ? 'ERROR' : 'LIVE') : 'OFFLINE',
// // // //                     color: hasUrl
// // // //                         ? (isError ? AppTheme.red : AppTheme.green)
// // // //                         : AppTheme.red,
// // // //                   ),

// // // //                   ValueListenableBuilder<bool>(
// // // //                     valueListenable: _isRecording,
// // // //                     builder: (context, isRec, _) {
// // // //                       return ValueListenableBuilder<bool>(
// // // //                         valueListenable: _isPaused,
// // // //                         builder: (context, isPau, _) {
// // // //                           if (!isRec && !isPau) return const SizedBox.shrink();
// // // //                           return Row(
// // // //                             children: [
// // // //                               const SizedBox(width: 8),
// // // //                               ValueListenableBuilder<String>(
// // // //                                 valueListenable: _timerText,
// // // //                                 builder: (ctx, time, _) => StatusBadge(
// // // //                                   label: 'REC $time',
// // // //                                   color: AppTheme.red,
// // // //                                 ),
// // // //                               ),
// // // //                               if (isPau) ...[
// // // //                                 const SizedBox(width: 8),
// // // //                                 StatusBadge(
// // // //                                   label: 'PAUSED',
// // // //                                   color: AppTheme.amber,
// // // //                                 ),
// // // //                               ],
// // // //                             ],
// // // //                           );
// // // //                         },
// // // //                       );
// // // //                     },
// // // //                   ),
// // // //                 ],
// // // //               ),
// // // //             ),
// // // //             if (hasUrl && !isError)
// // // //               Positioned(
// // // //                 top: 10,
// // // //                 right: 10,
// // // //                 child: Row(
// // // //                   children: [
// // // //                     _buildRecordingControls(() {}),
// // // //                     const SizedBox(width: 10),
// // // //                     GestureDetector(
// // // //                       onTap: () => _takeSnapshot(_smallController),
// // // //                       child: Container(
// // // //                         padding: const EdgeInsets.all(8),
// // // //                         decoration: BoxDecoration(
// // // //                           color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
// // // //                           shape: BoxShape.circle,
// // // //                         ),
// // // //                         child: _isTakingSnap
// // // //                             ? const SizedBox(
// // // //                                 width: 16,
// // // //                                 height: 16,
// // // //                                 child: CircularProgressIndicator(
// // // //                                   strokeWidth: 2,
// // // //                                   color: Colors.white,
// // // //                                 ),
// // // //                               )
// // // //                             : const Icon(
// // // //                                 Icons.camera_alt_rounded,
// // // //                                 color: Colors.white,
// // // //                                 size: 16,
// // // //                               ),
// // // //                       ),
// // // //                     ),
// // // //                   ],
// // // //                 ),
// // // //               ),
// // // //           ],
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }

// import 'dart:async';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';

// import '../../../core/services/recording_service.dart';
// import '../../../ui/app_theme.dart';
// import '../../../ui/gcs_widgets.dart';

// /// Set to true ONLY if your air unit allows a single RTSP client at a time.
// /// When true, the preview player is stopped before FFmpeg connects (the
// /// preview is black for a couple of seconds until the loopback feed is up).
// /// When false (default) the direct live feed stays visible until the
// /// loopback feed is confirmed to carry data, so there is no black gap.
// const bool kStopPreviewBeforeRecording = false;

// class RecordSessionState {
//   FFmpegSession? session;
//   String url = '';
//   DateTime? chunkStartTime;
//   Duration accumulatedTime = Duration.zero;
//   bool isRecording = false;
//   bool isPaused = false;
//   String currentFilePath = '';
// }

// class GlobalRecordingManager {
//   static final Map<String, RecordSessionState> sessions = {};
//   static final Set<String> registeredFiles = {};

//   // One unique loopback UDP port per camera label (no collisions).
//   static final Map<String, int> _monitorPorts = {};
//   static int monitorPortFor(String label) =>
//       _monitorPorts.putIfAbsent(label, () => 6001 + _monitorPorts.length);

//   static bool isCameraRecording(String url) {
//     return sessions.values.any((s) => s.url == url && s.isRecording);
//   }

//   static Future<void> stopAll() async {
//     for (var s in sessions.values) {
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//       }
//     }
//     sessions.clear();
//   }
// }

// class GlobalStreamCache {
//   static final Map<String, Player> players = {};
//   static final Map<String, VideoController> controllers = {};

//   static String? get activeStreamUrl => players.keys.firstOrNull;

//   static VideoController getController(String url) {
//     if (players.containsKey(url)) {
//       players[url]!.play();
//       return controllers[url]!;
//     }

//     final player = Player(
//       configuration: const PlayerConfiguration(
//         bufferSize: 1024 * 1024 * 4,
//         // warn so that loopback/decoder problems show up in the console
//         logLevel: MPVLogLevel.warn,
//       ),
//     );

//     final controller = VideoController(player);

//     try {
//       final mpv = player.platform as dynamic;
//       mpv.setProperty('profile', 'low-latency');
//       mpv.setProperty('audio', 'no');
//       mpv.setProperty('hwdec', 'auto');
//       mpv.setProperty('network-timeout', '3');
//       mpv.setProperty('cache-pause', 'no');
//     } catch (e) {
//       debugPrint("MPV Config Error: $e");
//     }

//     // Diagnostics: shows exactly why a source failed to open/decode.
//     player.stream.error.listen((e) => debugPrint('MPV error [$url]: $e'));
//     player.stream.log.listen((l) => debugPrint('MPV log: $l'));

//     player.open(Media(url), play: true);
//     players[url] = player;
//     controllers[url] = controller;

//     return controller;
//   }

//   static Future<void> releaseAll() async {
//     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) {
//       return;
//     }

//     for (var p in players.values) {
//       p.dispose();
//     }
//     players.clear();
//     controllers.clear();
//     FlutterForegroundTask.stopService();
//   }
// }

// class CameraView extends StatefulWidget {
//   final String url;
//   final String label;
//   final String taskName;
//   final int faceNumber;
//   // Reverted back to standard Function so WiperMainScreen doesn't crash the build!
//   final Function(String, DateTime, String, bool, String)? onSnapshot;
//   final Function(String, DateTime, String)? onVideoRecorded;

//   const CameraView({
//     super.key,
//     required this.url,
//     required this.label,
//     required this.taskName,
//     this.faceNumber = 1,
//     this.onSnapshot,
//     this.onVideoRecorded,
//   });

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView>
//     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
//   final ScreenshotController _smallController = ScreenshotController();
//   final ScreenshotController _fsController = ScreenshotController();

//   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
//   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
//   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

//   bool _isTakingSnap = false;
//   late final VideoController controller;
//   bool isError = false;
//   bool _isStreamReady = false;

//   Timer? _uiTimer;
//   Timer? _chunkScannerTimer;
//   Timer? _monitorTimer;

//   // ---- live-preview (loopback monitor) state ----
//   bool _monitorOnLoopback = false; // player currently shows the UDP loopback
//   bool _monitorGaveUp = false; // fell back to direct feed for this recording
//   bool _monitorBusy = false;
//   int _monitorEpoch = 0; // bumping this cancels any in-flight attach
//   int _monitorFailures = 0;
//   int _stallTicks = 0;
//   Duration _lastPos = Duration.zero;
//   DateTime _lastAttachAt = DateTime.fromMillisecondsSinceEpoch(0);

//   /// True only when the player exists and is usable (controller assigned).
//   bool get _playerUsable =>
//       _isStreamReady && widget.url.isNotEmpty && !isError;

//   int get _monitorPort => GlobalRecordingManager.monitorPortFor(widget.label);

//   // FFmpeg -> loopback (sender)
//   String get _loopbackOutUrl =>
//       'udp://127.0.0.1:$_monitorPort?pkt_size=1316';

//   // mpv <- loopback (receiver). Big FIFO + non-fatal overrun so bursts don't kill it.
//   String get _loopbackInUrl =>
//       'udp://127.0.0.1:$_monitorPort?fifo_size=5000000&overrun_nonfatal=1';

//   String get _basePrefix {
//     final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
//   }

//   RecordSessionState get session {
//     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
//       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
//     }
//     return GlobalRecordingManager.sessions[widget.label]!;
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _recoverRecordingState();
//     _startTimers();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (mounted) _initStream();
//       });
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _playerUsable && mounted) {
//       controller.player.play();
//     }
//   }

//   void _snack(String msg, Color color, {int seconds = 3, TextStyle? style}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg, style: style),
//         backgroundColor: color,
//         duration: Duration(seconds: seconds),
//       ),
//     );
//   }

//   void _startTimers() {
//     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final s = session;
//       if (s.isRecording) {
//         Duration d = s.accumulatedTime;
//         if (!s.isPaused && s.chunkStartTime != null) {
//           d += DateTime.now().difference(s.chunkStartTime!);
//         }
//         String h = d.inHours.toString().padLeft(2, '0');
//         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
//         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
//         _timerText.value = "$h:$m:$sec";
//       }
//     });

//     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       if (session.isRecording) {
//         await _registerCompletedChunks();
//       }
//     });

//     // Watchdog for the loopback preview.
//     _monitorTimer = Timer.periodic(const Duration(seconds: 2), (_) => _monitorTick());
//   }

//   void _initStream() {
//     if (widget.url.isNotEmpty && mounted) {
//       try {
//         controller = GlobalStreamCache.getController(widget.url);
//         setState(() {
//           isError = false;
//           _isStreamReady = true;
//         });

//         // Returning to a camera that is already recording: make sure the
//         // preview is on the loopback feed again.
//         final s = session;
//         if (s.isRecording && !s.isPaused && s.url == widget.url) {
//           unawaited(_attachLoopbackMonitor());
//         }
//       } catch (e) {
//         setState(() {
//           isError = true;
//           _isStreamReady = true;
//         });
//       }
//     } else {
//       if (mounted) setState(() => _isStreamReady = true);
//     }
//   }

//   void _recoverRecordingState() {
//     final s = session;
//     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
//       _isRecording.value = s.isRecording;
//       _isPaused.value = s.isPaused;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Live preview handling
//   // ---------------------------------------------------------------------------

//   Future<void> _setMpv(String key, String value) async {
//     try {
//       final mpv = controller.player.platform as dynamic;
//       await mpv.setProperty(key, value);
//     } catch (e) {
//       debugPrint('MPV set $key failed: $e');
//     }
//   }

//   /// The loopback MPEG-TS feed needs more tolerant probing / timeout than the
//   /// direct low-latency RTSP feed.
//   Future<void> _applyMpvTuning({required bool loopback}) async {
//     await _setMpv('network-timeout', loopback ? '10' : '3');
//     await _setMpv('demuxer-lavf-analyzeduration', loopback ? '2' : '0.1');
//     await _setMpv('demuxer-lavf-probesize', loopback ? '2000000' : '0');
//   }

//   /// Show the camera's direct stream (used when not recording, when paused,
//   /// and as a fallback if the loopback feed can't be made to work).
//   Future<void> _showDirectFeed() async {
//     if (!_playerUsable) return;
//     _monitorEpoch++; // cancel any pending attach
//     _monitorOnLoopback = false;
//     await _applyMpvTuning(loopback: false);
//     await controller.player.open(Media(widget.url), play: true);
//   }

//   /// Wait until FFmpeg is really writing data, THEN switch the player to the
//   /// loopback feed. Until then the direct feed stays on screen (no black gap).
//   Future<void> _attachLoopbackMonitor() async {
//     if (!_playerUsable) return;
//     final epoch = ++_monitorEpoch;
//     final s = session;

//     bool ready = false;
//     for (int i = 0; i < 60; i++) {
//       // ~15 seconds max
//       if (!mounted || epoch != _monitorEpoch || !s.isRecording || s.isPaused) {
//         return;
//       }
//       final path = s.currentFilePath;
//       if (path.isNotEmpty) {
//         final f = File(path);
//         if (await f.exists() && await f.length() > 188 * 200) {
//           ready = true;
//           break;
//         }
//       }
//       await Future.delayed(const Duration(milliseconds: 250));
//     }

//     if (!ready) {
//       debugPrint('Monitor: FFmpeg produced no data in time, staying on direct feed');
//       return;
//     }
//     if (!mounted || epoch != _monitorEpoch || !s.isRecording || s.isPaused) {
//       return;
//     }

//     try {
//       await _applyMpvTuning(loopback: true);
//       await controller.player.open(Media(_loopbackInUrl), play: true);
//       _monitorOnLoopback = true;
//       _lastAttachAt = DateTime.now();
//       _lastPos = controller.player.state.position;
//       _stallTicks = 0;
//     } catch (e) {
//       debugPrint('Monitor attach error: $e');
//     }
//   }

//   void _monitorTick() {
//     if (!mounted || !_playerUsable) return;
//     final s = session;

//     if (!s.isRecording || s.isPaused || !_monitorOnLoopback) {
//       _stallTicks = 0;
//       return;
//     }

//     // Give a freshly opened loopback feed a few seconds to start.
//     if (DateTime.now().difference(_lastAttachAt) < const Duration(seconds: 4)) {
//       return;
//     }

//     final pos = controller.player.state.position;
//     if (pos != _lastPos) {
//       // Playback is advancing -> healthy.
//       _lastPos = pos;
//       _stallTicks = 0;
//       _monitorFailures = 0;
//       return;
//     }

//     _stallTicks++;
//     if (_stallTicks >= 4) {
//       // ~8 seconds without progress
//       _stallTicks = 0;
//       unawaited(_handleMonitorStall());
//     }
//   }

//   Future<void> _handleMonitorStall() async {
//     if (_monitorBusy) return;
//     _monitorBusy = true;
//     try {
//       _monitorFailures++;
//       debugPrint('Monitor stalled (attempt $_monitorFailures)');
//       if (_monitorFailures > 3) {
//         _monitorGaveUp = true;
//         await _showDirectFeed();
//         _snack('Live preview using direct stream (recording continues)', AppTheme.amber);
//       } else {
//         await _attachLoopbackMonitor();
//       }
//     } finally {
//       _monitorBusy = false;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Storage helpers
//   // ---------------------------------------------------------------------------

//   Future<Directory> get _targetDir async {
//     Directory? baseDir;
//     if (Platform.isAndroid) {
//       baseDir = await getExternalStorageDirectory();
//     }
//     baseDir ??= await getApplicationDocumentsDirectory();

//     final dir = Directory('${baseDir.path}/VividGCS_Videos');
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//     return dir;
//   }

//   Future<int> _getNextSequenceNumber(String dirPath) async {
//     final dir = Directory(dirPath);
//     int maxNum = -1;
//     if (await dir.exists()) {
//       final files = dir.listSync();
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
//           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
//           if (match != null) {
//             final num = int.tryParse(match.group(1)!) ?? -1;
//             if (num > maxNum) maxNum = num;
//           }
//         }
//       }
//     }
//     return maxNum + 1;
//   }

//   /// Registers a finished chunk exactly once (guarded against the scanner and
//   /// the FFmpeg-finished callback racing each other).
//   Future<void> _registerFile(File file, {required String tag}) async {
//     final path = file.path;
//     // Claim first: Set.add returns false if someone already claimed it.
//     if (!GlobalRecordingManager.registeredFiles.add(path)) return;

//     try {
//       if (!await file.exists()) {
//         GlobalRecordingManager.registeredFiles.remove(path);
//         return;
//       }
//       final length = await file.length();
//       if (length <= 0) {
//         GlobalRecordingManager.registeredFiles.remove(path);
//         return;
//       }

//       widget.onVideoRecorded?.call(path, file.lastModifiedSync(), widget.label);

//       final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//       _snack('✅ $tag: $mb MB', Colors.green);
//     } catch (e) {
//       GlobalRecordingManager.registeredFiles.remove(path);
//       _snack('❌ DB ERROR ($tag): $e', Colors.red, seconds: 10);
//     }
//   }

//   Future<void> _registerCompletedChunks() async {
//     try {
//       final dir = await _targetDir;
//       if (!await dir.exists()) return;
//       final files = dir.listSync();

//       final currentActiveFile = session.currentFilePath;

//       List<File> matchedFiles = [];
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.contains(_basePrefix) && name.endsWith('.ts')) {
//           // Ignore the active file completely!
//           if (file.path != currentActiveFile) {
//             matchedFiles.add(File(file.path));
//           }
//         }
//       }

//       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

//       for (var file in matchedFiles) {
//         await _registerFile(file, tag: 'SCANNER SAVED');
//       }
//     } catch (e) {
//       debugPrint("Scanner Error: $e");
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Recording
//   // ---------------------------------------------------------------------------

//   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     if (s.isRecording && !s.isPaused) return;

//     try {
//       if (Platform.isAndroid) {
//         if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//           await FlutterForegroundTask.requestNotificationPermission();
//         }
//         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//         }
//       }

//       final dir = await _targetDir;
//       final startNum = await _getNextSequenceNumber(dir.path);

//       if (!await FlutterForegroundTask.isRunningService) {
//         await FlutterForegroundTask.startService(
//           notificationTitle: 'Vivid GCS Recording',
//           notificationText: 'Background stream active...',
//           callback: startCallback,
//         );
//       }

//       s.url = widget.url;
//       s.chunkStartTime = DateTime.now();
//       s.isRecording = true;
//       s.isPaused = false;
//       _isRecording.value = true;
//       _isPaused.value = false;

//       _monitorFailures = 0;
//       _monitorGaveUp = false;
//       _stallTicks = 0;

//       // Optional: free the air unit's RTSP slot before FFmpeg connects.
//       if (_playerUsable && kStopPreviewBeforeRecording) {
//         _monitorEpoch++;
//         _monitorOnLoopback = false;
//         await controller.player.stop();
//       }

//       // 1. Start FFmpeg (writes the file AND rebroadcasts on the loopback port).
//       await _spawnFFmpegProcess(s, startNum);

//       // 2. Switch the preview to the loopback feed only once FFmpeg is really
//       //    producing data. The direct feed stays visible until then.
//       if (_playerUsable) {
//         unawaited(_attachLoopbackMonitor());
//       }

//       _snack(
//         '${widget.label} Recording Started',
//         AppTheme.green,
//         style: GoogleFonts.jetBrainsMono(fontSize: 12),
//       );
//       updateDialog?.call();
//     } catch (e) {
//       _snack('Failed: $e', AppTheme.red);
//     }
//   }

//   Future<void> _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//     if (!s.isRecording || s.isPaused) return;

//     final dir = await _targetDir;
//     final String filePath =
//         '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//     s.currentFilePath = filePath;

//     // TCP transport (no gray pixel tearing) + two outputs:
//     //  1) UDP loopback for the live preview
//     //  2) the .ts file on storage
//     // dump_extra repeats SPS/PPS(/VPS) before every keyframe so a player that
//     // joins mid-stream (UDP has no handshake) can start decoding right away.
//     final List<String> arguments = [
//       '-y',
//       '-timeout', '10000000',
//       '-rtsp_transport', 'tcp',
//       '-i', widget.url,

//       // Output 1: live monitor
//       '-c:v', 'copy', '-an',
//       '-bsf:v', 'dump_extra',
//       '-f', 'mpegts',
//       '-flush_packets', '1',
//       '-muxdelay', '0', '-muxpreload', '0',
//       _loopbackOutUrl,

//       // Output 2: file
//       '-c:v', 'copy', '-an',
//       '-bsf:v', 'dump_extra',
//       '-f', 'mpegts',
//       filePath,
//     ];

//     try {
//       s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
//         final returnCode = await finishedSession.getReturnCode();
//         if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//           final logs = await finishedSession.getLogsAsString();
//           debugPrint("FFMPEG LOG: $logs");
//           _snack(
//             'CRASH: ${logs?.split('\n').where((l) => l.trim().isNotEmpty).lastOrNull ?? "Error"}',
//             Colors.red,
//             seconds: 10,
//           );
//         }

//         // This chunk is finished: it is no longer the "active" file. This also
//         // stops the monitor from mistaking the old (large) file for live data.
//         if (s.currentFilePath == filePath) s.currentFilePath = '';

//         await Future.delayed(const Duration(seconds: 1));
//         await _registerFile(File(filePath), tag: 'DB SAVED');

//         // Respawn only if this is still the current session (prevents a double
//         // spawn when the user pauses and resumes quickly).
//         final isCurrent =
//             s.session == null || s.session!.getSessionId() == finishedSession.getSessionId();

//         if (isCurrent && s.isRecording && !s.isPaused) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (s.isRecording && !s.isPaused) {
//             final nextNum = await _getNextSequenceNumber(dir.path);
//             await _spawnFFmpegProcess(s, nextNum);
//             if (mounted && !_monitorGaveUp) {
//               unawaited(_attachLoopbackMonitor()); // re-attach to the new chunk's feed
//             }
//           }
//         }
//       });
//     } catch (e) {
//       debugPrint("FATAL DART ERROR: $e");
//     }
//   }

//   Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     s.isPaused = true;
//     _isPaused.value = true;
//     _monitorEpoch++;
//     _monitorOnLoopback = false;

//     if (s.session != null) {
//       await FFmpegKit.cancel(s.session!.getSessionId());
//       s.session = null;
//     }

//     if (s.chunkStartTime != null) {
//       s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
//     }

//     updateDialog?.call();

//     // The loopback feed is dead now; go back to the direct stream so the
//     // preview doesn't sit black while paused.
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (mounted && session.isPaused) {
//       await _showDirectFeed();
//     }
//   }

//   Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
//     try {
//       final s = session;
//       s.isRecording = false;
//       s.isPaused = false;
//       _isRecording.value = false;
//       _isPaused.value = false;
//       _timerText.value = "00:00:00";
//       _monitorEpoch++; // cancel any pending attach
//       _monitorOnLoopback = false;

//       _snack('Stopping ${widget.label}...', AppTheme.amber, seconds: 2);

//       // Stop FFmpeg FIRST so the air unit's RTSP session is released...
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//         s.session = null;
//       }

//       // ...then bring the preview back to the direct stream.
//       await Future.delayed(const Duration(milliseconds: 800));
//       await _showDirectFeed();

//       await Future.delayed(const Duration(milliseconds: 1500));
//       s.currentFilePath = '';

//       await _registerCompletedChunks();

//       GlobalRecordingManager.sessions.remove(widget.label);

//       if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
//         await FlutterForegroundTask.stopService();
//       }
//     } catch (e) {
//       debugPrint("Stop error: $e");
//     }
//     updateDialog?.call();
//   }

//   // ---------------------------------------------------------------------------
//   // Snapshot
//   // ---------------------------------------------------------------------------

//   Future<void> _takeSnapshot(ScreenshotController targetController, {VoidCallback? updateDialog}) async {
//     if (_isTakingSnap || !_isStreamReady) return;
//     _isTakingSnap = true;
//     if (mounted) setState(() {});
//     updateDialog?.call();

//     try {
//       final bytes = await targetController.capture(pixelRatio: 4.0);
//       if (bytes != null) {
//         final dir = await _targetDir;
//         if (!await dir.exists()) await dir.create(recursive: true);

//         final timestamp = DateTime.now();
//         final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
//         await File(filePath).writeAsBytes(bytes);

//         _isTakingSnap = false;
//         if (mounted) setState(() {});
//         updateDialog?.call();

//         if (mounted) {
//           bool isIssue = false;
//           TextEditingController descCtrl = TextEditingController();
//           await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (ctx) => StatefulBuilder(
//               builder: (context, setModalState) => AlertDialog(
//                 backgroundColor: AppTheme.bgPanel,
//                 title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SwitchListTile(
//                       title: Text('Flag as Maintenance Issue?', style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
//                       activeColor: AppTheme.red,
//                       value: isIssue,
//                       onChanged: (v) => setModalState(() => isIssue = v),
//                     ),
//                     if (isIssue)
//                       TextField(
//                         controller: descCtrl,
//                         style: TextStyle(color: AppTheme.textHi, fontSize: 12),
//                         decoration: InputDecoration(
//                           hintText: "Describe the damage/issue...",
//                           hintStyle: TextStyle(color: AppTheme.textLo),
//                         ),
//                       ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(ctx);
//                       widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
//                     },
//                     child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // UI
//   // ---------------------------------------------------------------------------

//   Widget _buildRecordingControls(VoidCallback updateState) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isRecording,
//       builder: (context, isRec, _) {
//         return ValueListenableBuilder<bool>(
//           valueListenable: _isPaused,
//           builder: (context, isPau, _) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isRec && !isPau)
//                   GestureDetector(
//                     onTap: () => _startOrResumeRecording(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
//                     ),
//                   )
//                 else ...[
//                   GestureDetector(
//                     onTap: () => _stopEntirely(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       if (isRec && !isPau) {
//                         _pauseRecording(updateDialog: updateState);
//                       } else {
//                         _startOrResumeRecording(updateDialog: updateState);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(color: isPau ? AppTheme.amber : Colors.white, shape: BoxShape.circle),
//                       child: Icon(isPau ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.black, size: 16),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showFloatingScreen() {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.95),
//       barrierDismissible: true,
//       barrierLabel: 'LiveFeed',
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (ctx, anim1, anim2) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: StatefulBuilder(
//               builder: (context, setDialogState) {
//                 return Stack(
//                   children: [
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: Screenshot(
//                           controller: _fsController,
//                           child: _isStreamReady
//                               ? Video(controller: controller, fit: BoxFit.contain, controls: NoVideoControls)
//                               : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
//                         onPressed: () => Navigator.pop(ctx),
//                       ),
//                     ),
//                     Positioned(
//                       top: 24,
//                       left: 24,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: AppTheme.bgCard.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: AppTheme.cyan),
//                             ),
//                             child: Text('${widget.label} (LIVE)', style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold)),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: _isRecording,
//                             builder: (context, isRec, _) {
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: _isPaused,
//                                 builder: (context, isPau, _) {
//                                   if (!isRec && !isPau) return const SizedBox.shrink();
//                                   return Row(
//                                     children: [
//                                       const SizedBox(width: 12),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.red.withOpacity(0.8),
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(color: AppTheme.red),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.circle, color: Colors.white, size: 10),
//                                             const SizedBox(width: 6),
//                                             ValueListenableBuilder<String>(
//                                               valueListenable: _timerText,
//                                               builder: (ctx, time, _) => Text('REC $time', style: GoogleFonts.jetBrainsMono(color: Colors.white, fontWeight: FontWeight.bold)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (isPau) ...[
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.amber.withOpacity(0.8),
//                                             borderRadius: BorderRadius.circular(6),
//                                             border: Border.all(color: AppTheme.amber),
//                                           ),
//                                           child: Text('PAUSED', style: GoogleFonts.jetBrainsMono(color: Colors.black, fontWeight: FontWeight.bold)),
//                                         ),
//                                       ],
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 30,
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.5,
//                             child: _buildRecordingControls(() => setDialogState(() {})),
//                           ),
//                           const SizedBox(width: 40),
//                           GestureDetector(
//                             onTap: () => _takeSnapshot(_fsController, updateDialog: () => setDialogState(() {})),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                                 shape: BoxShape.circle,
//                                 boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
//                               ),
//                               child: _isTakingSnap
//                                   ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
//                                   : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _monitorEpoch++; // cancel any pending attach
//     _uiTimer?.cancel();
//     _chunkScannerTimer?.cancel();
//     _monitorTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final hasUrl = widget.url.isNotEmpty;
//     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

//     return GestureDetector(
//       onTap: (hasUrl && !isError) ? _showFloatingScreen : null,
//       child: Container(
//         height: h,
//         decoration: BoxDecoration(
//           color: AppTheme.bgRaised,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppTheme.borderDim),
//         ),
//         child: Stack(
//           children: [
//             if (hasUrl && !isError)
//               Screenshot(
//                 controller: _smallController,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: _isStreamReady
//                       ? Video(controller: controller, fit: BoxFit.cover, controls: NoVideoControls)
//                       : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                 ),
//               )
//             else
//               Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   StatusBadge(
//                     label: hasUrl ? (isError ? 'ERROR' : 'LIVE') : 'OFFLINE',
//                     color: hasUrl ? (isError ? AppTheme.red : AppTheme.green) : AppTheme.red,
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: _isRecording,
//                     builder: (context, isRec, _) {
//                       return ValueListenableBuilder<bool>(
//                         valueListenable: _isPaused,
//                         builder: (context, isPau, _) {
//                           if (!isRec && !isPau) return const SizedBox.shrink();
//                           return Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               ValueListenableBuilder<String>(
//                                 valueListenable: _timerText,
//                                 builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
//                               ),
//                               if (isPau) ...[
//                                 const SizedBox(width: 8),
//                                 StatusBadge(label: 'PAUSED', color: AppTheme.amber),
//                               ],
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (hasUrl && !isError)
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     _buildRecordingControls(() {}),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () => _takeSnapshot(_smallController),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: _isTakingSnap ? Colors.grey : AppTheme.cyan, shape: BoxShape.circle),
//                         child: _isTakingSnap
//                             ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                             : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'dart:async';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';

// import '../../../core/services/recording_service.dart';
// import '../../../ui/app_theme.dart';
// import '../../../ui/gcs_widgets.dart';

// /// Set to true ONLY if your air unit allows a single RTSP client at a time.
// /// When true, the preview player is stopped before FFmpeg connects (the
// /// preview is black for a couple of seconds until the loopback feed is up).
// /// When false (default) the direct live feed stays visible until the
// /// loopback feed is confirmed to carry data, so there is no black gap.
// const bool kStopPreviewBeforeRecording = false;
// const bool kUseLoopbackPreview = false; // true = use the UDP loopback for live preview, false = direct feed

// class RecordSessionState {
//   FFmpegSession? session;
//   String url = '';
//   DateTime? chunkStartTime;
//   Duration accumulatedTime = Duration.zero;
//   bool isRecording = false;
//   bool isPaused = false;
//   String currentFilePath = '';
// }

// class GlobalRecordingManager {
//   static final Map<String, RecordSessionState> sessions = {};
//   static final Set<String> registeredFiles = {};

//   // One unique loopback UDP port per camera label (no collisions).
//   static final Map<String, int> _monitorPorts = {};
//   static int monitorPortFor(String label) =>
//       _monitorPorts.putIfAbsent(label, () => 6001 + _monitorPorts.length);

//   static bool isCameraRecording(String url) {
//     return sessions.values.any((s) => s.url == url && s.isRecording);
//   }

//   static Future<void> stopAll() async {
//     for (var s in sessions.values) {
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//       }
//     }
//     sessions.clear();
//   }
// }

// class GlobalStreamCache {
//   static final Map<String, Player> players = {};
//   static final Map<String, VideoController> controllers = {};

//   static String? get activeStreamUrl => players.keys.firstOrNull;

//   static VideoController getController(String url) {
//     if (players.containsKey(url)) {
//       players[url]!.play();
//       return controllers[url]!;
//     }

//     final player = Player(
//       configuration: const PlayerConfiguration(
//         bufferSize: 1024 * 1024 * 4,
//         // warn so that loopback/decoder problems show up in the console
//         logLevel: MPVLogLevel.warn,
//       ),
//     );

//     final controller = VideoController(player);

//     try {
//       final mpv = player.platform as dynamic;
//       mpv.setProperty('profile', 'low-latency');
//       mpv.setProperty('audio', 'no');
//       mpv.setProperty('hwdec', 'auto');
//       mpv.setProperty('network-timeout', '3');
//       mpv.setProperty('cache-pause', 'no');
//     } catch (e) {
//       debugPrint("MPV Config Error: $e");
//     }

//     // Diagnostics: shows exactly why a source failed to open/decode.
//     player.stream.error.listen((e) => debugPrint('MPV error [$url]: $e'));
//     player.stream.log.listen((l) => debugPrint('MPV log: $l'));

//     player.open(Media(url), play: true);
//     players[url] = player;
//     controllers[url] = controller;

//     return controller;
//   }

//   static Future<void> releaseAll() async {
//     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) {
//       return;
//     }

//     for (var p in players.values) {
//       p.dispose();
//     }
//     players.clear();
//     controllers.clear();
//     FlutterForegroundTask.stopService();
//   }
// }

// class CameraView extends StatefulWidget {
//   final String url;
//   final String label;
//   final String taskName;
//   final int faceNumber;
//   // Reverted back to standard Function so WiperMainScreen doesn't crash the build!
//   final Function(String, DateTime, String, bool, String)? onSnapshot;
//   final Function(String, DateTime, String)? onVideoRecorded;

//   final bool showRecordButton;

//   const CameraView({
//     super.key,
//     required this.url,
//     required this.label,
//     required this.taskName,
//     this.faceNumber = 1,
//     this.onSnapshot,
//     this.onVideoRecorded,
//     this.showRecordButton = true,
//   });

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView>
//     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
//   final ScreenshotController _smallController = ScreenshotController();
//   final ScreenshotController _fsController = ScreenshotController();

//   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
//   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
//   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

//   bool _isTakingSnap = false;
//   late final VideoController controller;
//   bool isError = false;
//   bool _isStreamReady = false;

//   Timer? _uiTimer;
//   Timer? _chunkScannerTimer;
//   Timer? _monitorTimer;

//   // ---- live-preview (loopback monitor) state ----
//   bool _monitorOnLoopback = false; // player currently shows the UDP loopback
//   bool _monitorGaveUp = false; // fell back to direct feed for this recording
//   bool _monitorBusy = false;
//   int _monitorEpoch = 0; // bumping this cancels any in-flight attach
//   int _monitorFailures = 0;
//   int _stallTicks = 0;
//   Duration _lastPos = Duration.zero;
//   DateTime _lastAttachAt = DateTime.fromMillisecondsSinceEpoch(0);

//   /// True only when the player exists and is usable (controller assigned).
//   bool get _playerUsable =>
//       _isStreamReady && widget.url.isNotEmpty && !isError;

//   int get _monitorPort => GlobalRecordingManager.monitorPortFor(widget.label);

//   // FFmpeg -> loopback (sender)
//   String get _loopbackOutUrl =>
//       'udp://127.0.0.1:$_monitorPort?pkt_size=1316';

//   // mpv <- loopback (receiver). Big FIFO + non-fatal overrun so bursts don't kill it.
//   String get _loopbackInUrl =>
//       'udp://127.0.0.1:$_monitorPort?fifo_size=5000000&overrun_nonfatal=1';

//   String get _basePrefix {
//     final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
//   }

//   RecordSessionState get session {
//     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
//       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
//     }
//     return GlobalRecordingManager.sessions[widget.label]!;
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _recoverRecordingState();
//     _startTimers();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (mounted) _initStream();
//       });
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _playerUsable && mounted) {
//       controller.player.play();
//     }
//   }

//   void _snack(String msg, Color color, {int seconds = 3, TextStyle? style}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(msg, style: style),
//         backgroundColor: color,
//         duration: Duration(seconds: seconds),
//       ),
//     );
//   }

//   void _startTimers() {
//     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final s = session;
//       if (s.isRecording) {
//         Duration d = s.accumulatedTime;
//         if (!s.isPaused && s.chunkStartTime != null) {
//           d += DateTime.now().difference(s.chunkStartTime!);
//         }
//         String h = d.inHours.toString().padLeft(2, '0');
//         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
//         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
//         _timerText.value = "$h:$m:$sec";
//       }
//     });

//     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       if (session.isRecording) {
//         await _registerCompletedChunks();
//       }
//     });

//     // Watchdog for the loopback preview.
//     _monitorTimer = Timer.periodic(const Duration(seconds: 2), (_) => _monitorTick());
//   }

//   void _initStream() {
//     if (widget.url.isNotEmpty && mounted) {
//       try {
//         controller = GlobalStreamCache.getController(widget.url);
//         setState(() {
//           isError = false;
//           _isStreamReady = true;
//         });

//         // Returning to a camera that is already recording: make sure the
//         // preview is on the loopback feed again.
//         final s = session;
//         if (s.isRecording && !s.isPaused && s.url == widget.url) {
//           unawaited(_attachLoopbackMonitor());
//         }
//       } catch (e) {
//         setState(() {
//           isError = true;
//           _isStreamReady = true;
//         });
//       }
//     } else {
//       if (mounted) setState(() => _isStreamReady = true);
//     }
//   }

//   void _recoverRecordingState() {
//     final s = session;
//     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
//       _isRecording.value = s.isRecording;
//       _isPaused.value = s.isPaused;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Live preview handling
//   // ---------------------------------------------------------------------------

//   Future<void> _setMpv(String key, String value) async {
//     try {
//       final mpv = controller.player.platform as dynamic;
//       await mpv.setProperty(key, value);
//     } catch (e) {
//       debugPrint('MPV set $key failed: $e');
//     }
//   }

//   /// The loopback MPEG-TS feed needs more tolerant probing / timeout than the
//   /// direct low-latency RTSP feed.
//   Future<void> _applyMpvTuning({required bool loopback}) async {
//     await _setMpv('network-timeout', loopback ? '10' : '3');
//     await _setMpv('demuxer-lavf-analyzeduration', loopback ? '2' : '0.1');
//     await _setMpv('demuxer-lavf-probesize', loopback ? '2000000' : '0');
//   }

//   /// Show the camera's direct stream (used when not recording, when paused,
//   /// and as a fallback if the loopback feed can't be made to work).
//   Future<void> _showDirectFeed() async {
//     // if (!_playerUsable) return;
//     if (!kUseLoopbackPreview || !_playerUsable) return;
//     _monitorEpoch++; // cancel any pending attach
//     _monitorOnLoopback = false;
//     await _applyMpvTuning(loopback: false);
//     await controller.player.open(Media(widget.url), play: true);
//   }

//   /// Wait until FFmpeg is really writing data, THEN switch the player to the
//   /// loopback feed. Until then the direct feed stays on screen (no black gap).
//   Future<void> _attachLoopbackMonitor() async {
//     // if (!_playerUsable) return;
//     if (!kUseLoopbackPreview || !_playerUsable) return;
//     final epoch = ++_monitorEpoch;
//     final s = session;

//     bool ready = false;
//     for (int i = 0; i < 60; i++) {
//       // ~15 seconds max
//       if (!mounted || epoch != _monitorEpoch || !s.isRecording || s.isPaused) {
//         return;
//       }
//       final path = s.currentFilePath;
//       if (path.isNotEmpty) {
//         final f = File(path);
//         if (await f.exists() && await f.length() > 188 * 200) {
//           ready = true;
//           break;
//         }
//       }
//       await Future.delayed(const Duration(milliseconds: 250));
//     }

//     if (!ready) {
//       debugPrint('Monitor: FFmpeg produced no data in time, staying on direct feed');
//       return;
//     }
//     if (!mounted || epoch != _monitorEpoch || !s.isRecording || s.isPaused) {
//       return;
//     }

//     try {
//       await _applyMpvTuning(loopback: true);
//       await controller.player.open(Media(_loopbackInUrl), play: true);
//       _monitorOnLoopback = true;
//       _lastAttachAt = DateTime.now();
//       _lastPos = controller.player.state.position;
//       _stallTicks = 0;
//     } catch (e) {
//       debugPrint('Monitor attach error: $e');
//     }
//   }

//   void _monitorTick() {
//     if (!mounted || !_playerUsable) return;
//     final s = session;

//     if (!s.isRecording || s.isPaused || !_monitorOnLoopback) {
//       _stallTicks = 0;
//       return;
//     }

//     // Give a freshly opened loopback feed a few seconds to start.
//     if (DateTime.now().difference(_lastAttachAt) < const Duration(seconds: 4)) {
//       return;
//     }

//     final pos = controller.player.state.position;
//     if (pos != _lastPos) {
//       // Playback is advancing -> healthy.
//       _lastPos = pos;
//       _stallTicks = 0;
//       _monitorFailures = 0;
//       return;
//     }

//     _stallTicks++;
//     if (_stallTicks >= 4) {
//       // ~8 seconds without progress
//       _stallTicks = 0;
//       unawaited(_handleMonitorStall());
//     }
//   }

//   Future<void> _handleMonitorStall() async {
//     if (_monitorBusy) return;
//     _monitorBusy = true;
//     try {
//       _monitorFailures++;
//       debugPrint('Monitor stalled (attempt $_monitorFailures)');
//       if (_monitorFailures > 3) {
//         _monitorGaveUp = true;
//         await _showDirectFeed();
//         _snack('Live preview using direct stream (recording continues)', AppTheme.amber);
//       } else {
//         await _attachLoopbackMonitor();
//       }
//     } finally {
//       _monitorBusy = false;
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Storage helpers
//   // ---------------------------------------------------------------------------

//   Future<Directory> get _targetDir async {
//     Directory? baseDir;
//     if (Platform.isAndroid) {
//       baseDir = await getExternalStorageDirectory();
//     }
//     baseDir ??= await getApplicationDocumentsDirectory();

//     final dir = Directory('${baseDir.path}/VividGCS_Videos');
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//     return dir;
//   }

//   Future<int> _getNextSequenceNumber(String dirPath) async {
//     final dir = Directory(dirPath);
//     int maxNum = -1;
//     if (await dir.exists()) {
//       final files = dir.listSync();
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
//           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
//           if (match != null) {
//             final num = int.tryParse(match.group(1)!) ?? -1;
//             if (num > maxNum) maxNum = num;
//           }
//         }
//       }
//     }
//     return maxNum + 1;
//   }

//   /// Registers a finished chunk exactly once (guarded against the scanner and
//   /// the FFmpeg-finished callback racing each other).
//   Future<void> _registerFile(File file, {required String tag}) async {
//     final path = file.path;
//     // Claim first: Set.add returns false if someone already claimed it.
//     if (!GlobalRecordingManager.registeredFiles.add(path)) return;

//     try {
//       if (!await file.exists()) {
//         GlobalRecordingManager.registeredFiles.remove(path);
//         return;
//       }
//       final length = await file.length();
//       if (length <= 0) {
//         GlobalRecordingManager.registeredFiles.remove(path);
//         return;
//       }

//       widget.onVideoRecorded?.call(path, file.lastModifiedSync(), widget.label);

//       final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//       _snack('✅ $tag: $mb MB', Colors.green);
//     } catch (e) {
//       GlobalRecordingManager.registeredFiles.remove(path);
//       _snack('❌ DB ERROR ($tag): $e', Colors.red, seconds: 10);
//     }
//   }

//   Future<void> _registerCompletedChunks() async {
//     try {
//       final dir = await _targetDir;
//       if (!await dir.exists()) return;
//       final files = dir.listSync();

//       final currentActiveFile = session.currentFilePath;

//       List<File> matchedFiles = [];
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.contains(_basePrefix) && name.endsWith('.ts')) {
//           // Ignore the active file completely!
//           if (file.path != currentActiveFile) {
//             matchedFiles.add(File(file.path));
//           }
//         }
//       }

//       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

//       for (var file in matchedFiles) {
//         await _registerFile(file, tag: 'SCANNER SAVED');
//       }
//     } catch (e) {
//       debugPrint("Scanner Error: $e");
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // Recording
//   // ---------------------------------------------------------------------------

//   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     if (s.isRecording && !s.isPaused) return;

//     try {
//       if (Platform.isAndroid) {
//         if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//           await FlutterForegroundTask.requestNotificationPermission();
//         }
//         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//         }
//       }

//       final dir = await _targetDir;
//       final startNum = await _getNextSequenceNumber(dir.path);

//       if (!await FlutterForegroundTask.isRunningService) {
//         await FlutterForegroundTask.startService(
//           notificationTitle: 'Vivid GCS Recording',
//           notificationText: 'Background stream active...',
//           callback: startCallback,
//         );
//       }

//       s.url = widget.url;
//       s.chunkStartTime = DateTime.now();
//       s.isRecording = true;
//       s.isPaused = false;
//       _isRecording.value = true;
//       _isPaused.value = false;

//       _monitorFailures = 0;
//       _monitorGaveUp = false;
//       _stallTicks = 0;

//       // Optional: free the air unit's RTSP slot before FFmpeg connects.
//       // if (_playerUsable && kStopPreviewBeforeRecording) {
//       if (_playerUsable && kUseLoopbackPreview && kStopPreviewBeforeRecording) {
//         _monitorEpoch++;
//         _monitorOnLoopback = false;
//         await controller.player.stop();
//       }

//       // 1. Start FFmpeg (writes the file AND rebroadcasts on the loopback port).
//       await _spawnFFmpegProcess(s, startNum);

//       // 2. Switch the preview to the loopback feed only once FFmpeg is really
//       //    producing data. The direct feed stays visible until then.
//       if (_playerUsable) {
//         unawaited(_attachLoopbackMonitor());
//       }

//       _snack(
//         '${widget.label} Recording Started',
//         AppTheme.green,
//         style: GoogleFonts.jetBrainsMono(fontSize: 12),
//       );
//       updateDialog?.call();
//     } catch (e) {
//       _snack('Failed: $e', AppTheme.red);
//     }
//   }

//   Future<void> _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//     if (!s.isRecording || s.isPaused) return;

//     final dir = await _targetDir;
//     final String filePath =
//         '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//     s.currentFilePath = filePath;

//     // TCP transport (no gray pixel tearing) + two outputs:
//     //  1) UDP loopback for the live preview
//     //  2) the .ts file on storage
//     // dump_extra repeats SPS/PPS(/VPS) before every keyframe so a player that
//     // joins mid-stream (UDP has no handshake) can start decoding right away.
//     // final List<String> arguments = [
//     //   '-y',
//     //   '-timeout', '10000000',
//     //   '-rtsp_transport', 'tcp',
//     //   '-i', widget.url,

//     //   // Output 1: live monitor
//     //   '-c:v', 'copy', '-an',
//     //   '-bsf:v', 'dump_extra',
//     //   '-f', 'mpegts',
//     //   '-flush_packets', '1',
//     //   '-muxdelay', '0', '-muxpreload', '0',
//     //   _loopbackOutUrl,

//     //   // Output 2: file
//     //   '-c:v', 'copy', '-an',
//     //   '-bsf:v', 'dump_extra',
//     //   '-f', 'mpegts',
//     //   filePath,
//     // ];

// //     final List<String> arguments = [
// //   '-y',
// //   '-timeout', '10000000',
// //   '-rtsp_transport', 'tcp',
// //   '-i', widget.url,

// //   if (kUseLoopbackPreview) ...[
// //     // Output 1: live monitor
// //     '-c:v', 'copy', '-an',
// //     '-bsf:v', 'dump_extra',
// //     '-f', 'mpegts',
// //     '-flush_packets', '1',
// //     '-muxdelay', '0', '-muxpreload', '0',
// //     _loopbackOutUrl,
// //   ],

// //   // Output 2: file
// //   '-c:v', 'copy', '-an',
// //   '-bsf:v', 'dump_extra',
// //   '-f', 'mpegts',
// //   filePath,
// // ];h

// final List<String> arguments = [
//   '-y',
//   '-fflags', '+genpts+discardcorrupt',
//   '-use_wallclock_as_timestamps', '1',
//   '-timeout', '10000000',
//   '-rtsp_transport', 'tcp',
//   '-analyzeduration', '2000000',
//   '-probesize', '2000000',
//   '-i', widget.url,


//   '-map', '0:v:0', '-c:v', 'copy', '-an',
//   '-bsf:v', 'dump_extra',
//   '-avoid_negative_ts', 'make_zero',
//   '-f', 'mpegts',
//   '-mpegts_flags', '+resend_headers',
//   '-flush_packets', '1',
//   filePath,
// ];

//     try {
//       s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
//         final returnCode = await finishedSession.getReturnCode();
//         if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//           final logs = await finishedSession.getLogsAsString();
//           debugPrint("FFMPEG LOG: $logs");
//           _snack(
//             'CRASH: ${logs?.split('\n').where((l) => l.trim().isNotEmpty).lastOrNull ?? "Error"}',
//             Colors.red,
//             seconds: 10,
//           );
//         }

//         // This chunk is finished: it is no longer the "active" file. This also
//         // stops the monitor from mistaking the old (large) file for live data.
//         if (s.currentFilePath == filePath) s.currentFilePath = '';

//         await Future.delayed(const Duration(seconds: 1));
//         await _registerFile(File(filePath), tag: 'DB SAVED');

//         // Respawn only if this is still the current session (prevents a double
//         // spawn when the user pauses and resumes quickly).
//         final isCurrent =
//             s.session == null || s.session!.getSessionId() == finishedSession.getSessionId();

//         if (isCurrent && s.isRecording && !s.isPaused) {
//           await Future.delayed(const Duration(seconds: 1));
//           if (s.isRecording && !s.isPaused) {
//             final nextNum = await _getNextSequenceNumber(dir.path);
//             await _spawnFFmpegProcess(s, nextNum);
//             if (mounted && !_monitorGaveUp) {
//               unawaited(_attachLoopbackMonitor()); // re-attach to the new chunk's feed
//             }
//           }
//         }
//       });
//     } catch (e) {
//       debugPrint("FATAL DART ERROR: $e");
//     }
//   }

//   Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     s.isPaused = true;
//     _isPaused.value = true;
//     _monitorEpoch++;
//     _monitorOnLoopback = false;

//     if (s.session != null) {
//       await FFmpegKit.cancel(s.session!.getSessionId());
//       s.session = null;
//     }

//     if (s.chunkStartTime != null) {
//       s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
//     }

//     updateDialog?.call();

//     // The loopback feed is dead now; go back to the direct stream so the
//     // preview doesn't sit black while paused.
//     await Future.delayed(const Duration(milliseconds: 800));
//     if (mounted && session.isPaused) {
//       await _showDirectFeed();
//     }
//   }

//   Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
//     try {
//       final s = session;
//       s.isRecording = false;
//       s.isPaused = false;
//       _isRecording.value = false;
//       _isPaused.value = false;
//       _timerText.value = "00:00:00";
//       _monitorEpoch++; // cancel any pending attach
//       _monitorOnLoopback = false;

//       _snack('Stopping ${widget.label}...', AppTheme.amber, seconds: 2);

//       // Stop FFmpeg FIRST so the air unit's RTSP session is released...
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//         s.session = null;
//       }

//       // ...then bring the preview back to the direct stream.
//       await Future.delayed(const Duration(milliseconds: 800));
//       await _showDirectFeed();

//       await Future.delayed(const Duration(milliseconds: 1500));
//       s.currentFilePath = '';

//       await _registerCompletedChunks();

//       GlobalRecordingManager.sessions.remove(widget.label);

//       if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
//         await FlutterForegroundTask.stopService();
//       }
//     } catch (e) {
//       debugPrint("Stop error: $e");
//     }
//     updateDialog?.call();
//   }

//   // ---------------------------------------------------------------------------
//   // Snapshot
//   // ---------------------------------------------------------------------------

//   Future<void> _takeSnapshot(ScreenshotController targetController, {VoidCallback? updateDialog}) async {
//     if (_isTakingSnap || !_isStreamReady) return;
//     _isTakingSnap = true;
//     if (mounted) setState(() {});
//     updateDialog?.call();

//     try {
//       final bytes = await targetController.capture(pixelRatio: 4.0);
//       if (bytes != null) {
//         final dir = await _targetDir;
//         if (!await dir.exists()) await dir.create(recursive: true);

//         final timestamp = DateTime.now();
//         final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
//         await File(filePath).writeAsBytes(bytes);

//         _isTakingSnap = false;
//         if (mounted) setState(() {});
//         updateDialog?.call();

//         if (mounted) {
//           bool isIssue = false;
//           TextEditingController descCtrl = TextEditingController();
//           await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (ctx) => StatefulBuilder(
//               builder: (context, setModalState) => AlertDialog(
//                 backgroundColor: AppTheme.bgPanel,
//                 title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SwitchListTile(
//                       title: Text('Flag as Maintenance Issue?', style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
//                       activeColor: AppTheme.red,
//                       value: isIssue,
//                       onChanged: (v) => setModalState(() => isIssue = v),
//                     ),
//                     if (isIssue)
//                       TextField(
//                         controller: descCtrl,
//                         style: TextStyle(color: AppTheme.textHi, fontSize: 12),
//                         decoration: InputDecoration(
//                           hintText: "Describe the damage/issue...",
//                           hintStyle: TextStyle(color: AppTheme.textLo),
//                         ),
//                       ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(ctx);
//                       widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
//                     },
//                     child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();
//     }
//   }

//   // ---------------------------------------------------------------------------
//   // UI
//   // ---------------------------------------------------------------------------

//   Widget _buildRecordingControls(VoidCallback updateState) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isRecording,
//       builder: (context, isRec, _) {
//         return ValueListenableBuilder<bool>(
//           valueListenable: _isPaused,
//           builder: (context, isPau, _) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isRec && !isPau)
//                   GestureDetector(
//                     onTap: () => _startOrResumeRecording(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
//                     ),
//                   )
//                 else ...[
//                   GestureDetector(
//                     onTap: () => _stopEntirely(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       if (isRec && !isPau) {
//                         _pauseRecording(updateDialog: updateState);
//                       } else {
//                         _startOrResumeRecording(updateDialog: updateState);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(color: isPau ? AppTheme.amber : Colors.white, shape: BoxShape.circle),
//                       child: Icon(isPau ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.black, size: 16),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showFloatingScreen() {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.95),
//       barrierDismissible: true,
//       barrierLabel: 'LiveFeed',
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (ctx, anim1, anim2) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: StatefulBuilder(
//               builder: (context, setDialogState) {
//                 return Stack(
//                   children: [
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: Screenshot(
//                           controller: _fsController,
//                           child: _isStreamReady
//                               ? Video(controller: controller, fit: BoxFit.contain, controls: NoVideoControls)
//                               : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
//                         onPressed: () => Navigator.pop(ctx),
//                       ),
//                     ),
//                     Positioned(
//                       top: 24,
//                       left: 24,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: AppTheme.bgCard.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: AppTheme.cyan),
//                             ),
//                             child: Text('${widget.label} (LIVE)', style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold)),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: _isRecording,
//                             builder: (context, isRec, _) {
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: _isPaused,
//                                 builder: (context, isPau, _) {
//                                   if (!isRec && !isPau) return const SizedBox.shrink();
//                                   return Row(
//                                     children: [
//                                       const SizedBox(width: 12),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.red.withOpacity(0.8),
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(color: AppTheme.red),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.circle, color: Colors.white, size: 10),
//                                             const SizedBox(width: 6),
//                                             ValueListenableBuilder<String>(
//                                               valueListenable: _timerText,
//                                               builder: (ctx, time, _) => Text('REC $time', style: GoogleFonts.jetBrainsMono(color: Colors.white, fontWeight: FontWeight.bold)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (isPau) ...[
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.amber.withOpacity(0.8),
//                                             borderRadius: BorderRadius.circular(6),
//                                             border: Border.all(color: AppTheme.amber),
//                                           ),
//                                           child: Text('PAUSED', style: GoogleFonts.jetBrainsMono(color: Colors.black, fontWeight: FontWeight.bold)),
//                                         ),
//                                       ],
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 30,
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.5,
//                             child: _buildRecordingControls(() => setDialogState(() {})),
//                           ),
//                           const SizedBox(width: 40),
//                           GestureDetector(
//                             onTap: () => _takeSnapshot(_fsController, updateDialog: () => setDialogState(() {})),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                                 shape: BoxShape.circle,
//                                 boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
//                               ),
//                               child: _isTakingSnap
//                                   ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
//                                   : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _monitorEpoch++; // cancel any pending attach
//     _uiTimer?.cancel();
//     _chunkScannerTimer?.cancel();
//     _monitorTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final hasUrl = widget.url.isNotEmpty;
//     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

//     return GestureDetector(
//       onTap: (hasUrl && !isError) ? _showFloatingScreen : null,
//       child: Container(
//         height: h,
//         decoration: BoxDecoration(
//           color: AppTheme.bgRaised,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppTheme.borderDim),
//         ),
//         child: Stack(
//           children: [
//             if (hasUrl && !isError)
//               Screenshot(
//                 controller: _smallController,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: _isStreamReady
//                       ? Video(controller: controller, fit: BoxFit.cover, controls: NoVideoControls)
//                       : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                 ),
//               )
//             else
//               Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   StatusBadge(
//                     label: hasUrl ? (isError ? 'ERROR' : 'LIVE') : 'OFFLINE',
//                     color: hasUrl ? (isError ? AppTheme.red : AppTheme.green) : AppTheme.red,
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: _isRecording,
//                     builder: (context, isRec, _) {
//                       return ValueListenableBuilder<bool>(
//                         valueListenable: _isPaused,
//                         builder: (context, isPau, _) {
//                           if (!isRec && !isPau) return const SizedBox.shrink();
//                           return Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               ValueListenableBuilder<String>(
//                                 valueListenable: _timerText,
//                                 builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
//                               ),
//                               if (isPau) ...[
//                                 const SizedBox(width: 8),
//                                 StatusBadge(label: 'PAUSED', color: AppTheme.amber),
//                               ],
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (hasUrl && !isError)
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     _buildRecordingControls(() {}),
//                     const SizedBox(width: 10),
//                     // if(widget.showRecordButton) ...[
//                     //   _buildRecordingControls(() {}),
//                     //   const SizedBox(width: 10)
//                     // ]
//                     // Positioned(
//                     //   bottom: 30,
//                     //   right: 30,
//                     //   child: Row(
//                     //     children: [
//                     //       if (widget.showRecordButton) ...[
//                     //         Transform.scale(
//                     //           scale: 1.5,
//                     //           child: _buildRecordingControls(() => setDialogState(() {})),
//                     //         ),
//                     //         const SizedBox(width: 40),
//                     //       ],
//                     GestureDetector(
//                       onTap: () => _takeSnapshot(_smallController),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: _isTakingSnap ? Colors.grey : AppTheme.cyan, shape: BoxShape.circle),
//                         child: _isTakingSnap
//                             ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                             : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:async';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';

// import '../../../core/services/recording_service.dart';
// import '../../../ui/app_theme.dart';
// import '../../../ui/gcs_widgets.dart';

// class RecordSessionState {
//   FFmpegSession? session;
//   String url = '';
//   DateTime? chunkStartTime;
//   Duration accumulatedTime = Duration.zero;
//   bool isRecording = false;
//   bool isPaused = false;
//   String currentFilePath = '';
// }

// class GlobalRecordingManager {
//   static final Map<String, RecordSessionState> sessions = {};
//   static final Set<String> registeredFiles = {};

//   static bool isCameraRecording(String url) {
//     return sessions.values.any((s) => s.url == url && s.isRecording);
//   }

//   static Future<void> stopAll() async {
//     for (var s in sessions.values) {
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//       }
//     }
//     sessions.clear();
//   }
// }

// // class GlobalStreamCache {
// //   static final Map<String, Player> players = {};
// //   static final Map<String, VideoController> controllers = {};

// //   static String? get activeStreamUrl => players.keys.firstOrNull;

// //   static VideoController getController(String url) {
// //     if (players.containsKey(url)) {
// //       players[url]!.play();
// //       return controllers[url]!;
// //     }
// // class GlobalStreamCache {
// //   static final Map<String, Player> players = {};
// //   static final Map<String, VideoController> controllers = {};
// //   static final Map<String, String> currentSource = {};
// //   static final Map<String, String> relayUrls = {};   // camera url -> local udp url

// //   static String? get activeStreamUrl => players.keys.firstOrNull;

// //   static VideoController getController(String url) {
// //     if (players.containsKey(url)) {
// //       final recording = GlobalRecordingManager.sessions.values
// //           .any((s) => s.url == url && s.isRecording && !s.isPaused);
// //       final want = (recording && relayUrls.containsKey(url)) ? relayUrls[url]! : url;
// //       switchSource(url, want);
// //       return controllers[url]!;
// //     }

// //     final player = Player(
// //       configuration: const PlayerConfiguration(
// //         bufferSize: 1024 * 1024 * 4,
// //         logLevel: MPVLogLevel.error,
// //       ),
// //     );

// //     final controller = VideoController(player);

// // //     void retryRelay(dynamic _) {
// // //   final recording = GlobalRecordingManager.sessions.values
// // //       .any((s) => s.url == url && s.isRecording && !s.isPaused);
// // //   if (recording && currentSource[url] == relayUrls[url]) {
// // //     Future.delayed(const Duration(seconds: 1), () {
// // //       if (relayUrls[url] != null && currentSource[url] == relayUrls[url]) {
// // //         switchSource(url, relayUrls[url]!, force: true);
// // //       }
// // //     });
// // //   }
// // // // }
// // // player.stream.completed.listen((done) { if (done) retryRelay(null); });
// // // player.stream.error.listen(retryRelay);

// //     // try {
// //     //   final mpv = player.platform as dynamic;
// //     //   mpv.setProperty('profile', 'low-latency');
// //     //   mpv.setProperty('audio', 'no');
// //     //   mpv.setProperty('hwdec', 'auto');
// //     //   mpv.setProperty('network-timeout', '3');
// //     //   mpv.setProperty('cache-pause', 'no');
// //     // } catch (e) {
// //     //   debugPrint("MPV Config Error: $e");
// //     // }
// //     final mpv = player.platform as dynamic;
// //     mpv.setProperty('profile', 'low-latency');
// //     mpv.setProperty('audio', 'no');
// //     mpv.setProperty('hwdec', 'mediacodec-copy');
// //     mpv.setProperty('network-timeout', '3');
// //     mpv.setProperty('cache-pause', 'no');
// //     mpv.setProperty('demuxer-lavf-o', 'rtsp_transport=tcp');
// //     mpv.setProperty('demuxer-lavf-analyzeduration', '0.5');

// //     player.open(Media(url), play: true);
// //     players[url] = player;
// //     controllers[url] = controller;

// //     return controller;
// //   }
// //   static void switchSource(String url, String newSource) {
// //     final p = players[url];
// //     if (p == null) return;
// //     if (currentSource[url] == newSource) {
// //       p.play();
// //       return;
// //     }
// //     p.open(Media(newSource), play: true);
// //     currentSource[url] = newSource;
// //   }

// //   static Future<void> releaseAll() async {
// //     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) {
// //       return;
// //     }

// //     for (var p in players.values) {
// //       p.dispose();
// //     }
// //     players.clear();
// //     controllers.clear();
// //     FlutterForegroundTask.stopService();
// //   }
// // }

// class GlobalStreamCache {
//   static final Map<String, Player> players = {};
//   static final Map<String, VideoController> controllers = {};
//   static final Map<String, String> currentSource = {};
//   static final Map<String, String> relayUrls = {};

//   static String? get activeStreamUrl => players.keys.firstOrNull;

//   static bool _isRelayActive(String url) =>
//       relayUrls.containsKey(url) &&
//       GlobalRecordingManager.sessions.values
//           .any((s) => s.url == url && s.isRecording && !s.isPaused);

//   static VideoController getController(String url) {
//     if (players.containsKey(url)) {
//       final want = _isRelayActive(url) ? relayUrls[url]! : url;
//       switchSource(url, want);
//       return controllers[url]!;
//     }

//     final player = Player(
//       configuration: const PlayerConfiguration(
//         bufferSize: 1024 * 1024 * 4,
//         logLevel: MPVLogLevel.error,
//       ),
//     );
//     final controller = VideoController(player);

//     try {
//       final mpv = player.platform as dynamic;
//       mpv.setProperty('profile', 'low-latency');
//       mpv.setProperty('audio', 'no');
//       mpv.setProperty('hwdec', 'mediacodec-copy');
//       mpv.setProperty('network-timeout', '3');
//       mpv.setProperty('cache-pause', 'no');
//       mpv.setProperty('demuxer-lavf-o', 'rtsp_transport=tcp');
//       mpv.setProperty('demuxer-lavf-analyzeduration', '0.5');
//     } catch (e) {
//       debugPrint("MPV Config Error: $e");
//     }

//     // Retry the local relay if it ends or errors while recording
//     void retryRelay(dynamic _) {
//       if (_isRelayActive(url) && currentSource[url] == relayUrls[url]) {
//         Future.delayed(const Duration(seconds: 1), () {
//           if (_isRelayActive(url) && currentSource[url] == relayUrls[url]) {
//             switchSource(url, relayUrls[url]!, force: true);
//           }
//         });
//       }
//     }
//     player.stream.completed.listen((done) { if (done) retryRelay(null); });
//     player.stream.error.listen(retryRelay);

//     player.open(Media(url), play: true);
//     currentSource[url] = url;
//     players[url] = player;
//     controllers[url] = controller;
//     return controller;
//   }

//   static void switchSource(String url, String newSource, {bool force = false}) {
//     final p = players[url];
//     if (p == null) return;
//     if (!force && currentSource[url] == newSource) {
//       p.play();
//       return;
//     }
//     debugPrint('SWITCH $url -> $newSource');
//     p.open(Media(newSource), play: true);
//     currentSource[url] = newSource;
//   }

//   static Future<void> releaseAll() async {
//     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) return;
//     for (var p in players.values) { p.dispose(); }
//     players.clear();
//     controllers.clear();
//     currentSource.clear();
//     relayUrls.clear();
//     FlutterForegroundTask.stopService();
//   }
// }
// class CameraView extends StatefulWidget {
//   final String url;
//   final String label;
//   final String taskName;
//   final int faceNumber;
//   // Reverted back to standard Function so WiperMainScreen doesn't crash the build!
//   final Function(String, DateTime, String, bool, String)? onSnapshot;
//   final Function(String, DateTime, String)? onVideoRecorded;

//   const CameraView({
//     super.key,
//     required this.url,
//     required this.label,
//     required this.taskName,
//     this.faceNumber = 1,
//     this.onSnapshot,
//     this.onVideoRecorded,
//   });

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView>
//     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
//   final ScreenshotController _smallController = ScreenshotController();
//   final ScreenshotController _fsController = ScreenshotController();

//   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
//   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
//   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

//   bool _isTakingSnap = false;
//   late final VideoController controller;
//   bool isError = false;
//   bool _isStreamReady = false;

//   Timer? _uiTimer;
//   Timer? _chunkScannerTimer;

//   // 05-10-2026 - for live camera recording
//   String get _localUdpUrl {
//     int port = widget.label.endsWith('A') ? 6001 : 6002;
//     // return 'udp://127.0.0.1:$port';
//     // Add pkt_size=1316 to force standard MPEG-TS packet sizing
//     return 'udp://127.0.0.1:$port?pkt_size=1316';
//   }

//   String get _basePrefix {
//     final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
//   }

//   RecordSessionState get session {
//     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
//       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
//     }
//     return GlobalRecordingManager.sessions[widget.label]!;
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _recoverRecordingState();
//     _startTimers();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (mounted) _initStream();
//       });
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _isStreamReady && mounted) {
//       controller.player.play();
//     }
//   }

//   void _startTimers() {
//     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final s = session;
//       if (s.isRecording) {
//         Duration d = s.accumulatedTime;
//         if (!s.isPaused && s.chunkStartTime != null) {
//           d += DateTime.now().difference(s.chunkStartTime!);
//         }
//         String h = d.inHours.toString().padLeft(2, '0');
//         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
//         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
//         _timerText.value = "$h:$m:$sec";
//       }
//     });

//     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       if (session.isRecording) {
//         await _registerCompletedChunks();
//       }
//     });
//   }

//   void _initStream() {
//     if (widget.url.isNotEmpty && mounted) {
//       try {
//         controller = GlobalStreamCache.getController(widget.url);
//         setState(() {
//           isError = false;
//           _isStreamReady = true;
//         });
//       } catch (e) {
//         setState(() {
//           isError = true;
//           _isStreamReady = true;
//         });
//       }
//     } else {
//       if (mounted) setState(() => _isStreamReady = true);
//     }
//   }

//   void _recoverRecordingState() {
//     final s = session;
//     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
//       _isRecording.value = s.isRecording;
//       _isPaused.value = s.isPaused;
//     }
//   }

//   Future<Directory> get _targetDir async {
//     Directory? baseDir;
//     if (Platform.isAndroid) {
//       baseDir = await getExternalStorageDirectory();
//     }
//     baseDir ??= await getApplicationDocumentsDirectory();

//     final dir = Directory('${baseDir.path}/VividGCS_Videos');
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//     return dir;
//   }

//   Future<int> _getNextSequenceNumber(String dirPath) async {
//     final dir = Directory(dirPath);
//     int maxNum = -1;
//     if (await dir.exists()) {
//       final files = dir.listSync();
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
//           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
//           if (match != null) {
//             final num = int.tryParse(match.group(1)!) ?? -1;
//             if (num > maxNum) maxNum = num;
//           }
//         }
//       }
//     }
//     return maxNum + 1;
//   }

//   Future<void> _registerCompletedChunks() async {
//     try {
//       final dir = await _targetDir;
//       if (!await dir.exists()) return;
//       final files = dir.listSync();

//       final currentActiveFile = session.currentFilePath;

//       List<File> matchedFiles = [];
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.contains(_basePrefix) && name.endsWith('.ts')) {
//           // Ignore the active file completely!
//           if (file.path != currentActiveFile) {
//             matchedFiles.add(File(file.path));
//           }
//         }
//       }

//       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

//       for (var file in matchedFiles) {
//         if (!GlobalRecordingManager.registeredFiles.contains(file.path)) {
//           final length = await file.length();
          
//           if (length > 0) { 
//             try {
//               widget.onVideoRecorded?.call(
//                 file.path,
//                 file.lastModifiedSync(),
//                 widget.label,
//               );
//               GlobalRecordingManager.registeredFiles.add(file.path);
              
//               if (mounted) {
//                 final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('✅ SCANNER SAVED: $mb MB'), backgroundColor: Colors.green),
//                 );
//               }
//             } catch (e) {
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('❌ DB ERROR (Scanner): $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//                 );
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Scanner Error: $e");
//     }
//   }

//   // Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//   //   final s = session;
//   //   if (s.isRecording && !s.isPaused) return;

//   //   try {
//   //     if (Platform.isAndroid) {
//   //       if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//   //         await FlutterForegroundTask.requestNotificationPermission();
//   //       }
//   //       if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//   //         await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//   //       }
//   //     }

//   //     final dir = await _targetDir;
//   //     final startNum = await _getNextSequenceNumber(dir.path);

//   //     if (!await FlutterForegroundTask.isRunningService) {
//   //       await FlutterForegroundTask.startService(
//   //         notificationTitle: 'Vivid GCS Recording',
//   //         notificationText: 'Background stream active...',
//   //         callback: startCallback,
//   //       );
//   //     }

//   //     s.url = widget.url;
//   //     s.chunkStartTime = DateTime.now();
//   //     s.isRecording = true;
//   //     s.isPaused = false;
//   //     _isRecording.value = true;
//   //     _isPaused.value = false;

//   //     _spawnFFmpegProcess(s, startNum);

//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text(
//   //             '${widget.label} Recording Started',
//   //             style: GoogleFonts.jetBrainsMono(fontSize: 12),
//   //           ),
//   //           backgroundColor: AppTheme.green,
//   //         ),
//   //       );
//   //     }
//   //     updateDialog?.call();
//   //   } catch (e) {
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//   //       );
//   //     }
//   //   }
//   // }

//   // 05-10-26 foe video recording

//   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     if (s.isRecording && !s.isPaused) return;

//     try {
//       if (Platform.isAndroid) {
//         if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//           await FlutterForegroundTask.requestNotificationPermission();
//         }
//         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//         }
//       }

//       final dir = await _targetDir;
//       final startNum = await _getNextSequenceNumber(dir.path);

//       if (!await FlutterForegroundTask.isRunningService) {
//         await FlutterForegroundTask.startService(
//           notificationTitle: 'Vivid GCS Recording',
//           notificationText: 'Background stream active...',
//           callback: startCallback,
//         );
//       }

//       s.url = widget.url;
//       s.chunkStartTime = DateTime.now();
//       s.isRecording = true;
//       s.isPaused = false;
//       _isRecording.value = true;
//       _isPaused.value = false;

//       // 1. Spawn FFmpeg first so it negotiates the airunit - mk32 connection
//       // _spawnFFmpegProcess(s, startNum);

//       // 2. Wait 1.5 seconds for FFmpeg to start pushing data, THEN connect MediaKit
//       // if (_isStreamReady) {
//       //   // Future.delayed(const Duration(milliseconds: 1500), () {
//       //   Future.delayed(const Duration(seconds: 2), () {
//       //     if (mounted && session.isRecording) {
//       //       controller.player.open(Media(_localUdpUrl), play: true);
//       //     }
//       //   });
//       // }
// //       GlobalStreamCache.relayUrls[widget.url] = _localUdpUrl;
// // _spawnFFmpegProcess(s, startNum);
// // Future.delayed(const Duration(seconds: 2), () {
// //   if (session.isRecording && !session.isPaused) {
// //     GlobalStreamCache.switchSource(widget.url, _localUdpUrl);
// //   }
// // });
// GlobalStreamCache.relayUrls[widget.url] = _localUdpUrl;
// _spawnFFmpegProcess(s, startNum);
// Future.delayed(const Duration(seconds: 86400), () {
//   if (session.isRecording && !session.isPaused) {
//     GlobalStreamCache.switchSource(widget.url, _localUdpUrl, force: true);
//   }
// });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
//             backgroundColor: AppTheme.green,
//           ),
//         );
//       }
//       updateDialog?.call();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//         );
//       }
//     }
//   }

//   //     s.url = widget.url;
//   //     s.chunkStartTime = DateTime.now();
//   //     s.isRecording = true;
//   //     s.isPaused = false;
//   //     _isRecording.value = true;
//   //     _isPaused.value = false;

//   //     // Switch MediaKit to monitor the internal FFmpeg stream
//   //     if (_isStreamReady) {
//   //       controller.player.open(Media(_localUdpUrl), play: true);
//   //     }

//   //     _spawnFFmpegProcess(s, startNum);

//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
//   //           backgroundColor: AppTheme.green,
//   //         ),
//   //       );
//   //     }
//   //     updateDialog?.call();
//   //   } catch (e) {
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//   //       );
//   //     }
//   //   }
//   // }

//   // void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//   //   if (!s.isRecording || s.isPaused) return;

//   //   final dir = await _targetDir;
//   //   final String currentFilePath = '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//   //   s.currentFilePath = currentFilePath;

//   //   // // THE PERFECT STABLE COMMAND (No TCP, No Hangs)
//   //   // List<String> arguments = ['-y'];

//   //   // if (widget.url.toLowerCase().startsWith('rtsp')) {
//   //   //   arguments.addAll(['-stimeout', '5000000']); 
//   //   // } else if (widget.url.toLowerCase().startsWith('udp')) {
//   //   //   arguments.addAll(['-timeout', '5000000']);
//   //   // }

//   //   // arguments.addAll([
//   //   //   '-fflags', '+genpts+discardcorrupt',
//   //   //   '-use_wallclock_as_timestamps', '1',
//   //   //   '-i', widget.url,
//   //   //   '-c:v', 'copy',
//   //   //   '-an',
//   //   //   '-f', 'mpegts', 
//   //   //   '-t', '900', 
//   //   //   currentFilePath
//   //   // ]);

//   //   // List<String> arguments = [
//   //   //   '-y',
//   //   //   '-i', widget.url,
//   //   //   '-c', 'copy',
//   //   //   '-f', 'mpegts', 
//   //   //   currentFilePath
//   //   // ];

//   //   List<String> arguments = [
//   //     '-y',
//   //     '-timeout', '10000000',      // 10 second timeout to prevent instant crashes
//   //     '-rtsp_transport', 'tcp',    // FORCE TCP TO FIX PIXEL BREAKAGE
//   //     '-i', widget.url,
//   //     '-c:v', 'copy',              // Copy video stream without re-encoding
//   //     '-an',                       // Drop audio to save bandwidth
//   //     '-f', 'mpegts', 
//   //     currentFilePath
//   //   ];

//   //   try {
//   //     s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
        
//   //       final returnCode = await finishedSession.getReturnCode();
//   //       if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//   //         final logs = await finishedSession.getLogsAsString();
//   //         debugPrint("FFMPEG LOG: $logs");
//   //         if (mounted) {
//   //           ScaffoldMessenger.of(context).showSnackBar(
//   //             SnackBar(content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//   //           );
//   //         }
//   //       }

//   //       await Future.delayed(const Duration(seconds: 1));

//   //       final file = File(currentFilePath);
//   //       if (await file.exists()) {
//   //         final length = await file.length();
          
//   //         if (length > 0) { 
//   //           if (!GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
//   //             try {
//   //               widget.onVideoRecorded?.call(
//   //                 currentFilePath,
//   //                 DateTime.now(),
//   //                 widget.label,
//   //               );
//   //               GlobalRecordingManager.registeredFiles.add(currentFilePath);
                
//   //               if (mounted) {
//   //                  final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//   //                  ScaffoldMessenger.of(context).showSnackBar(
//   //                    SnackBar(content: Text('✅ DB SAVED: $mb MB'), backgroundColor: Colors.green, duration: const Duration(seconds: 5)),
//   //                  );
//   //               }
//   //             } catch (e) {
//   //               if (mounted) {
//   //                  ScaffoldMessenger.of(context).showSnackBar(
//   //                    SnackBar(content: Text('❌ DB ERROR: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//   //                  );
//   //               }
//   //             }
//   //           }
//   //         }
//   //       }

//   //       if (s.isRecording && !s.isPaused) {
//   //         await Future.delayed(const Duration(seconds: 1));
//   //         final nextNum = await _getNextSequenceNumber(dir.path);
//   //         _spawnFFmpegProcess(s, nextNum);
//   //       }
//   //     });
//   //   } catch (e) {
//   //     debugPrint("FATAL DART ERROR: $e");
//   //   }
//   // }

//   // 05-10-2026 for live video recording stability

//   void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//     if (!s.isRecording || s.isPaused) return;

//     final dir = await _targetDir;
//     final String currentFilePath = '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//     s.currentFilePath = currentFilePath;

//     // Master FFmpeg Command (TCP Transport + Dual Output)
//     // List<String> arguments = [
//     //   '-y',
//     //   '-timeout', '10000000',
//     //   '-rtsp_transport', 'tcp', // Forces reliable packets, eliminating gray pixel tearing
//     //   '-i', widget.url,
      
//     //   // Output 1: Rebroadcast internally for MediaKit to display lively
//     //   // '-c:v', 'copy',
//     //   // '-an',
//     //   // '-f', 'mpegts',
//     //   // '-flush_packets', '1', // Pushes frames instantly to prevent player timeout 
//     //   // '-drop_pkts_on_overflow', '1',  // Prevents internal memory crashes
//     //   // '-fifo_size', '100000',
//     //   // _localUdpUrl,

//     //   // Output 1: live preview
//     //   '-c:v', 'copy',
//     //   '-an',
//     //   '-bsf:v', 'dump_extra',          // repeat SPS/PPS before each keyframe
//     //   '-f', 'mpegts',
//     //   '-mpegts_flags', '+resend_headers',
//     //   '-pat_period', '0.5',
//     //   '-flush_packets', '1',
//     //   '$_localUdpUrl&fifo_size=5000000&overrun_nonfatal=1',
      
//     //   // Output 2: Record to the storage drive
//     //   '-c:v', 'copy',
//     //   '-an',
//     //   '-f', 'mpegts', 
//     //   currentFilePath
//     // ];
//     List<String> arguments = [
//   '-y',
//   '-timeout', '10000000',
//   '-rtsp_transport', 'tcp',
//   '-fflags', '+genpts+discardcorrupt',
//   '-i', widget.url,

//   // Output 1: local preview relay
//   '-c:v', 'copy', '-an',
//   '-bsf:v', 'dump_extra',
//   '-f', 'mpegts',
//   '-mpegts_flags', '+resend_headers',
//   '-pat_period', '0.5',
//   '-flush_packets', '1',
//   '$_localUdpUrl&fifo_size=5000000&overrun_nonfatal=1',

//   // Output 2: file
//   '-c:v', 'copy', '-an',
//   '-f', 'mpegts',
//   currentFilePath,
// ];

//     try {
//       s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
        
//         final returnCode = await finishedSession.getReturnCode();
//         if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//           final logs = await finishedSession.getLogsAsString();
//           debugPrint("FFMPEG LOG: $logs");
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//             );
//           }
//         }

//         await Future.delayed(const Duration(seconds: 1));

//         final file = File(currentFilePath);
//         if (await file.exists()) {
//           final length = await file.length();
          
//           if (length > 0) { 
//             if (!GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
//               try {
//                 widget.onVideoRecorded?.call(
//                   currentFilePath,
//                   DateTime.now(),
//                   widget.label,
//                 );
//                 GlobalRecordingManager.registeredFiles.add(currentFilePath);
                
//                 if (mounted) {
//                    final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                    ScaffoldMessenger.of(context).showSnackBar(
//                      SnackBar(content: Text('✅ DB SAVED: $mb MB'), backgroundColor: Colors.green, duration: const Duration(seconds: 5)),
//                    );
//                 }
//               } catch (e) {
//                 if (mounted) {
//                    ScaffoldMessenger.of(context).showSnackBar(
//                      SnackBar(content: Text('❌ DB ERROR: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//                    );
//                 }
//               }
//             }
//           }
//         }

//         // if (s.isRecording && !s.isPaused) {
//         //   await Future.delayed(const Duration(seconds: 1));
//         //   final nextNum = await _getNextSequenceNumber(dir.path);
//         //   _spawnFFmpegProcess(s, nextNum);
//         // }
//         if (s.isRecording && !s.isPaused) {
//   await Future.delayed(const Duration(seconds: 1));
//   final nextNum = await _getNextSequenceNumber(dir.path);
//   _spawnFFmpegProcess(s, nextNum);
//   Future.delayed(const Duration(seconds: 2), () {
//     if (s.isRecording && !s.isPaused) {
//       GlobalStreamCache.switchSource(widget.url, _localUdpUrl, force: true);
//     }
//   });
// }
//       });
//     } catch (e) {
//       debugPrint("FATAL DART ERROR: $e");
//     }
//   }

//   Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     s.isPaused = true;
//     _isPaused.value = true;

//     GlobalStreamCache.switchSource(widget.url, widget.url, force: true);

//     if (s.session != null) {
//       await FFmpegKit.cancel(s.session!.getSessionId());
//       s.session = null;
//     }

//     if (s.chunkStartTime != null) {
//       s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
//     }
    
//     updateDialog?.call();
//   }

//   Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
//     try {
//       final s = session;
//       s.isRecording = false;
//       s.isPaused = false;
//       _isRecording.value = false;
//       _isPaused.value = false;
//       _timerText.value = "00:00:00";

//       GlobalStreamCache.switchSource(widget.url, widget.url, force: true);

//       // Revert MediaKit back to the direct Air Unit stream
//       // if (_isStreamReady) {
//       //   controller.player.open(Media(widget.url), play: true);
//       // }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Stopping ${widget.label}...'),
//             backgroundColor: AppTheme.amber,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }

//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//         s.session = null;
//       }

//       await Future.delayed(const Duration(seconds: 2));
//       s.currentFilePath = '';
      
//       await _registerCompletedChunks();

//       GlobalRecordingManager.sessions.remove(widget.label);

//       if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
//         await FlutterForegroundTask.stopService();
//       }

//     } catch (e) {
//       debugPrint("Stop error: $e");
//     }
//     updateDialog?.call();
//   }

//   Future<void> _takeSnapshot(ScreenshotController targetController, {VoidCallback? updateDialog}) async {
//     if (_isTakingSnap || !_isStreamReady) return;
//     _isTakingSnap = true;
//     if (mounted) setState(() {});
//     updateDialog?.call();

//     try {
//       final bytes = await targetController.capture(pixelRatio: 4.0);
//       if (bytes != null) {
//         final dir = await _targetDir;
//         if (!await dir.exists()) await dir.create(recursive: true);

//         final timestamp = DateTime.now();
//         final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
//         await File(filePath).writeAsBytes(bytes);

//         _isTakingSnap = false;
//         if (mounted) setState(() {});
//         updateDialog?.call();

//         if (mounted) {
//           bool isIssue = false;
//           TextEditingController descCtrl = TextEditingController();
//           await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (ctx) => StatefulBuilder(
//               builder: (context, setModalState) => AlertDialog(
//                 backgroundColor: AppTheme.bgPanel,
//                 title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SwitchListTile(
//                       title: Text('Flag as Maintenance Issue?', style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
//                       activeColor: AppTheme.red,
//                       value: isIssue,
//                       onChanged: (v) => setModalState(() => isIssue = v),
//                     ),
//                     if (isIssue)
//                       TextField(
//                         controller: descCtrl,
//                         style: TextStyle(color: AppTheme.textHi, fontSize: 12),
//                         decoration: InputDecoration(
//                           hintText: "Describe the damage/issue...",
//                           hintStyle: TextStyle(color: AppTheme.textLo),
//                         ),
//                       ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(ctx);
//                       widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
//                     },
//                     child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();
//     }
//   }

//   Widget _buildRecordingControls(VoidCallback updateState) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isRecording,
//       builder: (context, isRec, _) {
//         return ValueListenableBuilder<bool>(
//           valueListenable: _isPaused,
//           builder: (context, isPau, _) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isRec && !isPau)
//                   GestureDetector(
//                     onTap: () => _startOrResumeRecording(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
//                     ),
//                   )
//                 else ...[
//                   GestureDetector(
//                     onTap: () => _stopEntirely(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       if (isRec && !isPau) {
//                         _pauseRecording(updateDialog: updateState);
//                       } else {
//                         _startOrResumeRecording(updateDialog: updateState);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(color: isPau ? AppTheme.amber : Colors.white, shape: BoxShape.circle),
//                       child: Icon(isPau ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.black, size: 16),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showFloatingScreen() {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.95),
//       barrierDismissible: true,
//       barrierLabel: 'LiveFeed',
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (ctx, anim1, anim2) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: StatefulBuilder(
//               builder: (context, setDialogState) {
//                 return Stack(
//                   children: [
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: Screenshot(
//                           controller: _fsController,
//                           child: _isStreamReady
//                               ? Video(controller: controller, fit: BoxFit.contain, controls: NoVideoControls)
//                               : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
//                         onPressed: () => Navigator.pop(ctx),
//                       ),
//                     ),
//                     Positioned(
//                       top: 24,
//                       left: 24,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: AppTheme.bgCard.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: AppTheme.cyan),
//                             ),
//                             child: Text('${widget.label} (LIVE)', style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold)),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: _isRecording,
//                             builder: (context, isRec, _) {
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: _isPaused,
//                                 builder: (context, isPau, _) {
//                                   if (!isRec && !isPau) return const SizedBox.shrink();
//                                   return Row(
//                                     children: [
//                                       const SizedBox(width: 12),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.red.withOpacity(0.8),
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(color: AppTheme.red),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.circle, color: Colors.white, size: 10),
//                                             const SizedBox(width: 6),
//                                             ValueListenableBuilder<String>(
//                                               valueListenable: _timerText,
//                                               builder: (ctx, time, _) => Text('REC $time', style: GoogleFonts.jetBrainsMono(color: Colors.white, fontWeight: FontWeight.bold)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (isPau) ...[
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.amber.withOpacity(0.8),
//                                             borderRadius: BorderRadius.circular(6),
//                                             border: Border.all(color: AppTheme.amber),
//                                           ),
//                                           child: Text('PAUSED', style: GoogleFonts.jetBrainsMono(color: Colors.black, fontWeight: FontWeight.bold)),
//                                         ),
//                                       ],
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 30,
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.5,
//                             child: _buildRecordingControls(() => setDialogState(() {})),
//                           ),
//                           const SizedBox(width: 40),
//                           GestureDetector(
//                             onTap: () => _takeSnapshot(_fsController, updateDialog: () => setDialogState(() {})),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                                 shape: BoxShape.circle,
//                                 boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
//                               ),
//                               child: _isTakingSnap
//                                   ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
//                                   : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _uiTimer?.cancel();
//     _chunkScannerTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final hasUrl = widget.url.isNotEmpty;
//     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

//     return GestureDetector(
//       onTap: (hasUrl && !isError) ? _showFloatingScreen : null,
//       child: Container(
//         height: h,
//         decoration: BoxDecoration(
//           color: AppTheme.bgRaised,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppTheme.borderDim),
//         ),
//         child: Stack(
//           children: [
//             if (hasUrl && !isError)
//               Screenshot(
//                 controller: _smallController,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: _isStreamReady
//                       ? Video(controller: controller, fit: BoxFit.cover, controls: NoVideoControls)
//                       : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                 ),
//               )
//             else
//               Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   StatusBadge(
//                     label: hasUrl ? (isError ? 'ERROR' : 'LIVE') : 'OFFLINE',
//                     color: hasUrl ? (isError ? AppTheme.red : AppTheme.green) : AppTheme.red,
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: _isRecording,
//                     builder: (context, isRec, _) {
//                       return ValueListenableBuilder<bool>(
//                         valueListenable: _isPaused,
//                         builder: (context, isPau, _) {
//                           if (!isRec && !isPau) return const SizedBox.shrink();
//                           return Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               ValueListenableBuilder<String>(
//                                 valueListenable: _timerText,
//                                 builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
//                               ),
//                               if (isPau) ...[
//                                 const SizedBox(width: 8),
//                                 StatusBadge(label: 'PAUSED', color: AppTheme.amber),
//                               ],
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (hasUrl && !isError)
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     _buildRecordingControls(() {}),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () => _takeSnapshot(_smallController),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: _isTakingSnap ? Colors.grey : AppTheme.cyan, shape: BoxShape.circle),
//                         child: _isTakingSnap
//                             ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                             : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'dart:async';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter_new/return_code.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:screenshot/screenshot.dart';

// import '../../../core/services/recording_service.dart';
// import '../../../ui/app_theme.dart';
// import '../../../ui/gcs_widgets.dart';

// class RecordSessionState {
//   FFmpegSession? session;
//   String url = '';
//   DateTime? chunkStartTime;
//   Duration accumulatedTime = Duration.zero;
//   bool isRecording = false;
//   bool isPaused = false;
//   String currentFilePath = '';
// }

// class GlobalRecordingManager {
//   static final Map<String, RecordSessionState> sessions = {};
//   static final Set<String> registeredFiles = {};

//   static bool isCameraRecording(String url) {
//     return sessions.values.any((s) => s.url == url && s.isRecording);
//   }

//   static Future<void> stopAll() async {
//     for (var s in sessions.values) {
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//       }
//     }
//     sessions.clear();
//   }
// }

// // class GlobalStreamCache {
// //   static final Map<String, Player> players = {};
// //   static final Map<String, VideoController> controllers = {};

// //   static String? get activeStreamUrl => players.keys.firstOrNull;

// //   static VideoController getController(String url) {
// //     if (players.containsKey(url)) {
// //       players[url]!.play();
// //       return controllers[url]!;
// //     }
// // class GlobalStreamCache {
// //   static final Map<String, Player> players = {};
// //   static final Map<String, VideoController> controllers = {};
// //   static final Map<String, String> currentSource = {};
// //   static final Map<String, String> relayUrls = {};   // camera url -> local udp url

// //   static String? get activeStreamUrl => players.keys.firstOrNull;

// //   static VideoController getController(String url) {
// //     if (players.containsKey(url)) {
// //       final recording = GlobalRecordingManager.sessions.values
// //           .any((s) => s.url == url && s.isRecording && !s.isPaused);
// //       final want = (recording && relayUrls.containsKey(url)) ? relayUrls[url]! : url;
// //       switchSource(url, want);
// //       return controllers[url]!;
// //     }

// //     final player = Player(
// //       configuration: const PlayerConfiguration(
// //         bufferSize: 1024 * 1024 * 4,
// //         logLevel: MPVLogLevel.error,
// //       ),
// //     );

// //     final controller = VideoController(player);

// // //     void retryRelay(dynamic _) {
// // //   final recording = GlobalRecordingManager.sessions.values
// // //       .any((s) => s.url == url && s.isRecording && !s.isPaused);
// // //   if (recording && currentSource[url] == relayUrls[url]) {
// // //     Future.delayed(const Duration(seconds: 1), () {
// // //       if (relayUrls[url] != null && currentSource[url] == relayUrls[url]) {
// // //         switchSource(url, relayUrls[url]!, force: true);
// // //       }
// // //     });
// // //   }
// // // // }
// // // player.stream.completed.listen((done) { if (done) retryRelay(null); });
// // // player.stream.error.listen(retryRelay);

// //     // try {
// //     //   final mpv = player.platform as dynamic;
// //     //   mpv.setProperty('profile', 'low-latency');
// //     //   mpv.setProperty('audio', 'no');
// //     //   mpv.setProperty('hwdec', 'auto');
// //     //   mpv.setProperty('network-timeout', '3');
// //     //   mpv.setProperty('cache-pause', 'no');
// //     // } catch (e) {
// //     //   debugPrint("MPV Config Error: $e");
// //     // }
// //     final mpv = player.platform as dynamic;
// //     mpv.setProperty('profile', 'low-latency');
// //     mpv.setProperty('audio', 'no');
// //     mpv.setProperty('hwdec', 'mediacodec-copy');
// //     mpv.setProperty('network-timeout', '3');
// //     mpv.setProperty('cache-pause', 'no');
// //     mpv.setProperty('demuxer-lavf-o', 'rtsp_transport=tcp');
// //     mpv.setProperty('demuxer-lavf-analyzeduration', '0.5');

// //     player.open(Media(url), play: true);
// //     players[url] = player;
// //     controllers[url] = controller;

// //     return controller;
// //   }
// //   static void switchSource(String url, String newSource) {
// //     final p = players[url];
// //     if (p == null) return;
// //     if (currentSource[url] == newSource) {
// //       p.play();
// //       return;
// //     }
// //     p.open(Media(newSource), play: true);
// //     currentSource[url] = newSource;
// //   }

// //   static Future<void> releaseAll() async {
// //     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) {
// //       return;
// //     }

// //     for (var p in players.values) {
// //       p.dispose();
// //     }
// //     players.clear();
// //     controllers.clear();
// //     FlutterForegroundTask.stopService();
// //   }
// // }

// class GlobalStreamCache {
//   static final Map<String, Player> players = {};
//   static final Map<String, VideoController> controllers = {};
//   static final Map<String, String> currentSource = {};
//   static final Map<String, String> relayUrls = {};
//   static final Map<String, Timer> _watchdogs = {};

//   static String? get activeStreamUrl => players.keys.firstOrNull;

//   static bool _isRelayActive(String url) =>
//       relayUrls.containsKey(url) &&
//       GlobalRecordingManager.sessions.values
//           .any((s) => s.url == url && s.isRecording && !s.isPaused);

//   static Future<void> _configureFor(Player p, String source) async {
//     final mpv = p.platform as dynamic;
//     try {
//       if (source.startsWith('udp')) {
//         await mpv.setProperty('demuxer-lavf-format', 'mpegts');
//         await mpv.setProperty('demuxer-lavf-probe-info', 'yes');
//         await mpv.setProperty('demuxer-lavf-analyzeduration', '3');
//         await mpv.setProperty('demuxer-lavf-probesize', '5000000');
//         await mpv.setProperty('demuxer-lavf-o', '');
//         await mpv.setProperty('network-timeout', '10');
//       } else {
//         await mpv.setProperty('demuxer-lavf-format', '');
//         await mpv.setProperty('demuxer-lavf-probe-info', 'nostreams');
//         await mpv.setProperty('demuxer-lavf-analyzeduration', '0.5');
//         await mpv.setProperty('demuxer-lavf-o', 'rtsp_transport=tcp');
//         await mpv.setProperty('network-timeout', '3');
//       }
//     } catch (e) {
//       debugPrint('MPV config error: $e');
//     }
//   }

//   /// Reopen the relay ONLY if no video appeared within 8 s.
//   /// Decoder warnings are ignored; they are normal until the first keyframe.
//   static void _armWatchdog(String url) {
//     _watchdogs[url]?.cancel();
//     _watchdogs[url] = Timer(const Duration(seconds: 8), () {
//       final p = players[url];
//       if (p == null) return;
//       final onRelay = _isRelayActive(url) && currentSource[url] == relayUrls[url];
//       if (onRelay && (p.state.width ?? 0) == 0) {
//         debugPrint('WATCHDOG: no video on relay, reopening $url');
//         switchSource(url, relayUrls[url]!, force: true);
//       }
//     });
//   }

//   static VideoController getController(String url) {
//     if (players.containsKey(url)) {
//       final want = _isRelayActive(url) ? relayUrls[url]! : url;
//       switchSource(url, want);
//       return controllers[url]!;
//     }

//     final player = Player(
//       configuration: const PlayerConfiguration(
//         bufferSize: 1024 * 1024 * 4,
//         logLevel: MPVLogLevel.warn,          // temporary, for diagnosis
//       ),
//     );
//     final controller = VideoController(player);

//     final mpv = player.platform as dynamic;
//     Future(() async {
//       try {
//         await mpv.setProperty('profile', 'low-latency');
//         await mpv.setProperty('audio', 'no');
//         await mpv.setProperty('hwdec', 'mediacodec-copy');
//         await mpv.setProperty('cache-pause', 'no');
//       } catch (e) {
//         debugPrint("MPV Config Error: $e");
//       }
//       await _configureFor(player, url);
//       await player.open(Media(url), play: true);
//     });

//     // NO listener on player.stream.error any more.
//     player.stream.completed.listen((done) {
//       if (done && _isRelayActive(url) && currentSource[url] == relayUrls[url]) {
//         _armWatchdog(url);
//       }
//     });

//     // Temporary diagnostics – remove once it works
//     player.stream.log.listen((l) => debugPrint('MPV[${l.level}] ${l.prefix}: ${l.text}'));
//     player.stream.width.listen((w) => debugPrint('MPV width for $url = $w'));

//     currentSource[url] = url;
//     players[url] = player;
//     controllers[url] = controller;
//     return controller;
//   }

//   static Future<void> switchSource(String url, String newSource, {bool force = false}) async {
//     final p = players[url];
//     if (p == null) return;
//     if (!force && currentSource[url] == newSource) {
//       p.play();
//       return;
//     }
//     currentSource[url] = newSource;
//     debugPrint('SWITCH $url -> $newSource');
//     await p.stop();
//     await _configureFor(p, newSource);
//     await p.open(Media(newSource), play: true);
//     if (newSource.startsWith('udp')) {
//       _armWatchdog(url);
//     } else {
//       _watchdogs[url]?.cancel();
//     }
//   }

//   static Future<void> releaseCameraConnection(String url) async {
//     await players[url]?.stop();
//     currentSource[url] = '';
//   }

//   static Future<void> releaseAll() async {
//     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) return;
//     for (var t in _watchdogs.values) { t.cancel(); }
//     _watchdogs.clear();
//     for (var p in players.values) { p.dispose(); }
//     players.clear();
//     controllers.clear();
//     currentSource.clear();
//     relayUrls.clear();
//     FlutterForegroundTask.stopService();
//   }
// }


// class CameraView extends StatefulWidget {
//   final String url;
//   final String label;
//   final String taskName;
//   final int faceNumber;
//   // Reverted back to standard Function so WiperMainScreen doesn't crash the build!
//   final Function(String, DateTime, String, bool, String)? onSnapshot;
//   final Function(String, DateTime, String)? onVideoRecorded;

//   const CameraView({
//     super.key,
//     required this.url,
//     required this.label,
//     required this.taskName,
//     this.faceNumber = 1,
//     this.onSnapshot,
//     this.onVideoRecorded,
//   });

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView>
//     with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
//   final ScreenshotController _smallController = ScreenshotController();
//   final ScreenshotController _fsController = ScreenshotController();

//   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
//   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
//   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

//   bool _isTakingSnap = false;
//   late final VideoController controller;
//   bool isError = false;
//   bool _isStreamReady = false;

//   Timer? _uiTimer;
//   Timer? _chunkScannerTimer;

//   // 05-10-2026 - for live camera recording
// int get _relayPort => widget.label.endsWith('A') ? 6001 : 6002;
// // FFmpeg side (sender)
// String get _relayOutUrl => 'udp://127.0.0.1:$_relayPort?pkt_size=1316';
// // mpv side (receiver) – fifo_size is in 188-byte packets (~9 MB here)
// String get _relayInUrl =>
//     'udp://127.0.0.1:$_relayPort?fifo_size=50000&overrun_nonfatal=1';

//   String get _basePrefix {
//     final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
//   }

//   RecordSessionState get session {
//     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
//       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
//     }
//     return GlobalRecordingManager.sessions[widget.label]!;
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _recoverRecordingState();
//     _startTimers();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Future.delayed(const Duration(milliseconds: 300), () {
//         if (mounted) _initStream();
//       });
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && _isStreamReady && mounted) {
//       controller.player.play();
//     }
//   }

//   void _startTimers() {
//     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final s = session;
//       if (s.isRecording) {
//         Duration d = s.accumulatedTime;
//         if (!s.isPaused && s.chunkStartTime != null) {
//           d += DateTime.now().difference(s.chunkStartTime!);
//         }
//         String h = d.inHours.toString().padLeft(2, '0');
//         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
//         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
//         _timerText.value = "$h:$m:$sec";
//       }
//     });

//     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       if (session.isRecording) {
//         await _registerCompletedChunks();
//       }
//     });
//   }

//   void _initStream() {
//     if (widget.url.isNotEmpty && mounted) {
//       try {
//         controller = GlobalStreamCache.getController(widget.url);
//         setState(() {
//           isError = false;
//           _isStreamReady = true;
//         });
//       } catch (e) {
//         setState(() {
//           isError = true;
//           _isStreamReady = true;
//         });
//       }
//     } else {
//       if (mounted) setState(() => _isStreamReady = true);
//     }
//   }

//   void _recoverRecordingState() {
//     final s = session;
//     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
//       _isRecording.value = s.isRecording;
//       _isPaused.value = s.isPaused;
//     }
//   }

//   Future<Directory> get _targetDir async {
//     Directory? baseDir;
//     if (Platform.isAndroid) {
//       baseDir = await getExternalStorageDirectory();
//     }
//     baseDir ??= await getApplicationDocumentsDirectory();

//     final dir = Directory('${baseDir.path}/VividGCS_Videos');
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//     return dir;
//   }

//   Future<int> _getNextSequenceNumber(String dirPath) async {
//     final dir = Directory(dirPath);
//     int maxNum = -1;
//     if (await dir.exists()) {
//       final files = dir.listSync();
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
//           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
//           if (match != null) {
//             final num = int.tryParse(match.group(1)!) ?? -1;
//             if (num > maxNum) maxNum = num;
//           }
//         }
//       }
//     }
//     return maxNum + 1;
//   }

//   Future<void> _registerCompletedChunks() async {
//     try {
//       final dir = await _targetDir;
//       if (!await dir.exists()) return;
//       final files = dir.listSync();

//       final currentActiveFile = session.currentFilePath;

//       List<File> matchedFiles = [];
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.contains(_basePrefix) && name.endsWith('.ts')) {
//           // Ignore the active file completely!
//           if (file.path != currentActiveFile) {
//             matchedFiles.add(File(file.path));
//           }
//         }
//       }

//       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

//       for (var file in matchedFiles) {
//         if (!GlobalRecordingManager.registeredFiles.contains(file.path)) {
//           final length = await file.length();
          
//           if (length > 0) { 
//             try {
//               widget.onVideoRecorded?.call(
//                 file.path,
//                 file.lastModifiedSync(),
//                 widget.label,
//               );
//               GlobalRecordingManager.registeredFiles.add(file.path);
              
//               if (mounted) {
//                 final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('✅ SCANNER SAVED: $mb MB'), backgroundColor: Colors.green),
//                 );
//               }
//             } catch (e) {
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('❌ DB ERROR (Scanner): $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//                 );
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Scanner Error: $e");
//     }
//   }

//   // Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//   //   final s = session;
//   //   if (s.isRecording && !s.isPaused) return;

//   //   try {
//   //     if (Platform.isAndroid) {
//   //       if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//   //         await FlutterForegroundTask.requestNotificationPermission();
//   //       }
//   //       if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//   //         await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//   //       }
//   //     }

//   //     final dir = await _targetDir;
//   //     final startNum = await _getNextSequenceNumber(dir.path);

//   //     if (!await FlutterForegroundTask.isRunningService) {
//   //       await FlutterForegroundTask.startService(
//   //         notificationTitle: 'Vivid GCS Recording',
//   //         notificationText: 'Background stream active...',
//   //         callback: startCallback,
//   //       );
//   //     }

//   //     s.url = widget.url;
//   //     s.chunkStartTime = DateTime.now();
//   //     s.isRecording = true;
//   //     s.isPaused = false;
//   //     _isRecording.value = true;
//   //     _isPaused.value = false;

//   //     _spawnFFmpegProcess(s, startNum);

//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text(
//   //             '${widget.label} Recording Started',
//   //             style: GoogleFonts.jetBrainsMono(fontSize: 12),
//   //           ),
//   //           backgroundColor: AppTheme.green,
//   //         ),
//   //       );
//   //     }
//   //     updateDialog?.call();
//   //   } catch (e) {
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//   //       );
//   //     }
//   //   }
//   // }

//   // 05-10-26 foe video recording

//   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     if (s.isRecording && !s.isPaused) return;

//     try {
//       if (Platform.isAndroid) {
//         if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//           await FlutterForegroundTask.requestNotificationPermission();
//         }
//         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//         }
//       }

//       final dir = await _targetDir;
//       final startNum = await _getNextSequenceNumber(dir.path);

//       if (!await FlutterForegroundTask.isRunningService) {
//         await FlutterForegroundTask.startService(
//           notificationTitle: 'Vivid GCS Recording',
//           notificationText: 'Background stream active...',
//           callback: startCallback,
//         );
//       }

//       s.url = widget.url;
//       s.chunkStartTime = DateTime.now();
//       s.isRecording = true;
//       s.isPaused = false;
//       _isRecording.value = true;
//       _isPaused.value = false;

//       // 1. Spawn FFmpeg first so it negotiates the airunit - mk32 connection
//       // _spawnFFmpegProcess(s, startNum);

//       // 2. Wait 1.5 seconds for FFmpeg to start pushing data, THEN connect MediaKit
//       // if (_isStreamReady) {
//       //   // Future.delayed(const Duration(milliseconds: 1500), () {
//       //   Future.delayed(const Duration(seconds: 2), () {
//       //     if (mounted && session.isRecording) {
//       //       controller.player.open(Media(_localUdpUrl), play: true);
//       //     }
//       //   });
//       // }
// //       GlobalStreamCache.relayUrls[widget.url] = _localUdpUrl;
// // _spawnFFmpegProcess(s, startNum);
// // Future.delayed(const Duration(seconds: 2), () {
// //   if (session.isRecording && !session.isPaused) {
// //     GlobalStreamCache.switchSource(widget.url, _localUdpUrl);
// //   }
// // });
// GlobalStreamCache.relayUrls[widget.url] = _relayInUrl;
// await GlobalStreamCache.releaseCameraConnection(widget.url);
// _spawnFFmpegProcess(s, startNum);
// Future.delayed(const Duration(milliseconds: 2500), () {
//   if (session.isRecording && !session.isPaused) {
//     GlobalStreamCache.switchSource(widget.url, _relayInUrl, force: true);
//   }
// });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
//             backgroundColor: AppTheme.green,
//           ),
//         );
//       }
//       updateDialog?.call();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//         );
//       }
//     }
//   }

//   //     s.url = widget.url;
//   //     s.chunkStartTime = DateTime.now();
//   //     s.isRecording = true;
//   //     s.isPaused = false;
//   //     _isRecording.value = true;
//   //     _isPaused.value = false;

//   //     // Switch MediaKit to monitor the internal FFmpeg stream
//   //     if (_isStreamReady) {
//   //       controller.player.open(Media(_localUdpUrl), play: true);
//   //     }

//   //     _spawnFFmpegProcess(s, startNum);

//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(
//   //           content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
//   //           backgroundColor: AppTheme.green,
//   //         ),
//   //       );
//   //     }
//   //     updateDialog?.call();
//   //   } catch (e) {
//   //     if (mounted) {
//   //       ScaffoldMessenger.of(context).showSnackBar(
//   //         SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//   //       );
//   //     }
//   //   }
//   // }

//   // void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//   //   if (!s.isRecording || s.isPaused) return;

//   //   final dir = await _targetDir;
//   //   final String currentFilePath = '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//   //   s.currentFilePath = currentFilePath;

//   //   // // THE PERFECT STABLE COMMAND (No TCP, No Hangs)
//   //   // List<String> arguments = ['-y'];

//   //   // if (widget.url.toLowerCase().startsWith('rtsp')) {
//   //   //   arguments.addAll(['-stimeout', '5000000']); 
//   //   // } else if (widget.url.toLowerCase().startsWith('udp')) {
//   //   //   arguments.addAll(['-timeout', '5000000']);
//   //   // }

//   //   // arguments.addAll([
//   //   //   '-fflags', '+genpts+discardcorrupt',
//   //   //   '-use_wallclock_as_timestamps', '1',
//   //   //   '-i', widget.url,
//   //   //   '-c:v', 'copy',
//   //   //   '-an',
//   //   //   '-f', 'mpegts', 
//   //   //   '-t', '900', 
//   //   //   currentFilePath
//   //   // ]);

//   //   // List<String> arguments = [
//   //   //   '-y',
//   //   //   '-i', widget.url,
//   //   //   '-c', 'copy',
//   //   //   '-f', 'mpegts', 
//   //   //   currentFilePath
//   //   // ];

//   //   List<String> arguments = [
//   //     '-y',
//   //     '-timeout', '10000000',      // 10 second timeout to prevent instant crashes
//   //     '-rtsp_transport', 'tcp',    // FORCE TCP TO FIX PIXEL BREAKAGE
//   //     '-i', widget.url,
//   //     '-c:v', 'copy',              // Copy video stream without re-encoding
//   //     '-an',                       // Drop audio to save bandwidth
//   //     '-f', 'mpegts', 
//   //     currentFilePath
//   //   ];

//   //   try {
//   //     s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
        
//   //       final returnCode = await finishedSession.getReturnCode();
//   //       if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//   //         final logs = await finishedSession.getLogsAsString();
//   //         debugPrint("FFMPEG LOG: $logs");
//   //         if (mounted) {
//   //           ScaffoldMessenger.of(context).showSnackBar(
//   //             SnackBar(content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//   //           );
//   //         }
//   //       }

//   //       await Future.delayed(const Duration(seconds: 1));

//   //       final file = File(currentFilePath);
//   //       if (await file.exists()) {
//   //         final length = await file.length();
          
//   //         if (length > 0) { 
//   //           if (!GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
//   //             try {
//   //               widget.onVideoRecorded?.call(
//   //                 currentFilePath,
//   //                 DateTime.now(),
//   //                 widget.label,
//   //               );
//   //               GlobalRecordingManager.registeredFiles.add(currentFilePath);
                
//   //               if (mounted) {
//   //                  final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//   //                  ScaffoldMessenger.of(context).showSnackBar(
//   //                    SnackBar(content: Text('✅ DB SAVED: $mb MB'), backgroundColor: Colors.green, duration: const Duration(seconds: 5)),
//   //                  );
//   //               }
//   //             } catch (e) {
//   //               if (mounted) {
//   //                  ScaffoldMessenger.of(context).showSnackBar(
//   //                    SnackBar(content: Text('❌ DB ERROR: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//   //                  );
//   //               }
//   //             }
//   //           }
//   //         }
//   //       }

//   //       if (s.isRecording && !s.isPaused) {
//   //         await Future.delayed(const Duration(seconds: 1));
//   //         final nextNum = await _getNextSequenceNumber(dir.path);
//   //         _spawnFFmpegProcess(s, nextNum);
//   //       }
//   //     });
//   //   } catch (e) {
//   //     debugPrint("FATAL DART ERROR: $e");
//   //   }
//   // }

//   // 05-10-2026 for live video recording stability

//   void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//     if (!s.isRecording || s.isPaused) return;

//     final dir = await _targetDir;
//     final String currentFilePath = '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//     s.currentFilePath = currentFilePath;

//     // Master FFmpeg Command (TCP Transport + Dual Output)
//     // List<String> arguments = [
//     //   '-y',
//     //   '-timeout', '10000000',
//     //   '-rtsp_transport', 'tcp', // Forces reliable packets, eliminating gray pixel tearing
//     //   '-i', widget.url,
      
//     //   // Output 1: Rebroadcast internally for MediaKit to display lively
//     //   // '-c:v', 'copy',
//     //   // '-an',
//     //   // '-f', 'mpegts',
//     //   // '-flush_packets', '1', // Pushes frames instantly to prevent player timeout 
//     //   // '-drop_pkts_on_overflow', '1',  // Prevents internal memory crashes
//     //   // '-fifo_size', '100000',
//     //   // _localUdpUrl,

//     //   // Output 1: live preview
//     //   '-c:v', 'copy',
//     //   '-an',
//     //   '-bsf:v', 'dump_extra',          // repeat SPS/PPS before each keyframe
//     //   '-f', 'mpegts',
//     //   '-mpegts_flags', '+resend_headers',
//     //   '-pat_period', '0.5',
//     //   '-flush_packets', '1',
//     //   '$_localUdpUrl&fifo_size=5000000&overrun_nonfatal=1',
      
//     //   // Output 2: Record to the storage drive
//     //   '-c:v', 'copy',
//     //   '-an',
//     //   '-f', 'mpegts', 
//     //   currentFilePath
//     // ];
// List<String> arguments = [
//   '-y',
//   '-timeout', '10000000',
//   '-rtsp_transport', 'tcp',
//   '-fflags', '+genpts+discardcorrupt',
//   '-i', widget.url,

//   // Output 1: local preview relay
//   '-map', '0:v', '-c:v', 'copy', '-an',
//   '-bsf:v', 'dump_extra',
//   '-f', 'mpegts',
//   '-mpegts_flags', '+resend_headers',
//   '-pat_period', '0.5',
//   '-flush_packets', '1',
//   _relayOutUrl,

//   // Output 2: file
//   '-map', '0:v', '-c:v', 'copy', '-an',
//   '-f', 'mpegts',
//   currentFilePath,
// ];

//     try {
//       s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
        
//         final returnCode = await finishedSession.getReturnCode();
//         if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//           final logs = await finishedSession.getLogsAsString();
//           debugPrint("FFMPEG LOG: $logs");
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//             );
//           }
//         }

//         await Future.delayed(const Duration(seconds: 1));

//         final file = File(currentFilePath);
//         if (await file.exists()) {
//           final length = await file.length();
          
//           if (length > 0) { 
//             if (!GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
//               try {
//                 widget.onVideoRecorded?.call(
//                   currentFilePath,
//                   DateTime.now(),
//                   widget.label,
//                 );
//                 GlobalRecordingManager.registeredFiles.add(currentFilePath);
                
//                 if (mounted) {
//                    final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                    ScaffoldMessenger.of(context).showSnackBar(
//                      SnackBar(content: Text('✅ DB SAVED: $mb MB'), backgroundColor: Colors.green, duration: const Duration(seconds: 5)),
//                    );
//                 }
//               } catch (e) {
//                 if (mounted) {
//                    ScaffoldMessenger.of(context).showSnackBar(
//                      SnackBar(content: Text('❌ DB ERROR: $e'), backgroundColor: Colors.red, duration: const Duration(seconds: 10)),
//                    );
//                 }
//               }
//             }
//           }
//         }

//         // if (s.isRecording && !s.isPaused) {
//         //   await Future.delayed(const Duration(seconds: 1));
//         //   final nextNum = await _getNextSequenceNumber(dir.path);
//         //   _spawnFFmpegProcess(s, nextNum);
//         // }
//         if (s.isRecording && !s.isPaused) {
//   await Future.delayed(const Duration(seconds: 1));
//   final nextNum = await _getNextSequenceNumber(dir.path);
//   _spawnFFmpegProcess(s, nextNum);
//   Future.delayed(const Duration(seconds: 2), () {
//     if (s.isRecording && !s.isPaused) {
//       GlobalStreamCache.switchSource(widget.url, _relayInUrl, force: true);
//     }
//   });
// }
//       });
//     } catch (e) {
//       debugPrint("FATAL DART ERROR: $e");
//     }
//   }

//  Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
//   final s = session;
//   s.isPaused = true;
//   _isPaused.value = true;

//   if (s.session != null) {
//     await FFmpegKit.cancel(s.session!.getSessionId());
//     s.session = null;
//   }
//   if (s.chunkStartTime != null) {
//     s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
//   }

//   await Future.delayed(const Duration(seconds: 1));
//   await GlobalStreamCache.switchSource(widget.url, widget.url, force: true);
//   updateDialog?.call();
// }


// Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
//   try {
//     final s = session;
//     s.isRecording = false;
//     s.isPaused = false;
//     _isRecording.value = false;
//     _isPaused.value = false;
//     _timerText.value = "00:00:00";

//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Stopping ${widget.label}...'),
//           backgroundColor: AppTheme.amber,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }

//     if (s.session != null) {
//       await FFmpegKit.cancel(s.session!.getSessionId());
//       s.session = null;
//     }

//     await Future.delayed(const Duration(seconds: 1));
//     await GlobalStreamCache.switchSource(widget.url, widget.url, force: true);

//     await Future.delayed(const Duration(seconds: 1));
//     s.currentFilePath = '';
//     await _registerCompletedChunks();

//     GlobalRecordingManager.sessions.remove(widget.label);

//     if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
//       await FlutterForegroundTask.stopService();
//     }
//   } catch (e) {
//     debugPrint("Stop error: $e");
//   }
//   updateDialog?.call();
// }



//   Future<void> _takeSnapshot(ScreenshotController targetController, {VoidCallback? updateDialog}) async {
//     if (_isTakingSnap || !_isStreamReady) return;
//     _isTakingSnap = true;
//     if (mounted) setState(() {});
//     updateDialog?.call();

//     try {
//       final bytes = await targetController.capture(pixelRatio: 4.0);
//       if (bytes != null) {
//         final dir = await _targetDir;
//         if (!await dir.exists()) await dir.create(recursive: true);

//         final timestamp = DateTime.now();
//         final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
//         await File(filePath).writeAsBytes(bytes);

//         _isTakingSnap = false;
//         if (mounted) setState(() {});
//         updateDialog?.call();

//         if (mounted) {
//           bool isIssue = false;
//           TextEditingController descCtrl = TextEditingController();
//           await showDialog(
//             context: context,
//             barrierDismissible: false,
//             builder: (ctx) => StatefulBuilder(
//               builder: (context, setModalState) => AlertDialog(
//                 backgroundColor: AppTheme.bgPanel,
//                 title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
//                 content: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     SwitchListTile(
//                       title: Text('Flag as Maintenance Issue?', style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
//                       activeColor: AppTheme.red,
//                       value: isIssue,
//                       onChanged: (v) => setModalState(() => isIssue = v),
//                     ),
//                     if (isIssue)
//                       TextField(
//                         controller: descCtrl,
//                         style: TextStyle(color: AppTheme.textHi, fontSize: 12),
//                         decoration: InputDecoration(
//                           hintText: "Describe the damage/issue...",
//                           hintStyle: TextStyle(color: AppTheme.textLo),
//                         ),
//                       ),
//                   ],
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(ctx);
//                       widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
//                     },
//                     child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();
//     }
//   }

//   Widget _buildRecordingControls(VoidCallback updateState) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isRecording,
//       builder: (context, isRec, _) {
//         return ValueListenableBuilder<bool>(
//           valueListenable: _isPaused,
//           builder: (context, isPau, _) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isRec && !isPau)
//                   GestureDetector(
//                     onTap: () => _startOrResumeRecording(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
//                     ),
//                   )
//                 else ...[
//                   GestureDetector(
//                     onTap: () => _stopEntirely(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       if (isRec && !isPau) {
//                         _pauseRecording(updateDialog: updateState);
//                       } else {
//                         _startOrResumeRecording(updateDialog: updateState);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(color: isPau ? AppTheme.amber : Colors.white, shape: BoxShape.circle),
//                       child: Icon(isPau ? Icons.play_arrow_rounded : Icons.pause_rounded, color: Colors.black, size: 16),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   void _showFloatingScreen() {
//     showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.95),
//       barrierDismissible: true,
//       barrierLabel: 'LiveFeed',
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (ctx, anim1, anim2) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: StatefulBuilder(
//               builder: (context, setDialogState) {
//                 return Stack(
//                   children: [
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: Screenshot(
//                           controller: _fsController,
//                           child: _isStreamReady
//                               ? Video(controller: controller, fit: BoxFit.contain, controls: NoVideoControls)
//                               : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
//                         onPressed: () => Navigator.pop(ctx),
//                       ),
//                     ),
//                     Positioned(
//                       top: 24,
//                       left: 24,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: AppTheme.bgCard.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: AppTheme.cyan),
//                             ),
//                             child: Text('${widget.label} (LIVE)', style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold)),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: _isRecording,
//                             builder: (context, isRec, _) {
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: _isPaused,
//                                 builder: (context, isPau, _) {
//                                   if (!isRec && !isPau) return const SizedBox.shrink();
//                                   return Row(
//                                     children: [
//                                       const SizedBox(width: 12),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.red.withOpacity(0.8),
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(color: AppTheme.red),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.circle, color: Colors.white, size: 10),
//                                             const SizedBox(width: 6),
//                                             ValueListenableBuilder<String>(
//                                               valueListenable: _timerText,
//                                               builder: (ctx, time, _) => Text('REC $time', style: GoogleFonts.jetBrainsMono(color: Colors.white, fontWeight: FontWeight.bold)),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (isPau) ...[
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.amber.withOpacity(0.8),
//                                             borderRadius: BorderRadius.circular(6),
//                                             border: Border.all(color: AppTheme.amber),
//                                           ),
//                                           child: Text('PAUSED', style: GoogleFonts.jetBrainsMono(color: Colors.black, fontWeight: FontWeight.bold)),
//                                         ),
//                                       ],
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 30,
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.5,
//                             child: _buildRecordingControls(() => setDialogState(() {})),
//                           ),
//                           const SizedBox(width: 40),
//                           GestureDetector(
//                             onTap: () => _takeSnapshot(_fsController, updateDialog: () => setDialogState(() {})),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                                 shape: BoxShape.circle,
//                                 boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
//                               ),
//                               child: _isTakingSnap
//                                   ? const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white))
//                                   : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _uiTimer?.cancel();
//     _chunkScannerTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final hasUrl = widget.url.isNotEmpty;
//     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

//     return GestureDetector(
//       onTap: (hasUrl && !isError) ? _showFloatingScreen : null,
//       child: Container(
//         height: h,
//         decoration: BoxDecoration(
//           color: AppTheme.bgRaised,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppTheme.borderDim),
//         ),
//         child: Stack(
//           children: [
//             if (hasUrl && !isError)
//               Screenshot(
//                 controller: _smallController,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: _isStreamReady
//                       ? Video(controller: controller, fit: BoxFit.cover, controls: NoVideoControls)
//                       : Center(child: CircularProgressIndicator(color: AppTheme.cyan)),
//                 ),
//               )
//             else
//               Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   StatusBadge(
//                     label: hasUrl ? (isError ? 'ERROR' : 'LIVE') : 'OFFLINE',
//                     color: hasUrl ? (isError ? AppTheme.red : AppTheme.green) : AppTheme.red,
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: _isRecording,
//                     builder: (context, isRec, _) {
//                       return ValueListenableBuilder<bool>(
//                         valueListenable: _isPaused,
//                         builder: (context, isPau, _) {
//                           if (!isRec && !isPau) return const SizedBox.shrink();
//                           return Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               ValueListenableBuilder<String>(
//                                 valueListenable: _timerText,
//                                 builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
//                               ),
//                               if (isPau) ...[
//                                 const SizedBox(width: 8),
//                                 StatusBadge(label: 'PAUSED', color: AppTheme.amber),
//                               ],
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (hasUrl && !isError)
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     _buildRecordingControls(() {}),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () => _takeSnapshot(_smallController),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(color: _isTakingSnap ? Colors.grey : AppTheme.cyan, shape: BoxShape.circle),
//                         child: _isTakingSnap
//                             ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
//                             : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// import 'dart:async';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../../core/services/recording_service.dart';
// import '../../../ui/app_theme.dart';
// import '../../../ui/gcs_widgets.dart';
// import 'exo_stream_view.dart';

// class RecordSessionState {
//   FFmpegSession? session;
//   String url = '';
//   DateTime? chunkStartTime;
//   Duration accumulatedTime = Duration.zero;
//   bool isRecording = false;
//   bool isPaused = false;
//   String currentFilePath = '';
// }

// class GlobalRecordingManager {
//   static final Map<String, RecordSessionState> sessions = {};
//   static final Set<String> registeredFiles = {};

//   static bool isCameraRecording(String url) {
//     return sessions.values.any((s) => s.url == url && s.isRecording);
//   }

//   static Future<void> stopAll() async {
//     for (var s in sessions.values) {
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//       }
//     }
//     sessions.clear();
//   }
// }

// /// Kept so other screens that used the old media_kit cache still compile.
// /// Playback itself is now handled by the native ExoPlayer view.
// class GlobalStreamCache {
//   static final Set<String> _activeUrls = {};

//   static String? get activeStreamUrl => _activeUrls.isEmpty ? null : _activeUrls.first;

//   static void register(String url) {
//     if (url.isNotEmpty) _activeUrls.add(url);
//   }

//   static void unregister(String url) => _activeUrls.remove(url);

//   static Future<void> releaseAll() async {
//     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) return;
//     _activeUrls.clear();
//     await FlutterForegroundTask.stopService();
//   }
// }

// class CameraView extends StatefulWidget {
//   final String url;
//   final String label;
//   final String taskName;
//   final int faceNumber;
//   final Function(String, DateTime, String, bool, String)? onSnapshot;
//   final Function(String, DateTime, String)? onVideoRecorded;

//   const CameraView({
//     super.key,
//     required this.url,
//     required this.label,
//     required this.taskName,
//     this.faceNumber = 1,
//     this.onSnapshot,
//     this.onVideoRecorded,
//   });

//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> with AutomaticKeepAliveClientMixin {
//   // One native player for the small tile, one for fullscreen.
//   // Only one is ever active, because the camera (RTSP) and the relay port (UDP)
//   // each accept a single reader.
//   final ExoStreamController _exoSmall = ExoStreamController();
//   final ExoStreamController _exoFs = ExoStreamController();
//   late ExoStreamController _active = _exoSmall;

//   /// What the visible player should show: camera RTSP, local UDP relay, or '' (nothing).
//   String _source = '';
//   Timer? _retryTimer;

//   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
//   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
//   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

//   bool _isTakingSnap = false;

//   Timer? _uiTimer;
//   Timer? _chunkScannerTimer;

//   int get _relayPort => widget.label.endsWith('A') ? 6001 : 6002;
//   // FFmpeg side (sender)
//   String get _relayOutUrl => 'udp://127.0.0.1:$_relayPort?pkt_size=1316';
//   // ExoPlayer side (receiver) – plain URL, exactly like the Kotlin app
//   String get _relayUrl => 'udp://127.0.0.1:$_relayPort';

//   String get _basePrefix {
//     final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
//   }

//   RecordSessionState get session {
//     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
//       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
//     }
//     return GlobalRecordingManager.sessions[widget.label]!;
//   }

//   @override
//   bool get wantKeepAlive => true;

//   @override
//   void initState() {
//     super.initState();
//     GlobalStreamCache.register(widget.url);
//     _exoSmall.onError = _onPlayerError;
//     _exoFs.onError = _onPlayerError;

//     _recoverRecordingState();
//     _startTimers();

//     if (widget.url.isNotEmpty) {
//       final s = session;
//       final relayLive = s.isRecording && !s.isPaused && s.url == widget.url;
//       _setSource(relayLive ? _relayUrl : widget.url);
//     }
//   }

//   // ───────────────────────── Player source control ─────────────────────────

//   void _setSource(String src) {
//     _retryTimer?.cancel();
//     _source = src;
//     if (src.isEmpty) {
//       _active.stop();
//     } else {
//       _active.play(src);
//     }
//   }

//   /// ExoPlayer only reports real failures (not decoder warnings), so a simple retry is safe.
//   void _onPlayerError(String msg) {
//     debugPrint('${widget.label} player error: $msg');
//     if (!mounted || _source.isEmpty) return;
//     final failed = _source;
//     _retryTimer?.cancel();
//     _retryTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted && _source == failed) _active.play(failed);
//     });
//   }

//   // ───────────────────────────── Timers / files ─────────────────────────────

//   void _startTimers() {
//     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final s = session;
//       if (s.isRecording) {
//         Duration d = s.accumulatedTime;
//         if (!s.isPaused && s.chunkStartTime != null) {
//           d += DateTime.now().difference(s.chunkStartTime!);
//         }
//         String h = d.inHours.toString().padLeft(2, '0');
//         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
//         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
//         _timerText.value = "$h:$m:$sec";
//       }
//     });

//     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       if (session.isRecording) {
//         await _registerCompletedChunks();
//       }
//     });
//   }

//   void _recoverRecordingState() {
//     final s = session;
//     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
//       _isRecording.value = s.isRecording;
//       _isPaused.value = s.isPaused;
//     }
//   }

//   Future<Directory> get _targetDir async {
//     Directory? baseDir;
//     if (Platform.isAndroid) {
//       baseDir = await getExternalStorageDirectory();
//     }
//     baseDir ??= await getApplicationDocumentsDirectory();

//     final dir = Directory('${baseDir.path}/VividGCS_Videos');
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//     return dir;
//   }

//   Future<int> _getNextSequenceNumber(String dirPath) async {
//     final dir = Directory(dirPath);
//     int maxNum = -1;
//     if (await dir.exists()) {
//       final files = dir.listSync();
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
//           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
//           if (match != null) {
//             final num = int.tryParse(match.group(1)!) ?? -1;
//             if (num > maxNum) maxNum = num;
//           }
//         }
//       }
//     }
//     return maxNum + 1;
//   }

//   Future<void> _registerCompletedChunks() async {
//     try {
//       final dir = await _targetDir;
//       if (!await dir.exists()) return;
//       final files = dir.listSync();

//       final currentActiveFile = session.currentFilePath;

//       List<File> matchedFiles = [];
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.contains(_basePrefix) && name.endsWith('.ts')) {
//           if (file.path != currentActiveFile) {
//             matchedFiles.add(File(file.path));
//           }
//         }
//       }

//       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

//       for (var file in matchedFiles) {
//         if (!GlobalRecordingManager.registeredFiles.contains(file.path)) {
//           final length = await file.length();
//           if (length > 0) {
//             try {
//               widget.onVideoRecorded?.call(
//                 file.path,
//                 file.lastModifiedSync(),
//                 widget.label,
//               );
//               GlobalRecordingManager.registeredFiles.add(file.path);

//               if (mounted) {
//                 final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('✅ SCANNER SAVED: $mb MB'), backgroundColor: Colors.green),
//                 );
//               }
//             } catch (e) {
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('❌ DB ERROR (Scanner): $e'),
//                     backgroundColor: Colors.red,
//                     duration: const Duration(seconds: 10),
//                   ),
//                 );
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Scanner Error: $e");
//     }
//   }

//   // ─────────────────────────────── Recording ───────────────────────────────

//   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     if (s.isRecording && !s.isPaused) return;

//     try {
//       if (Platform.isAndroid) {
//         if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//           await FlutterForegroundTask.requestNotificationPermission();
//         }
//         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//         }
//       }

//       final dir = await _targetDir;
//       final startNum = await _getNextSequenceNumber(dir.path);

//       if (!await FlutterForegroundTask.isRunningService) {
//         await FlutterForegroundTask.startService(
//           notificationTitle: 'Vivid GCS Recording',
//           notificationText: 'Background stream active...',
//           callback: startCallback,
//         );
//       }

//       s.url = widget.url;
//       s.chunkStartTime = DateTime.now();
//       s.isRecording = true;
//       s.isPaused = false;
//       _isRecording.value = true;
//       _isPaused.value = false;

//       // Same sequence as the Kotlin app:
//       // 1. drop the direct RTSP view so FFmpeg is the only camera client
//       _setSource('');
//       await Future.delayed(const Duration(milliseconds: 300));

//       // 2. start FFmpeg (file + local UDP relay)
//       _spawnFFmpegProcess(s, startNum);

//       // 3. after 2.5 s, show the relay
//       Future.delayed(const Duration(milliseconds: 2500), () {
//         if (mounted && s.isRecording && !s.isPaused) _setSource(_relayUrl);
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
//             backgroundColor: AppTheme.green,
//           ),
//         );
//       }
//       updateDialog?.call();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//         );
//       }
//     }
//   }

//   void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//     if (!s.isRecording || s.isPaused) return;

//     final dir = await _targetDir;
//     final String currentFilePath =
//         '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//     s.currentFilePath = currentFilePath;

//     final List<String> arguments = [
//       '-y',
//       '-timeout', '10000000',
//       '-rtsp_transport', 'tcp',
//       '-fflags', '+genpts+discardcorrupt',
//       '-i', widget.url,

//       // Output 1: local preview relay
//       '-map', '0:v', '-c:v', 'copy', '-an',
//       '-bsf:v', 'dump_extra',
//       '-f', 'mpegts',
//       '-mpegts_flags', '+resend_headers',
//       '-pat_period', '0.5',
//       '-flush_packets', '1',
//       _relayOutUrl,

//       // Output 2: file
//       '-map', '0:v', '-c:v', 'copy', '-an',
//       '-f', 'mpegts',
//       currentFilePath,
//     ];

//     try {
//       s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
//         final returnCode = await finishedSession.getReturnCode();
//         if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//           final logs = await finishedSession.getLogsAsString();
//           debugPrint("FFMPEG LOG: $logs");
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 10),
//               ),
//             );
//           }
//         }

//         await Future.delayed(const Duration(seconds: 1));

//         final file = File(currentFilePath);
//         if (await file.exists()) {
//           final length = await file.length();
//           if (length > 0 && !GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
//             try {
//               widget.onVideoRecorded?.call(currentFilePath, DateTime.now(), widget.label);
//               GlobalRecordingManager.registeredFiles.add(currentFilePath);

//               if (mounted) {
//                 final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('✅ DB SAVED: $mb MB'),
//                     backgroundColor: Colors.green,
//                     duration: const Duration(seconds: 5),
//                   ),
//                 );
//               }
//             } catch (e) {
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('❌ DB ERROR: $e'),
//                     backgroundColor: Colors.red,
//                     duration: const Duration(seconds: 10),
//                   ),
//                 );
//               }
//             }
//           }
//         }

//         // Auto-restart if the camera link dropped while still recording
//         if (s.isRecording && !s.isPaused) {
//           await Future.delayed(const Duration(seconds: 1));
//           final nextNum = await _getNextSequenceNumber(dir.path);
//           _spawnFFmpegProcess(s, nextNum);
//           Future.delayed(const Duration(milliseconds: 2500), () {
//             if (mounted && s.isRecording && !s.isPaused) _setSource(_relayUrl);
//           });
//         }
//       });
//     } catch (e) {
//       debugPrint("FATAL DART ERROR: $e");
//     }
//   }

//   Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     s.isPaused = true;
//     _isPaused.value = true;

//     if (s.session != null) {
//       await FFmpegKit.cancel(s.session!.getSessionId());
//       s.session = null;
//     }
//     if (s.chunkStartTime != null) {
//       s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
//     }

//     // FFmpeg has released the camera; go back to direct RTSP
//     await Future.delayed(const Duration(seconds: 1));
//     if (mounted) _setSource(widget.url);
//     updateDialog?.call();
//   }

//   Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
//     try {
//       final s = session;
//       s.isRecording = false;
//       s.isPaused = false;
//       _isRecording.value = false;
//       _isPaused.value = false;
//       _timerText.value = "00:00:00";

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Stopping ${widget.label}...'),
//             backgroundColor: AppTheme.amber,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }

//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//         s.session = null;
//       }

//       await Future.delayed(const Duration(seconds: 1));
//       if (mounted) _setSource(widget.url);

//       await Future.delayed(const Duration(seconds: 1));
//       s.currentFilePath = '';
//       await _registerCompletedChunks();

//       GlobalRecordingManager.sessions.remove(widget.label);

//       if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
//         await FlutterForegroundTask.stopService();
//       }
//     } catch (e) {
//       debugPrint("Stop error: $e");
//     }
//     updateDialog?.call();
//   }

//   // ─────────────────────────────── Snapshot ───────────────────────────────

//   Future<void> _takeSnapshot({VoidCallback? updateDialog}) async {
//     if (_isTakingSnap || _source.isEmpty) return;
//     _isTakingSnap = true;
//     if (mounted) setState(() {});
//     updateDialog?.call();

//     try {
//       final bytes = await _active.snapshot();

//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();

//       if (bytes == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: const Text('No video frame yet'), backgroundColor: AppTheme.amber),
//           );
//         }
//         return;
//       }

//       final dir = await _targetDir;
//       final timestamp = DateTime.now();
//       final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
//       await File(filePath).writeAsBytes(bytes);

//       if (mounted) {
//         bool isIssue = false;
//         final descCtrl = TextEditingController();
//         await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (ctx) => StatefulBuilder(
//             builder: (context, setModalState) => AlertDialog(
//               backgroundColor: AppTheme.bgPanel,
//               title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SwitchListTile(
//                     title: Text('Flag as Maintenance Issue?',
//                         style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
//                     activeColor: AppTheme.red,
//                     value: isIssue,
//                     onChanged: (v) => setModalState(() => isIssue = v),
//                   ),
//                   if (isIssue)
//                     TextField(
//                       controller: descCtrl,
//                       style: TextStyle(color: AppTheme.textHi, fontSize: 12),
//                       decoration: InputDecoration(
//                         hintText: "Describe the damage/issue...",
//                         hintStyle: TextStyle(color: AppTheme.textLo),
//                       ),
//                     ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(ctx);
//                     widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
//                   },
//                   child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();
//     }
//   }

//   // ─────────────────────────────── UI ───────────────────────────────

//   Widget _buildRecordingControls(VoidCallback updateState) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isRecording,
//       builder: (context, isRec, _) {
//         return ValueListenableBuilder<bool>(
//           valueListenable: _isPaused,
//           builder: (context, isPau, _) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isRec && !isPau)
//                   GestureDetector(
//                     onTap: () => _startOrResumeRecording(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
//                     ),
//                   )
//                 else ...[
//                   GestureDetector(
//                     onTap: () => _stopEntirely(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       if (isRec && !isPau) {
//                         _pauseRecording(updateDialog: updateState);
//                       } else {
//                         _startOrResumeRecording(updateDialog: updateState);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: isPau ? AppTheme.amber : Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         isPau ? Icons.play_arrow_rounded : Icons.pause_rounded,
//                         color: Colors.black,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _showFloatingScreen() async {
//     // Hand the stream over to the fullscreen player (camera/relay allow only one reader)
//     await _exoSmall.stop();
//     _active = _exoFs;
//     if (_source.isNotEmpty) _exoFs.play(_source); // plays as soon as the fullscreen view exists

//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.95),
//       barrierDismissible: true,
//       barrierLabel: 'LiveFeed',
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (ctx, anim1, anim2) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: StatefulBuilder(
//               builder: (context, setDialogState) {
//                 return Stack(
//                   children: [
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: ExoStreamView(controller: _exoFs, cover: false),
//                       ),
//                     ),
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
//                         onPressed: () => Navigator.pop(ctx),
//                       ),
//                     ),
//                     Positioned(
//                       top: 24,
//                       left: 24,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: AppTheme.bgCard.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: AppTheme.cyan),
//                             ),
//                             child: Text(
//                               '${widget.label} (LIVE)',
//                               style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: _isRecording,
//                             builder: (context, isRec, _) {
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: _isPaused,
//                                 builder: (context, isPau, _) {
//                                   if (!isRec && !isPau) return const SizedBox.shrink();
//                                   return Row(
//                                     children: [
//                                       const SizedBox(width: 12),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.red.withOpacity(0.8),
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(color: AppTheme.red),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.circle, color: Colors.white, size: 10),
//                                             const SizedBox(width: 6),
//                                             ValueListenableBuilder<String>(
//                                               valueListenable: _timerText,
//                                               builder: (ctx, time, _) => Text(
//                                                 'REC $time',
//                                                 style: GoogleFonts.jetBrainsMono(
//                                                     color: Colors.white, fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (isPau) ...[
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.amber.withOpacity(0.8),
//                                             borderRadius: BorderRadius.circular(6),
//                                             border: Border.all(color: AppTheme.amber),
//                                           ),
//                                           child: Text(
//                                             'PAUSED',
//                                             style: GoogleFonts.jetBrainsMono(
//                                                 color: Colors.black, fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ],
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 30,
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.5,
//                             child: _buildRecordingControls(() => setDialogState(() {})),
//                           ),
//                           const SizedBox(width: 40),
//                           GestureDetector(
//                             onTap: () => _takeSnapshot(updateDialog: () => setDialogState(() {})),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                                 shape: BoxShape.circle,
//                                 boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
//                               ),
//                               child: _isTakingSnap
//                                   ? const SizedBox(
//                                       width: 28,
//                                       height: 28,
//                                       child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
//                                     )
//                                   : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );

//     // Fullscreen closed: release its player, then give the stream back to the small tile
//     await _exoFs.stop();
//     _exoFs.detach();
//     _active = _exoSmall;
//     await Future.delayed(const Duration(milliseconds: 500));
//     if (mounted && _source.isNotEmpty) _exoSmall.play(_source);
//   }

//   @override
//   void dispose() {
//     _retryTimer?.cancel();
//     _uiTimer?.cancel();
//     _chunkScannerTimer?.cancel();
//     _exoSmall.detach();
//     _exoFs.detach();
//     GlobalStreamCache.unregister(widget.url);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final hasUrl = widget.url.isNotEmpty;
//     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

//     return GestureDetector(
//       onTap: hasUrl ? _showFloatingScreen : null,
//       child: Container(
//         height: h,
//         decoration: BoxDecoration(
//           color: AppTheme.bgRaised,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppTheme.borderDim),
//         ),
//         child: Stack(
//           children: [
//             if (hasUrl)
//               Positioned.fill(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: ExoStreamView(controller: _exoSmall, cover: true),
//                 ),
//               )
//             else
//               Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   StatusBadge(
//                     label: hasUrl ? 'LIVE' : 'OFFLINE',
//                     color: hasUrl ? AppTheme.green : AppTheme.red,
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: _isRecording,
//                     builder: (context, isRec, _) {
//                       return ValueListenableBuilder<bool>(
//                         valueListenable: _isPaused,
//                         builder: (context, isPau, _) {
//                           if (!isRec && !isPau) return const SizedBox.shrink();
//                           return Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               ValueListenableBuilder<String>(
//                                 valueListenable: _timerText,
//                                 builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
//                               ),
//                               if (isPau) ...[
//                                 const SizedBox(width: 8),
//                                 StatusBadge(label: 'PAUSED', color: AppTheme.amber),
//                               ],
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (hasUrl)
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     _buildRecordingControls(() {}),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () => _takeSnapshot(),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                           shape: BoxShape.circle,
//                         ),
//                         child: _isTakingSnap
//                             ? const SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                               )
//                             : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/services/recording_service.dart';
import '../../../ui/app_theme.dart';
import '../../../ui/gcs_widgets.dart';
import 'exo_stream_view.dart';

class RecordSessionState {
  FFmpegSession? session;
  String url = '';
  DateTime? chunkStartTime;
  Duration accumulatedTime = Duration.zero;
  bool isRecording = false;
  bool isPaused = false;
  String currentFilePath = '';
  bool holdSave = false;
}

class GlobalRecordingManager {
  static final Map<String, RecordSessionState> sessions = {};
  static final Set<String> registeredFiles = {};

  static bool isCameraRecording(String url) {
    return sessions.values.any((s) => s.url == url && s.isRecording);
  }

  static Future<void> stopAll() async {
    for (var s in sessions.values) {
      if (s.session != null) {
        await FFmpegKit.cancel(s.session!.getSessionId());
      }
    }
    sessions.clear();
  }
}

/// Per-camera stream state shared by the tile, fullscreen and PiP players.
class _CameraStream {
  /// What should be shown: camera RTSP url, local UDP relay, or '' (nothing,
  /// e.g. while FFmpeg is taking over the camera connection).
  String source = '';

  /// Players that want to show this camera. Only the LAST one plays, because the
  /// camera allows one RTSP client and the relay port allows one UDP reader.
  final List<ExoStreamController> owners = [];
  Timer? retry;

  ExoStreamController? get active => owners.isEmpty ? null : owners.last;
}

/// Decides which native player shows each camera (tile, fullscreen or PiP)
/// and what it shows (RTSP or the recording relay).
class GlobalStreamCache {
  static final Map<String, _CameraStream> _streams = {};

  static _CameraStream _stream(String url) => _streams.putIfAbsent(url, () => _CameraStream());

  /// Camera URLs that currently have at least one player on screen.
  static List<String> get urls =>
      _streams.entries.where((e) => e.value.owners.isNotEmpty).map((e) => e.key).toList();

  static String? get activeStreamUrl {
    final list = urls;
    return list.isEmpty ? null : list.first;
  }

  static String sourceOf(String url) => _streams[url]?.source ?? '';

  /// Register a player for a camera. onTop = take over the stream now
  /// (fullscreen, PiP); onTop: false = wait until the others are closed (tile).
  static void attach(String url, ExoStreamController c, {bool onTop = true}) {
    if (url.isEmpty) return;
    final s = _stream(url);
    if (s.owners.contains(c)) return;
    c.onError = (msg) => _onError(url, c, msg);

    if (!onTop && s.owners.isNotEmpty) {
      s.owners.insert(0, c);
      return;
    }
    final prev = s.active;
    s.owners.add(c);
    if (prev != null) prev.stop();
    _playActive(url, delayed: prev != null);
  }

  /// Unregister a player; if it was showing the stream, the next one takes over.
  static void detach(String url, ExoStreamController c) {
    final s = _streams[url];
    if (s == null || !s.owners.contains(c)) return;
    final wasActive = s.active == c;
    s.owners.remove(c);
    if (wasActive) {
      s.retry?.cancel();
      c.stop();
      _playActive(url, delayed: true);
    }
  }

  /// Change what a camera shows (RTSP, relay, or '' to release the camera).
  static void setSource(String url, String src) {
    if (url.isEmpty) return;
    final s = _stream(url);
    s.retry?.cancel();
    s.source = src;
    final a = s.active;
    if (a == null) return;
    if (src.isEmpty) {
      a.stop();
    } else {
      a.play(src);
    }
  }
  // home screen video
  static void promote(String url, ExoStreamController c) {
  final s = _streams[url];
  if (s == null || !s.owners.contains(c) || s.active == c) return;
  final prev = s.active;
  s.owners.remove(c);
  s.owners.add(c);
  prev?.stop();
  _playActive(url, delayed: true);
}

  static Future<Uint8List?> snapshot(String url) async => _streams[url]?.active?.snapshot();

  static void _playActive(String url, {required bool delayed}) {
    final s = _streams[url];
    if (s == null) return;
    // Short delay lets the previous player release the RTSP session / UDP port
    Future.delayed(Duration(milliseconds: delayed ? 500 : 0), () {
      final a = s.active;
      if (a != null && s.source.isNotEmpty) a.play(s.source);
    });
  }

  /// ExoPlayer only reports real failures (not decoder warnings), so a simple retry is safe.
  static void _onError(String url, ExoStreamController c, String msg) {
    debugPrint('Stream error [$url]: $msg');
    final s = _streams[url];
    if (s == null || s.active != c || s.source.isEmpty) return;
    final failed = s.source;
    s.retry?.cancel();
    s.retry = Timer(const Duration(seconds: 2), () {
      if (s.active == c && s.source == failed) c.play(failed);
    });
  }

  static Future<void> releaseAll() async {
    if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) return;
    _streams.removeWhere((_, s) => s.owners.isEmpty);
    await FlutterForegroundTask.stopService();
  }
}

class CameraView extends StatefulWidget {
  final String url;
  final String label;
  final String taskName;
  final int faceNumber;
  final Function(String, DateTime, String, bool, String)? onSnapshot;
  final Function(String, DateTime, String)? onVideoRecorded;
  final bool visible;

  const CameraView({
    super.key,
    required this.url,
    required this.label,
    required this.taskName,
    this.faceNumber = 1,
    this.onSnapshot,
    this.onVideoRecorded,
    // home screen video
    this.visible = true,

  });


  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> with AutomaticKeepAliveClientMixin {
  // Native players for the small tile and fullscreen. GlobalStreamCache decides
  // which one (or the PiP window) is allowed to show the stream at any moment.
  final ExoStreamController _exoSmall = ExoStreamController();
  final ExoStreamController _exoFs = ExoStreamController();

  final ValueNotifier<bool> _isRecording = ValueNotifier(false);
  final ValueNotifier<bool> _isPaused = ValueNotifier(false);
  final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

  bool _isTakingSnap = false;

  Timer? _uiTimer;
  Timer? _chunkScannerTimer;

  int get _relayPort => widget.label.endsWith('A') ? 6001 : 6002;
  // FFmpeg side (sender)
  String get _relayOutUrl => 'udp://127.0.0.1:$_relayPort?pkt_size=1316';
  // ExoPlayer side (receiver) – plain URL, exactly like the Kotlin app
  String get _relayUrl => 'udp://127.0.0.1:$_relayPort';

  String get _basePrefix {
    final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
    return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
  }

  RecordSessionState get session {
    if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
      GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
    }
    return GlobalRecordingManager.sessions[widget.label]!;
  }

  @override
  bool get wantKeepAlive => true;

      // home screen video
    @override
void didUpdateWidget(covariant CameraView old) {
  super.didUpdateWidget(old);
  if (widget.visible && !old.visible && widget.url.isNotEmpty) {
    GlobalStreamCache.promote(widget.url, _exoSmall);
  }
}


  @override
  void initState() {
    super.initState();
    _recoverRecordingState();
    _startTimers();


    if (widget.url.isNotEmpty) {
      final s = session;
      final recordingThisCam = s.isRecording && s.url == widget.url;
      if (!recordingThisCam && GlobalStreamCache.sourceOf(widget.url).isEmpty) {
        GlobalStreamCache.setSource(widget.url, widget.url);
      }
      // Bottom of the stack: if PiP/fullscreen already shows this camera, it keeps it.
      GlobalStreamCache.attach(widget.url, _exoSmall, onTop: widget.visible);
      
    }
  }

  /// Changes what this camera shows in whichever player is active (tile, fullscreen or PiP).
  void _setSource(String src) => GlobalStreamCache.setSource(widget.url, src);

  // ───────────────────────────── Timers / files ─────────────────────────────

  void _startTimers() {
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final s = session;
      if (s.isRecording) {
        Duration d = s.accumulatedTime;
        if (!s.isPaused && s.chunkStartTime != null) {
          d += DateTime.now().difference(s.chunkStartTime!);
        }
        String h = d.inHours.toString().padLeft(2, '0');
        String m = (d.inMinutes % 60).toString().padLeft(2, '0');
        String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
        _timerText.value = "$h:$m:$sec";
      }
    });

    _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
      if (session.isRecording) {
        await _registerCompletedChunks();
      }
    });
  }

  void _recoverRecordingState() {
    final s = session;
    if ((s.isRecording || s.isPaused) && s.url == widget.url) {
      _isRecording.value = s.isRecording;
      _isPaused.value = s.isPaused;
    }
  }

  Future<Directory> get _targetDir async {
    Directory? baseDir;
    if (Platform.isAndroid) {
      baseDir = await getExternalStorageDirectory();
    }
    baseDir ??= await getApplicationDocumentsDirectory();

    final dir = Directory('${baseDir.path}/VividGCS_Videos');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<int> _getNextSequenceNumber(String dirPath) async {
    final dir = Directory(dirPath);
    int maxNum = -1;
    if (await dir.exists()) {
      final files = dir.listSync();
      for (var file in files) {
        final name = file.path.split(Platform.pathSeparator).last;
        if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
          final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
          if (match != null) {
            final num = int.tryParse(match.group(1)!) ?? -1;
            if (num > maxNum) maxNum = num;
          }
        }
      }
    }
    return maxNum + 1;
  }

  Future<void> _registerCompletedChunks({bool force = false}) async {
    if(!force && session.holdSave) return;
    try {
      final dir = await _targetDir;
      if (!await dir.exists()) return;
      final files = dir.listSync();

      final currentActiveFile = session.currentFilePath;

      List<File> matchedFiles = [];
      for (var file in files) {
        final name = file.path.split(Platform.pathSeparator).last;
        if (name.contains(_basePrefix) && name.endsWith('.ts')) {
          if (file.path != currentActiveFile) {
            matchedFiles.add(File(file.path));
          }
        }
      }

      matchedFiles.sort((a, b) => a.path.compareTo(b.path));

      for (var file in matchedFiles) {
        if (!GlobalRecordingManager.registeredFiles.contains(file.path)) {
          final length = await file.length();
          if (length > 0) {
            try {
              widget.onVideoRecorded?.call(
                file.path,
                file.lastModifiedSync(),
                widget.label,
              );
              GlobalRecordingManager.registeredFiles.add(file.path);

              if (mounted) {
                final mb = (length / (1024 * 1024)).toStringAsFixed(2);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('✅ SCANNER SAVED: $mb MB'), backgroundColor: Colors.green),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ DB ERROR (Scanner): $e'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 10),
                  ),
                );
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Scanner Error: $e");
    }
  }

  // ─────────────────────────────── Recording ───────────────────────────────

  Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
    final s = session;
    if (s.isRecording && !s.isPaused) return;

    try {
      if (Platform.isAndroid) {
        if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
          await FlutterForegroundTask.requestNotificationPermission();
        }
        if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
          await FlutterForegroundTask.requestIgnoreBatteryOptimization();
        }
      }

      final dir = await _targetDir;
      final startNum = await _getNextSequenceNumber(dir.path);

      if (!await FlutterForegroundTask.isRunningService) {
        await FlutterForegroundTask.startService(
          notificationTitle: 'Vivid GCS Recording',
          notificationText: 'Background stream active...',
          callback: startCallback,
        );
      }

      s.url = widget.url;
      s.chunkStartTime = DateTime.now();
      s.isRecording = true;
      s.isPaused = false;
      s.holdSave = true;
      _isRecording.value = true;
      _isPaused.value = false;

      // Same sequence as the Kotlin app:
      // 1. drop the direct RTSP view so FFmpeg is the only camera client
      _setSource('');
      await Future.delayed(const Duration(milliseconds: 100));

      // 2. start FFmpeg (file + local UDP relay)
      _spawnFFmpegProcess(s, startNum);

      // 3. after 2.5 s, show the relay (also works if PiP is showing this camera)
      // final relay = _relayUrl;
      // Future.delayed(const Duration(milliseconds: 2500), () {
      //   if (s.isRecording && !s.isPaused) _setSource(relay);
      // });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
            backgroundColor: AppTheme.green,
          ),
        );
      }
      updateDialog?.call();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
        );
      }
    }
  }

  void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
    if (!s.isRecording || s.isPaused) return;

    final dir = await _targetDir;
    final String currentFilePath =
        '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
    s.currentFilePath = currentFilePath;

    final List<String> arguments = [
      '-y',
      '-timeout', '10000000',
      '-rtsp_transport', 'tcp',
      '-fflags', '+genpts+discardcorrupt',
      '-flags', 'low_delay',
      '-probesize', '32768',
      '-analyzeduration', '0',
      '-i', widget.url,

      // Output 1: local preview relay
      '-map', '0:v', '-c:v', 'copy', '-an',
      '-bsf:v', 'dump_extra',
      '-f', 'mpegts',
      '-mpegts_flags', '+resend_headers',
      '-pat_period', '0.1',
      '-flush_packets', '1',
      _relayOutUrl,

      // Output 2: file
      '-map', '0:v', '-c:v', 'copy', '-an',
      '-f', 'mpegts',
      currentFilePath,
    ];

    final relayReady = Completer<void>();
    try {
      s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
        final returnCode = await finishedSession.getReturnCode();
        if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
          final logs = await finishedSession.getLogsAsString();
          debugPrint("FFMPEG LOG: $logs");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 10),
              ),
            );
          }
        }

        await Future.delayed(const Duration(seconds: 1));

        final file = File(currentFilePath);
        if (await file.exists()) {
          final length = await file.length();
          if (length > 0 && !s.holdSave && !GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
            try {
              widget.onVideoRecorded?.call(currentFilePath, DateTime.now(), widget.label);
              GlobalRecordingManager.registeredFiles.add(currentFilePath);

              if (mounted) {
                final mb = (length / (1024 * 1024)).toStringAsFixed(2);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('✅ DB SAVED: $mb MB'),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 5),
                  ),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('❌ DB ERROR: $e'),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 10),
                  ),
                );
              }
            }
          }
        }

        // Auto-restart if the camera link dropped while still recording
        if (s.isRecording && !s.isPaused) {
          await Future.delayed(const Duration(seconds: 1));
          final nextNum = await _getNextSequenceNumber(dir.path);
          _spawnFFmpegProcess(s, nextNum);
          // final relay = _relayUrl;
          // Future.delayed(const Duration(milliseconds: 2500), () {
          //   if (s.isRecording && !s.isPaused) _setSource(relay);
          // });
        }
      },
      null, // log callback
    (stats) {
      if ((stats.getSize() > 0 || stats.getVideoFrameNumber() > 0) &&
          !relayReady.isCompleted) {
        relayReady.complete();
      }
    },
  );

  relayReady.future
      .timeout(const Duration(seconds: 6), onTimeout: () {})
      .then((_) {
    if (s.isRecording && !s.isPaused) _setSource(_relayUrl);
  }
      
      );
    } catch (e) {
      debugPrint("FATAL DART ERROR: $e");
    }
  }

  Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
    final s = session;
    s.isPaused = true;
    _isPaused.value = true;

    if (s.session != null) {
      await FFmpegKit.cancel(s.session!.getSessionId());
      s.session = null;
    }
    if (s.chunkStartTime != null) {
      s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
    }

    // FFmpeg has released the camera; go back to direct RTSP
    await Future.delayed(const Duration(seconds: 1));
    _setSource(widget.url);
    updateDialog?.call();
  }

  Future<void> _discardUnsavedChunks() async {
  try {
    final dir = await _targetDir;
    for (final f in dir.listSync()) {
      final name = f.path.split(Platform.pathSeparator).last;
      if (name.contains(_basePrefix) &&
          name.endsWith('.ts') &&
          !GlobalRecordingManager.registeredFiles.contains(f.path)) {
        await File(f.path).delete();
      }
    }
  } catch (e) {
    debugPrint('Discard error: $e');
  }
}

  Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
    try {
      final s = session;
      s.isRecording = false;
      s.isPaused = false;
      _isRecording.value = false;
      _isPaused.value = false;
      _timerText.value = "00:00:00";

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Stopping ${widget.label}...'),
            backgroundColor: AppTheme.amber,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      if (s.session != null) {
        await FFmpegKit.cancel(s.session!.getSessionId());
        s.session = null;
      }

      await Future.delayed(const Duration(seconds: 1));
      _setSource(widget.url);

      await Future.delayed(const Duration(seconds: 1));
      s.currentFilePath = '';
      await _registerCompletedChunks();

      GlobalRecordingManager.sessions.remove(widget.label);

      if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
        await FlutterForegroundTask.stopService();
      }

            if (mounted) {
        final save = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppTheme.bgPanel,
            title: Text('Recording Stopped', style: TextStyle(color: AppTheme.textHi)),
            content: const Text(
              'Save the recorded video to the database?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('CANCEL', style: TextStyle(color: AppTheme.textMid)),
              ),
            ],
          ),
        );

        if (save == true) {
          s.holdSave = false;
          await _registerCompletedChunks(force: true);
        } else {
          await _discardUnsavedChunks();
        }
      }

    } catch (e) {
      debugPrint("Stop error: $e");
    }
    updateDialog?.call();
  }

  // ─────────────────────────────── Snapshot ───────────────────────────────

  Future<void> _takeSnapshot({VoidCallback? updateDialog}) async {
    if (_isTakingSnap || GlobalStreamCache.sourceOf(widget.url).isEmpty) return;
    _isTakingSnap = true;
    if (mounted) setState(() {});
    updateDialog?.call();

    try {
      final bytes = await GlobalStreamCache.snapshot(widget.url);

      _isTakingSnap = false;
      if (mounted) setState(() {});
      updateDialog?.call();

      if (bytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('No video frame yet'), backgroundColor: AppTheme.amber),
          );
        }
        return;
      }

      final dir = await _targetDir;
      final timestamp = DateTime.now();
      final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
      await File(filePath).writeAsBytes(bytes);

      if (mounted) {
        bool isIssue = false;
        final descCtrl = TextEditingController();
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => StatefulBuilder(
            builder: (context, setModalState) => AlertDialog(
              backgroundColor: AppTheme.bgPanel,
              title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: Text('Flag as Maintenance Issue?',
                        style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
                    activeColor: AppTheme.red,
                    value: isIssue,
                    onChanged: (v) => setModalState(() => isIssue = v),
                  ),
                  if (isIssue)
                    TextField(
                      controller: descCtrl,
                      style: TextStyle(color: AppTheme.textHi, fontSize: 12),
                      decoration: InputDecoration(
                        hintText: "Describe the damage/issue...",
                        hintStyle: TextStyle(color: AppTheme.textLo),
                      ),
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
                  },
                  child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
                ),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      _isTakingSnap = false;
      if (mounted) setState(() {});
      updateDialog?.call();
    }
  }

  // ─────────────────────────────── UI ───────────────────────────────

  Widget _buildRecordingControls(VoidCallback updateState) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isRecording,
      builder: (context, isRec, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _isPaused,
          builder: (context, isPau, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isRec && !isPau)
                  GestureDetector(
                    onTap: () => _startOrResumeRecording(updateDialog: updateState),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
                    ),
                  )
                else ...[
                  GestureDetector(
                    onTap: () => _stopEntirely(updateDialog: updateState),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (isRec && !isPau) {
                        _pauseRecording(updateDialog: updateState);
                      } else {
                        _startOrResumeRecording(updateDialog: updateState);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isPau ? AppTheme.amber : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isPau ? Icons.play_arrow_rounded : Icons.pause_rounded,
                        color: Colors.black,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _showFloatingScreen() async {
    // Hand the stream over to the fullscreen player (camera/relay allow only one reader)
    GlobalStreamCache.attach(widget.url, _exoFs);

    await showGeneralDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.95),
      barrierDismissible: true,
      barrierLabel: 'LiveFeed',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: StatefulBuilder(
              builder: (context, setDialogState) {
                return Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ExoStreamView(controller: _exoFs, cover: false),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ),
                    Positioned(
                      top: 24,
                      left: 24,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.bgCard.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.cyan),
                            ),
                            child: Text(
                              '${widget.label} (LIVE)',
                              style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ValueListenableBuilder<bool>(
                            valueListenable: _isRecording,
                            builder: (context, isRec, _) {
                              return ValueListenableBuilder<bool>(
                                valueListenable: _isPaused,
                                builder: (context, isPau, _) {
                                  if (!isRec && !isPau) return const SizedBox.shrink();
                                  return Row(
                                    children: [
                                      const SizedBox(width: 12),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: AppTheme.red.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppTheme.red),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.circle, color: Colors.white, size: 10),
                                            const SizedBox(width: 6),
                                            ValueListenableBuilder<String>(
                                              valueListenable: _timerText,
                                              builder: (ctx, time, _) => Text(
                                                'REC $time',
                                                style: GoogleFonts.jetBrainsMono(
                                                    color: Colors.white, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isPau) ...[
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: AppTheme.amber.withOpacity(0.8),
                                            borderRadius: BorderRadius.circular(6),
                                            border: Border.all(color: AppTheme.amber),
                                          ),
                                          child: Text(
                                            'PAUSED',
                                            style: GoogleFonts.jetBrainsMono(
                                                color: Colors.black, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      right: 30,
                      child: Row(
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: _buildRecordingControls(() => setDialogState(() {})),
                          ),
                          const SizedBox(width: 40),
                          GestureDetector(
                            onTap: () => _takeSnapshot(updateDialog: () => setDialogState(() {})),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
                                shape: BoxShape.circle,
                                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
                              ),
                              child: _isTakingSnap
                                  ? const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                                    )
                                  : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    // Fullscreen closed: give the stream back to the small tile
    GlobalStreamCache.detach(widget.url, _exoFs);
    _exoFs.detach();
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    _chunkScannerTimer?.cancel();
    GlobalStreamCache.detach(widget.url, _exoSmall);
    GlobalStreamCache.detach(widget.url, _exoFs);
    _exoSmall.detach();
    _exoFs.detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final hasUrl = widget.url.isNotEmpty;
    final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

    return GestureDetector(
      onTap: hasUrl ? _showFloatingScreen : null,
      child: Container(
        height: h,
        decoration: BoxDecoration(
          color: AppTheme.bgRaised,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.borderDim),
        ),
        child: Stack(
          children: [
            if (hasUrl)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ExoStreamView(controller: _exoSmall, cover: true),
                ),
              )
            else
              Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  StatusBadge(
                    label: hasUrl ? 'LIVE' : 'OFFLINE',
                    color: hasUrl ? AppTheme.green : AppTheme.red,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isRecording,
                    builder: (context, isRec, _) {
                      return ValueListenableBuilder<bool>(
                        valueListenable: _isPaused,
                        builder: (context, isPau, _) {
                          if (!isRec && !isPau) return const SizedBox.shrink();
                          return Row(
                            children: [
                              const SizedBox(width: 8),
                              ValueListenableBuilder<String>(
                                valueListenable: _timerText,
                                builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
                              ),
                              if (isPau) ...[
                                const SizedBox(width: 8),
                                StatusBadge(label: 'PAUSED', color: AppTheme.amber),
                              ],
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            if (hasUrl)
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    _buildRecordingControls(() {}),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => _takeSnapshot(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
                          shape: BoxShape.circle,
                        ),
                        child: _isTakingSnap
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:async';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../../core/services/recording_service.dart';
// import '../../../ui/app_theme.dart';
// import '../../../ui/gcs_widgets.dart';
// import 'exo_stream_view.dart';

// class RecordSessionState {
//   FFmpegSession? session;
//   String url = '';
//   DateTime? chunkStartTime;
//   Duration accumulatedTime = Duration.zero;
//   bool isRecording = false;
//   bool isPaused = false;
//   String currentFilePath = '';
// }

// class GlobalRecordingManager {
//   static final Map<String, RecordSessionState> sessions = {};
//   static final Set<String> registeredFiles = {};

//   static bool isCameraRecording(String url) {
//     return sessions.values.any((s) => s.url == url && s.isRecording);
//   }

//   static Future<void> stopAll() async {
//     for (var s in sessions.values) {
//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//       }
//     }
//     sessions.clear();
//   }
// }

// /// Per-camera stream state shared by the tile, fullscreen and PiP players.
// class _CameraStream {
//   /// What should be shown: camera RTSP url, local UDP relay, or '' (nothing,
//   /// e.g. while FFmpeg is taking over the camera connection).
//   String source = '';

//   /// Players that want to show this camera. Only the LAST one plays, because the
//   /// camera allows one RTSP client and the relay port allows one UDP reader.
//   final List<ExoStreamController> owners = [];
//   Timer? retry;

//   ExoStreamController? get active => owners.isEmpty ? null : owners.last;
// }

// /// Decides which native player shows each camera (tile, fullscreen or PiP)
// /// and what it shows (RTSP or the recording relay).
// class GlobalStreamCache {
//   static final Map<String, _CameraStream> _streams = {};

//   static _CameraStream _stream(String url) => _streams.putIfAbsent(url, () => _CameraStream());

//   /// Camera URLs that currently have at least one player on screen.
//   static List<String> get urls =>
//       _streams.entries.where((e) => e.value.owners.isNotEmpty).map((e) => e.key).toList();

//   static String? get activeStreamUrl {
//     final list = urls;
//     return list.isEmpty ? null : list.first;
//   }

//   static String sourceOf(String url) => _streams[url]?.source ?? '';

//   /// Register a player for a camera. onTop = take over the stream now
//   /// (fullscreen, PiP); onTop: false = wait until the others are closed (tile).
//   static void attach(String url, ExoStreamController c, {bool onTop = true}) {
//     if (url.isEmpty) return;
//     final s = _stream(url);
//     if (s.owners.contains(c)) return;
//     c.onError = (msg) => _onError(url, c, msg);

//     if (!onTop && s.owners.isNotEmpty) {
//       s.owners.insert(0, c);
//       return;
//     }
//     final prev = s.active;
//     s.owners.add(c);
//     if (prev != null) prev.stop();
//     _playActive(url, delayed: prev != null);
//   }

//   /// Unregister a player; if it was showing the stream, the next one takes over.
//   static void detach(String url, ExoStreamController c) {
//     final s = _streams[url];
//     if (s == null || !s.owners.contains(c)) return;
//     final wasActive = s.active == c;
//     s.owners.remove(c);
//     if (wasActive) {
//       s.retry?.cancel();
//       c.stop();
//       _playActive(url, delayed: true);
//     }
//   }

//   /// Change what a camera shows (RTSP, relay, or '' to release the camera).
//   static void setSource(String url, String src) {
//     if (url.isEmpty) return;
//     final s = _stream(url);
//     s.retry?.cancel();
//     s.source = src;
//     final a = s.active;
//     if (a == null) return;
//     if (src.isEmpty) {
//       a.stop();
//     } else {
//       a.play(src);
//     }
//   }

//   static Future<Uint8List?> snapshot(String url) async => _streams[url]?.active?.snapshot();

//   static void _playActive(String url, {required bool delayed}) {
//     final s = _streams[url];
//     if (s == null) return;
//     // Short delay lets the previous player release the RTSP session / UDP port
//     Future.delayed(Duration(milliseconds: delayed ? 500 : 0), () {
//       final a = s.active;
//       if (a != null && s.source.isNotEmpty) a.play(s.source);
//     });
//   }

//   /// ExoPlayer only reports real failures (not decoder warnings), so a simple retry is safe.
//   static void _onError(String url, ExoStreamController c, String msg) {
//     debugPrint('Stream error [$url]: $msg');
//     final s = _streams[url];
//     if (s == null || s.active != c || s.source.isEmpty) return;
//     final failed = s.source;
//     s.retry?.cancel();
//     s.retry = Timer(const Duration(seconds: 2), () {
//       if (s.active == c && s.source == failed) c.play(failed);
//     });
//   }

//   static Future<void> releaseAll() async {
//     if (GlobalRecordingManager.sessions.values.any((s) => s.isRecording)) return;
//     _streams.removeWhere((_, s) => s.owners.isEmpty);
//     await FlutterForegroundTask.stopService();
//   }
// }

// class CameraView extends StatefulWidget {
//   final String url;
//   final String label;
//   final String taskName;
//   final int faceNumber;
//   final Function(String, DateTime, String, bool, String)? onSnapshot;
//   final Function(String, DateTime, String)? onVideoRecorded;

//   const CameraView({
//     super.key,
//     required this.url,
//     required this.label,
//     required this.taskName,
//     this.faceNumber = 1,
//     this.onSnapshot,
//     this.onVideoRecorded,

//   });


//   @override
//   State<CameraView> createState() => _CameraViewState();
// }

// class _CameraViewState extends State<CameraView> with AutomaticKeepAliveClientMixin {
//   // Native players for the small tile and fullscreen. GlobalStreamCache decides
//   // which one (or the PiP window) is allowed to show the stream at any moment.
//   final ExoStreamController _exoSmall = ExoStreamController();
//   final ExoStreamController _exoFs = ExoStreamController();

//   final ValueNotifier<bool> _isRecording = ValueNotifier(false);
//   final ValueNotifier<bool> _isPaused = ValueNotifier(false);
//   final ValueNotifier<String> _timerText = ValueNotifier("00:00:00");

//   bool _isTakingSnap = false;

//   Timer? _uiTimer;
//   Timer? _chunkScannerTimer;

//   int get _relayPort => widget.label.endsWith('A') ? 6001 : 6002;
//   // FFmpeg side (sender)
//   String get _relayOutUrl => 'udp://127.0.0.1:$_relayPort?pkt_size=1316';
//   // ExoPlayer side (receiver) – plain URL, exactly like the Kotlin app
//   String get _relayUrl => 'udp://127.0.0.1:$_relayPort';

//   String get _basePrefix {
//     final safeTaskName = widget.taskName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     final safeCamLabel = widget.label.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
//     return '${safeTaskName}_Face_${widget.faceNumber}_${safeCamLabel}_vid';
//   }

//   RecordSessionState get session {
//     if (!GlobalRecordingManager.sessions.containsKey(widget.label)) {
//       GlobalRecordingManager.sessions[widget.label] = RecordSessionState();
//     }
//     return GlobalRecordingManager.sessions[widget.label]!;
//   }

//   @override
//   bool get wantKeepAlive => true;


//   @override
//   void initState() {
//     super.initState();
//     _recoverRecordingState();
//     _startTimers();

//     if (widget.url.isNotEmpty) {
//       final s = session;
//       final recordingThisCam = s.isRecording && s.url == widget.url;
//       if (!recordingThisCam && GlobalStreamCache.sourceOf(widget.url).isEmpty) {
//         GlobalStreamCache.setSource(widget.url, widget.url);
//       }
//       // Bottom of the stack: if PiP/fullscreen already shows this camera, it keeps it.
//       GlobalStreamCache.attach(widget.url, _exoSmall, onTop: false);
      
//     }
//   }

//   /// Changes what this camera shows in whichever player is active (tile, fullscreen or PiP).
//   void _setSource(String src) => GlobalStreamCache.setSource(widget.url, src);

//   // ───────────────────────────── Timers / files ─────────────────────────────

//   void _startTimers() {
//     _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (!mounted) return;
//       final s = session;
//       if (s.isRecording) {
//         Duration d = s.accumulatedTime;
//         if (!s.isPaused && s.chunkStartTime != null) {
//           d += DateTime.now().difference(s.chunkStartTime!);
//         }
//         String h = d.inHours.toString().padLeft(2, '0');
//         String m = (d.inMinutes % 60).toString().padLeft(2, '0');
//         String sec = (d.inSeconds % 60).toString().padLeft(2, '0');
//         _timerText.value = "$h:$m:$sec";
//       }
//     });

//     _chunkScannerTimer = Timer.periodic(const Duration(seconds: 10), (_) async {
//       if (session.isRecording) {
//         await _registerCompletedChunks();
//       }
//     });
//   }

//   void _recoverRecordingState() {
//     final s = session;
//     if ((s.isRecording || s.isPaused) && s.url == widget.url) {
//       _isRecording.value = s.isRecording;
//       _isPaused.value = s.isPaused;
//     }
//   }

//   Future<Directory> get _targetDir async {
//     Directory? baseDir;
//     if (Platform.isAndroid) {
//       baseDir = await getExternalStorageDirectory();
//     }
//     baseDir ??= await getApplicationDocumentsDirectory();

//     final dir = Directory('${baseDir.path}/VividGCS_Videos');
//     if (!await dir.exists()) {
//       await dir.create(recursive: true);
//     }
//     return dir;
//   }

//   Future<int> _getNextSequenceNumber(String dirPath) async {
//     final dir = Directory(dirPath);
//     int maxNum = -1;
//     if (await dir.exists()) {
//       final files = dir.listSync();
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.startsWith(_basePrefix) && name.endsWith('.ts')) {
//           final match = RegExp(r'_(\d{3})\.ts$').firstMatch(name);
//           if (match != null) {
//             final num = int.tryParse(match.group(1)!) ?? -1;
//             if (num > maxNum) maxNum = num;
//           }
//         }
//       }
//     }
//     return maxNum + 1;
//   }

//   Future<void> _registerCompletedChunks() async {
//     try {
//       final dir = await _targetDir;
//       if (!await dir.exists()) return;
//       final files = dir.listSync();

//       final currentActiveFile = session.currentFilePath;

//       List<File> matchedFiles = [];
//       for (var file in files) {
//         final name = file.path.split(Platform.pathSeparator).last;
//         if (name.contains(_basePrefix) && name.endsWith('.ts')) {
//           if (file.path != currentActiveFile) {
//             matchedFiles.add(File(file.path));
//           }
//         }
//       }

//       matchedFiles.sort((a, b) => a.path.compareTo(b.path));

//       for (var file in matchedFiles) {
//         if (!GlobalRecordingManager.registeredFiles.contains(file.path)) {
//           final length = await file.length();
//           if (length > 0) {
//             try {
//               widget.onVideoRecorded?.call(
//                 file.path,
//                 file.lastModifiedSync(),
//                 widget.label,
//               );
//               GlobalRecordingManager.registeredFiles.add(file.path);

//               if (mounted) {
//                 final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('✅ SCANNER SAVED: $mb MB'), backgroundColor: Colors.green),
//                 );
//               }
//             } catch (e) {
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('❌ DB ERROR (Scanner): $e'),
//                     backgroundColor: Colors.red,
//                     duration: const Duration(seconds: 10),
//                   ),
//                 );
//               }
//             }
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Scanner Error: $e");
//     }
//   }

//   // ─────────────────────────────── Recording ───────────────────────────────

//   Future<void> _startOrResumeRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     if (s.isRecording && !s.isPaused) return;

//     try {
//       if (Platform.isAndroid) {
//         if (await FlutterForegroundTask.checkNotificationPermission() != NotificationPermission.granted) {
//           await FlutterForegroundTask.requestNotificationPermission();
//         }
//         if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
//           await FlutterForegroundTask.requestIgnoreBatteryOptimization();
//         }
//       }

//       final dir = await _targetDir;
//       final startNum = await _getNextSequenceNumber(dir.path);

//       if (!await FlutterForegroundTask.isRunningService) {
//         await FlutterForegroundTask.startService(
//           notificationTitle: 'Vivid GCS Recording',
//           notificationText: 'Background stream active...',
//           callback: startCallback,
//         );
//       }

//       s.url = widget.url;
//       s.chunkStartTime = DateTime.now();
//       s.isRecording = true;
//       s.isPaused = false;
//       _isRecording.value = true;
//       _isPaused.value = false;

//       // Same sequence as the Kotlin app:
//       // 1. drop the direct RTSP view so FFmpeg is the only camera client
//       _setSource('');
//       await Future.delayed(const Duration(milliseconds: 300));

//       // 2. start FFmpeg (file + local UDP relay)
//       _spawnFFmpegProcess(s, startNum);

//       // 3. after 2.5 s, show the relay (also works if PiP is showing this camera)
//       final relay = _relayUrl;
//       Future.delayed(const Duration(milliseconds: 2500), () {
//         if (s.isRecording && !s.isPaused) _setSource(relay);
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${widget.label} Recording Started', style: GoogleFonts.jetBrainsMono(fontSize: 12)),
//             backgroundColor: AppTheme.green,
//           ),
//         );
//       }
//       updateDialog?.call();
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed: $e'), backgroundColor: AppTheme.red),
//         );
//       }
//     }
//   }

//   void _spawnFFmpegProcess(RecordSessionState s, int currentStartNum) async {
//     if (!s.isRecording || s.isPaused) return;

//     final dir = await _targetDir;
//     final String currentFilePath =
//         '${dir.path}/${_basePrefix}_${currentStartNum.toString().padLeft(3, '0')}.ts';
//     s.currentFilePath = currentFilePath;

//     final List<String> arguments = [
//       '-y',
//       '-timeout', '10000000',
//       '-rtsp_transport', 'tcp',
//       '-fflags', '+genpts+discardcorrupt',
//       '-i', widget.url,

//       // Output 1: local preview relay
//       '-map', '0:v', '-c:v', 'copy', '-an',
//       '-bsf:v', 'dump_extra',
//       '-f', 'mpegts',
//       '-mpegts_flags', '+resend_headers',
//       '-pat_period', '0.5',
//       '-flush_packets', '1',
//       _relayOutUrl,

//       // Output 2: file
//       '-map', '0:v', '-c:v', 'copy', '-an',
//       '-f', 'mpegts',
//       currentFilePath,
//     ];

//     try {
//       s.session = await FFmpegKit.executeWithArgumentsAsync(arguments, (finishedSession) async {
//         final returnCode = await finishedSession.getReturnCode();
//         if (returnCode != null && !returnCode.isValueSuccess() && !returnCode.isValueCancel()) {
//           final logs = await finishedSession.getLogsAsString();
//           debugPrint("FFMPEG LOG: $logs");
//           if (mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('CRASH: ${logs?.split('\n').last ?? "Error"}'),
//                 backgroundColor: Colors.red,
//                 duration: const Duration(seconds: 10),
//               ),
//             );
//           }
//         }

//         await Future.delayed(const Duration(seconds: 1));

//         final file = File(currentFilePath);
//         if (await file.exists()) {
//           final length = await file.length();
//           if (length > 0 && !GlobalRecordingManager.registeredFiles.contains(currentFilePath)) {
//             try {
//               widget.onVideoRecorded?.call(currentFilePath, DateTime.now(), widget.label);
//               GlobalRecordingManager.registeredFiles.add(currentFilePath);

//               if (mounted) {
//                 final mb = (length / (1024 * 1024)).toStringAsFixed(2);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('✅ DB SAVED: $mb MB'),
//                     backgroundColor: Colors.green,
//                     duration: const Duration(seconds: 5),
//                   ),
//                 );
//               }
//             } catch (e) {
//               if (mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text('❌ DB ERROR: $e'),
//                     backgroundColor: Colors.red,
//                     duration: const Duration(seconds: 10),
//                   ),
//                 );
//               }
//             }
//           }
//         }

//         // Auto-restart if the camera link dropped while still recording
//         if (s.isRecording && !s.isPaused) {
//           await Future.delayed(const Duration(seconds: 1));
//           final nextNum = await _getNextSequenceNumber(dir.path);
//           _spawnFFmpegProcess(s, nextNum);
//           final relay = _relayUrl;
//           Future.delayed(const Duration(milliseconds: 2500), () {
//             if (s.isRecording && !s.isPaused) _setSource(relay);
//           });
//         }
//       });
//     } catch (e) {
//       debugPrint("FATAL DART ERROR: $e");
//     }
//   }

//   Future<void> _pauseRecording({VoidCallback? updateDialog}) async {
//     final s = session;
//     s.isPaused = true;
//     _isPaused.value = true;

//     if (s.session != null) {
//       await FFmpegKit.cancel(s.session!.getSessionId());
//       s.session = null;
//     }
//     if (s.chunkStartTime != null) {
//       s.accumulatedTime += DateTime.now().difference(s.chunkStartTime!);
//     }

//     // FFmpeg has released the camera; go back to direct RTSP
//     await Future.delayed(const Duration(seconds: 1));
//     _setSource(widget.url);
//     updateDialog?.call();
//   }

//   Future<void> _stopEntirely({VoidCallback? updateDialog}) async {
//     try {
//       final s = session;
//       s.isRecording = false;
//       s.isPaused = false;
//       _isRecording.value = false;
//       _isPaused.value = false;
//       _timerText.value = "00:00:00";

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Stopping ${widget.label}...'),
//             backgroundColor: AppTheme.amber,
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }

//       if (s.session != null) {
//         await FFmpegKit.cancel(s.session!.getSessionId());
//         s.session = null;
//       }

//       await Future.delayed(const Duration(seconds: 1));
//       _setSource(widget.url);

//       await Future.delayed(const Duration(seconds: 1));
//       s.currentFilePath = '';
//       await _registerCompletedChunks();

//       GlobalRecordingManager.sessions.remove(widget.label);

//       if (!GlobalRecordingManager.sessions.values.any((sess) => sess.isRecording)) {
//         await FlutterForegroundTask.stopService();
//       }
//     } catch (e) {
//       debugPrint("Stop error: $e");
//     }
//     updateDialog?.call();
//   }

//   // ─────────────────────────────── Snapshot ───────────────────────────────

//   Future<void> _takeSnapshot({VoidCallback? updateDialog}) async {
//     if (_isTakingSnap || GlobalStreamCache.sourceOf(widget.url).isEmpty) return;
//     _isTakingSnap = true;
//     if (mounted) setState(() {});
//     updateDialog?.call();

//     try {
//       final bytes = await GlobalStreamCache.snapshot(widget.url);

//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();

//       if (bytes == null) {
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: const Text('No video frame yet'), backgroundColor: AppTheme.amber),
//           );
//         }
//         return;
//       }

//       final dir = await _targetDir;
//       final timestamp = DateTime.now();
//       final filePath = '${dir.path}/snap_${timestamp.millisecondsSinceEpoch}.png';
//       await File(filePath).writeAsBytes(bytes);

//       if (mounted) {
//         bool isIssue = false;
//         final descCtrl = TextEditingController();
//         await showDialog(
//           context: context,
//           barrierDismissible: false,
//           builder: (ctx) => StatefulBuilder(
//             builder: (context, setModalState) => AlertDialog(
//               backgroundColor: AppTheme.bgPanel,
//               title: Text('Snapshot Captured', style: TextStyle(color: AppTheme.textHi)),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   SwitchListTile(
//                     title: Text('Flag as Maintenance Issue?',
//                         style: TextStyle(color: AppTheme.textMid, fontSize: 12)),
//                     activeColor: AppTheme.red,
//                     value: isIssue,
//                     onChanged: (v) => setModalState(() => isIssue = v),
//                   ),
//                   if (isIssue)
//                     TextField(
//                       controller: descCtrl,
//                       style: TextStyle(color: AppTheme.textHi, fontSize: 12),
//                       decoration: InputDecoration(
//                         hintText: "Describe the damage/issue...",
//                         hintStyle: TextStyle(color: AppTheme.textLo),
//                       ),
//                     ),
//                 ],
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(ctx);
//                     widget.onSnapshot?.call(filePath, timestamp, widget.label, isIssue, descCtrl.text);
//                   },
//                   child: Text('SAVE TO DB', style: TextStyle(color: AppTheme.cyan)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       _isTakingSnap = false;
//       if (mounted) setState(() {});
//       updateDialog?.call();
//     }
//   }

//   // ─────────────────────────────── UI ───────────────────────────────

//   Widget _buildRecordingControls(VoidCallback updateState) {
//     return ValueListenableBuilder<bool>(
//       valueListenable: _isRecording,
//       builder: (context, isRec, _) {
//         return ValueListenableBuilder<bool>(
//           valueListenable: _isPaused,
//           builder: (context, isPau, _) {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isRec && !isPau)
//                   GestureDetector(
//                     onTap: () => _startOrResumeRecording(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
//                     ),
//                   )
//                 else ...[
//                   GestureDetector(
//                     onTap: () => _stopEntirely(updateDialog: updateState),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
//                       child: Icon(Icons.stop_rounded, color: AppTheme.red, size: 16),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   GestureDetector(
//                     onTap: () {
//                       if (isRec && !isPau) {
//                         _pauseRecording(updateDialog: updateState);
//                       } else {
//                         _startOrResumeRecording(updateDialog: updateState);
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: isPau ? AppTheme.amber : Colors.white,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         isPau ? Icons.play_arrow_rounded : Icons.pause_rounded,
//                         color: Colors.black,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             );
//           },
//         );
//       },
//     );
//   }

//   Future<void> _showFloatingScreen() async {
//     // Hand the stream over to the fullscreen player (camera/relay allow only one reader)
//     GlobalStreamCache.attach(widget.url, _exoFs);

//     await showGeneralDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.95),
//       barrierDismissible: true,
//       barrierLabel: 'LiveFeed',
//       transitionDuration: const Duration(milliseconds: 250),
//       pageBuilder: (ctx, anim1, anim2) {
//         return SafeArea(
//           child: Scaffold(
//             backgroundColor: Colors.transparent,
//             body: StatefulBuilder(
//               builder: (context, setDialogState) {
//                 return Stack(
//                   children: [
//                     Center(
//                       child: AspectRatio(
//                         aspectRatio: 16 / 9,
//                         child: ExoStreamView(controller: _exoFs, cover: false),
//                       ),
//                     ),
//                     Positioned(
//                       top: 16,
//                       right: 16,
//                       child: IconButton(
//                         icon: const Icon(Icons.close_rounded, color: Colors.white, size: 36),
//                         onPressed: () => Navigator.pop(ctx),
//                       ),
//                     ),
//                     Positioned(
//                       top: 24,
//                       left: 24,
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                             decoration: BoxDecoration(
//                               color: AppTheme.bgCard.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(6),
//                               border: Border.all(color: AppTheme.cyan),
//                             ),
//                             child: Text(
//                               '${widget.label} (LIVE)',
//                               style: GoogleFonts.jetBrainsMono(color: AppTheme.cyan, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                           ValueListenableBuilder<bool>(
//                             valueListenable: _isRecording,
//                             builder: (context, isRec, _) {
//                               return ValueListenableBuilder<bool>(
//                                 valueListenable: _isPaused,
//                                 builder: (context, isPau, _) {
//                                   if (!isRec && !isPau) return const SizedBox.shrink();
//                                   return Row(
//                                     children: [
//                                       const SizedBox(width: 12),
//                                       Container(
//                                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                         decoration: BoxDecoration(
//                                           color: AppTheme.red.withOpacity(0.8),
//                                           borderRadius: BorderRadius.circular(6),
//                                           border: Border.all(color: AppTheme.red),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             const Icon(Icons.circle, color: Colors.white, size: 10),
//                                             const SizedBox(width: 6),
//                                             ValueListenableBuilder<String>(
//                                               valueListenable: _timerText,
//                                               builder: (ctx, time, _) => Text(
//                                                 'REC $time',
//                                                 style: GoogleFonts.jetBrainsMono(
//                                                     color: Colors.white, fontWeight: FontWeight.bold),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       if (isPau) ...[
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                                           decoration: BoxDecoration(
//                                             color: AppTheme.amber.withOpacity(0.8),
//                                             borderRadius: BorderRadius.circular(6),
//                                             border: Border.all(color: AppTheme.amber),
//                                           ),
//                                           child: Text(
//                                             'PAUSED',
//                                             style: GoogleFonts.jetBrainsMono(
//                                                 color: Colors.black, fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ],
//                                     ],
//                                   );
//                                 },
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 30,
//                       right: 30,
//                       child: Row(
//                         children: [
//                           Transform.scale(
//                             scale: 1.5,
//                             child: _buildRecordingControls(() => setDialogState(() {})),
//                           ),
//                           const SizedBox(width: 40),
//                           GestureDetector(
//                             onTap: () => _takeSnapshot(updateDialog: () => setDialogState(() {})),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                                 shape: BoxShape.circle,
//                                 boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 8)],
//                               ),
//                               child: _isTakingSnap
//                                   ? const SizedBox(
//                                       width: 28,
//                                       height: 28,
//                                       child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
//                                     )
//                                   : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );

//     // Fullscreen closed: give the stream back to the small tile
//     GlobalStreamCache.detach(widget.url, _exoFs);
//     _exoFs.detach();
//   }

//   @override
//   void dispose() {
//     _uiTimer?.cancel();
//     _chunkScannerTimer?.cancel();
//     GlobalStreamCache.detach(widget.url, _exoSmall);
//     GlobalStreamCache.detach(widget.url, _exoFs);
//     _exoSmall.detach();
//     _exoFs.detach();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final hasUrl = widget.url.isNotEmpty;
//     final h = MediaQuery.of(context).size.width >= 600 ? 250.0 : 200.0;

//     return GestureDetector(
//       onTap: hasUrl ? _showFloatingScreen : null,
//       child: Container(
//         height: h,
//         decoration: BoxDecoration(
//           color: AppTheme.bgRaised,
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: AppTheme.borderDim),
//         ),
//         child: Stack(
//           children: [
//             if (hasUrl)
//               Positioned.fill(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: ExoStreamView(controller: _exoSmall, cover: true),
//                 ),
//               )
//             else
//               Center(child: Text('NO STREAM CONFIGURED', style: TextStyle(color: AppTheme.red))),

//             Positioned(
//               top: 10,
//               left: 10,
//               child: Row(
//                 children: [
//                   StatusBadge(
//                     label: hasUrl ? 'LIVE' : 'OFFLINE',
//                     color: hasUrl ? AppTheme.green : AppTheme.red,
//                   ),
//                   ValueListenableBuilder<bool>(
//                     valueListenable: _isRecording,
//                     builder: (context, isRec, _) {
//                       return ValueListenableBuilder<bool>(
//                         valueListenable: _isPaused,
//                         builder: (context, isPau, _) {
//                           if (!isRec && !isPau) return const SizedBox.shrink();
//                           return Row(
//                             children: [
//                               const SizedBox(width: 8),
//                               ValueListenableBuilder<String>(
//                                 valueListenable: _timerText,
//                                 builder: (ctx, time, _) => StatusBadge(label: 'REC $time', color: AppTheme.red),
//                               ),
//                               if (isPau) ...[
//                                 const SizedBox(width: 8),
//                                 StatusBadge(label: 'PAUSED', color: AppTheme.amber),
//                               ],
//                             ],
//                           );
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             if (hasUrl)
//               Positioned(
//                 top: 10,
//                 right: 10,
//                 child: Row(
//                   children: [
//                     _buildRecordingControls(() {}),
//                     const SizedBox(width: 10),
//                     GestureDetector(
//                       onTap: () => _takeSnapshot(),
//                       child: Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: _isTakingSnap ? Colors.grey : AppTheme.cyan,
//                           shape: BoxShape.circle,
//                         ),
//                         child: _isTakingSnap
//                             ? const SizedBox(
//                                 width: 16,
//                                 height: 16,
//                                 child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
//                               )
//                             : const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }