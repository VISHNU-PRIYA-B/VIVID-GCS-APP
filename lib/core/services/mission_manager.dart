import '../../../core/db/isar_service.dart';
import '../../../core/models/mission.dart';

class MissionManager {
  static Mission? activeMission;

  static Future<void> startMission(int taskId, String deviceId) async {
    final mission = Mission()
      ..taskId = taskId
      ..deviceId = deviceId
      ..startTime = DateTime.now()
      ..isSynced = false
      ..updatedAt = DateTime.now();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.missions.put(mission);
    });

    activeMission = mission;
  }

  static Future<void> pauseMission() async {
    if (activeMission == null) return;

    activeMission!.status = "paused";
    activeMission!.updatedAt = DateTime.now();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.missions.put(activeMission!);
    });
  }

  static Future<void> finishMission() async {
    if (activeMission == null) return;

    activeMission!.status = "completed";
    activeMission!.endTime = DateTime.now();
    activeMission!.updatedAt = DateTime.now();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.missions.put(activeMission!);
    });

    activeMission = null;
  }
}