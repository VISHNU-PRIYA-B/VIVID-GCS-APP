import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DeviceId {
  static String? _cachedId;

  static Future<String> get() async {
    if (_cachedId != null) return _cachedId!;

    final dir = await getApplicationSupportDirectory();
    final file = File("${dir.path}/device_id.json");

    if (await file.exists()) {
      final data = jsonDecode(await file.readAsString());
      _cachedId = data["deviceId"];
      return _cachedId!;
    }

    final id = const Uuid().v4();

    await file.writeAsString(jsonEncode({"deviceId": id}));

    _cachedId = id;
    return id;
  }
}