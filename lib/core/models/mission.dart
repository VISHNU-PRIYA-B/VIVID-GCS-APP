import 'package:isar/isar.dart';

part 'mission.g.dart';

@collection
class Mission {
  Id id = Isar.autoIncrement;

  late int taskId;

  late String robotId;

  DateTime startTime = DateTime.now();

  DateTime? endTime;

  String status = "running";

  double cleanedArea = 0;

  double waterUsed = 0;

  bool isSynced = false;

  late String deviceId;

  DateTime updatedAt = DateTime.now();
}