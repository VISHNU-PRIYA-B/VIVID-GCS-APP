import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart' as fp; // 👉 FIX: Prefix prevents naming collisions
import '../db/isar_service.dart';
import '../models/task.dart';
import '../utils/device_id.dart'; 
import '../../../ui/app_theme.dart';

class TaskShareService {
  static const int p2pPort = 8989;
  static HttpServer? _server;

  // ── 1. SERIALIZE TASK TO MAP ──
  static Map<String, dynamic> taskToMap(Task task) {
    return {
      'version': '2.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'task': {
        'buildingName': task.buildingName,
        'buildingHeight': task.buildingHeight,
        'surfaceArea': task.surfaceArea,
        'numberOfFaces': task.numberOfFaces,
        'cameraALink': task.cameraALink,
        'cameraBLink': task.cameraBLink,
        'telemetryPort': task.telemetryPort,
        'currentFace': task.currentFace,
        'currentStrip': task.currentStrip,
        'waterUsed': task.waterUsed,
        'energyConsumed': task.energyConsumed,
        'areaCovered': task.areaCovered,
        'mappingState': task.mappingState,
      },
    };
  }

  // ── 2. DESERIALIZE AND SAVE TO ISAR ──
  static Future<Task?> importTaskFromMap(Map<String, dynamic> data) async {
    try {
      final taskData = data['task'] as Map<String, dynamic>;
      
      final localDeviceId = await DeviceId.get(); 

      final task = Task()
        ..buildingName = taskData['buildingName'] ?? 'Imported Task'
        ..buildingHeight = (taskData['buildingHeight'] as num?)?.toDouble() ?? 0.0
        ..surfaceArea = (taskData['surfaceArea'] as num?)?.toDouble() ?? 0.0
        ..numberOfFaces = (taskData['numberOfFaces'] as num?)?.toInt() ?? 1
        ..cameraALink = taskData['cameraALink'] ?? ''
        ..cameraBLink = taskData['cameraBLink'] ?? ''
        ..telemetryPort = taskData['telemetryPort'] ?? 'AUTO-DETECT'
        ..currentFace = (taskData['currentFace'] as num?)?.toInt() ?? 1
        ..currentStrip = (taskData['currentStrip'] as num?)?.toInt() ?? 0
        ..waterUsed = (taskData['waterUsed'] as num?)?.toDouble() ?? 0.0
        ..energyConsumed = (taskData['energyConsumed'] as num?)?.toDouble() ?? 0.0
        ..areaCovered = (taskData['areaCovered'] as num?)?.toDouble() ?? 0.0
        ..mappingState = taskData['mappingState'] ?? '{}'
        ..deviceId = localDeviceId 
        ..status = 'PAUSED'
        ..isSynced = false
        ..updatedAt = DateTime.now();

      await IsarService.addTask(task);
      return task;
    } catch (e) {
      debugPrint("Import parsing error: $e");
      return null;
    }
  }

  // ── 3. METHOD A: SHARE VIA BLUETOOTH / ANDROID SHARE SHEET ──
  static Future<void> shareTaskViaSystem(Task task, BuildContext context) async {
    try {
      final jsonMap = taskToMap(task);
      final jsonString = jsonEncode(jsonMap);

      final dir = await getTemporaryDirectory();
      final safeName = (task.buildingName ?? 'Task').replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final file = File('${dir.path}/${safeName}_state.vgcs');
      await file.writeAsString(jsonString);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Vivid GCS Task Transfer: ${task.buildingName}',
        subject: 'Vivid Task Export',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e'), backgroundColor: AppTheme.red),
        );
      }
    }
  }

  // ── 4. METHOD A (RECEIVER): NATIVE OS FILE EXPLORER ──
  static Future<void> showImportFileDialog(BuildContext context, VoidCallback onImportSuccess) async {
    try {
      // 👉 FIX: Removed '.platform' to support the new file_picker 10.0+ API
      fp.FilePickerResult? result = await fp.FilePicker.pickFiles(
        type: fp.FileType.any, 
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        
        // Ensure it's our file format
        if (!file.path.endsWith('.vgcs') && !file.path.endsWith('.json')) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('Invalid file format. Please select a .vgcs task file.'), backgroundColor: AppTheme.amber),
            );
          }
          return;
        }

        final content = await file.readAsString();
        final map = jsonDecode(content) as Map<String, dynamic>;
        final imported = await importTaskFromMap(map);

        if (imported != null) {
          onImportSuccess();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Imported "${imported.buildingName}" successfully!'), backgroundColor: AppTheme.green),
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reading file: $e'), backgroundColor: AppTheme.red),
        );
      }
    }
  }

  // ── 5. METHOD B: DIRECT LOCAL WI-FI / HOTSPOT P2P SERVER ──
  static Future<void> startP2PReceiver(BuildContext context, VoidCallback onImportSuccess) async {
    await stopP2PReceiver();

    try {
      _server = await HttpServer.bind(InternetAddress.anyIPv4, p2pPort);
      String localIp = 'Detecting...';
      try {
        final interfaces = await NetworkInterface.list(type: InternetAddressType.IPv4);
        for (var iface in interfaces) {
          for (var addr in iface.addresses) {
            if (!addr.isLoopback) {
              localIp = addr.address;
              break;
            }
          }
        }
      } catch (_) {}

      if (!context.mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogCtx) => AlertDialog(
          backgroundColor: AppTheme.bgPanel,
          title: Row(
            children: [
              Icon(Icons.wifi_tethering_rounded, color: AppTheme.green),
              const SizedBox(width: 8),
              Text('Wi-Fi Task Receiver', style: GoogleFonts.barlowCondensed(color: AppTheme.textHi)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Listening on MK32 Local Network:', style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppTheme.textMid)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(6)),
                child: Text('IP: $localIp\nPort: $p2pPort', style: GoogleFonts.jetBrainsMono(fontSize: 13, color: AppTheme.green, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              const Text('On Device A: Tap "Send via Wi-Fi" and enter this IP address.', style: TextStyle(fontSize: 11)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                stopP2PReceiver();
                Navigator.pop(dialogCtx);
              },
              child: Text('CANCEL', style: TextStyle(color: AppTheme.red)),
            ),
          ],
        ),
      );

      _server!.listen((HttpRequest request) async {
        if (request.method == 'POST') {
          try {
            final body = await utf8.decoder.bind(request).join();
            final data = jsonDecode(body) as Map<String, dynamic>;
            final imported = await importTaskFromMap(data);
            
            request.response
              ..statusCode = HttpStatus.ok
              ..write(jsonEncode({'status': 'ok'}))
              ..close();

            await stopP2PReceiver();
            if (context.mounted) Navigator.of(context, rootNavigator: true).pop();

            if (imported != null) {
              onImportSuccess();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Received "${imported.buildingName}" successfully!'), backgroundColor: AppTheme.green),
                );
              }
            } else {
              throw Exception("Database rejected imported task format.");
            }
          } catch (e) {
            await stopP2PReceiver();
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop(); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to process task: $e'), backgroundColor: AppTheme.red),
              );
            }
          }
        }
      });
    } catch (e) {
      debugPrint("P2P Bind Error: $e");
    }
  }

  static Future<void> sendTaskOverWifi(Task task, String targetIp, BuildContext context) async {
    try {
      final client = HttpClient()..connectionTimeout = const Duration(seconds: 4);
      final req = await client.post(targetIp, p2pPort, '/transfer');
      req.headers.contentType = ContentType.json;
      req.write(jsonEncode(taskToMap(task)));
      final resp = await req.close();
      if (resp.statusCode == HttpStatus.ok && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transferred "${task.buildingName}" to $targetIp'), backgroundColor: AppTheme.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Wi-Fi Transfer Failed: $e'), backgroundColor: AppTheme.red),
        );
      }
    }
  }

  static Future<void> stopP2PReceiver() async {
    await _server?.close(force: true);
    _server = null;
  }
}