import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vivid_mapping_sandbox/core/models/mission.dart';

import '../models/task.dart';

class IsarService {
  static late Isar isar;

  static Future<List<Task>> getUnsyncedTasks() async {
    return await isar.tasks.filter().isSyncedEqualTo(false).findAll();
  }

  static Future<void> markTasksAsSynced(List<Task> tasks) async {
    await isar.writeTxn(() async {
      for (final t in tasks) {
        t.isSynced = true;
        await isar.tasks.put(t);
      }
    });
  }

  static Future<void> init() async {
    final dir = await getApplicationSupportDirectory();

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    isar = await Isar.open([TaskSchema, MissionSchema], directory: dir.path);
  }

  // ---------- TASK METHODS ----------

  static Future<void> addTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
  }

  static Future<void> updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(
        task,
      ); // 'put' automatically updates the existing record
    });
  }

  static Future<List<Task>> getTasks() async {
    return await isar.tasks.where().findAll();
  }

  static Future<void> deleteTask(int id) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(id);
    });
  }

  static Future<void> mergeTask(Task incoming) async {
    final existing = await isar.tasks
        .filter()
        .idEqualTo(incoming.id)
        .findFirst();

    await isar.writeTxn(() async {
      if (existing == null) {
        await isar.tasks.put(incoming);
      } else {
        if (incoming.updatedAt.isAfter(existing.updatedAt)) {
          await isar.tasks.put(incoming);
        }
      }
    });
  }

  // ---------- MISSION METHODS ----------

  static Future<void> startMission(Mission mission) async {
    await isar.writeTxn(() async {
      await isar.missions.put(mission);
    });
  }

  static Future<List<Mission>> getMissions() async {
    return await isar.missions.where().findAll();
  }

  static Future<void> updateMission(Mission mission) async {
    await isar.writeTxn(() async {
      await isar.missions.put(mission);
    });
  }

  // resume task code
  static Future<List<Task>>getAllTasks() async {
    final tasks = await IsarService.getAllTasks();
    return isar.tasks.where().findAll();
  }
}