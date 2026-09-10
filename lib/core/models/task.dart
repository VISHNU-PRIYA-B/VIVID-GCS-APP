import 'package:isar/isar.dart';

part 'task.g.dart';

@embedded
class AlertLog {
  DateTime? timestamp;
  String? message;
  String? type;

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp?.toIso8601String(),
    "message": message,
    "type": type,
  };
}

@embedded
class TaskSnapshot {
  String? filePath;
  DateTime? timestamp;
  String? cameraName;
  bool isIssue = false;
  String? issueDescription;

  Map<String, dynamic> toJson() => {
    "filePath": filePath,
    "timestamp": timestamp?.toIso8601String(),
    "cameraName": cameraName,
    "isIssue": isIssue,
    "issueDescription": issueDescription,
  };

  static TaskSnapshot fromJson(Map<String, dynamic> json) {
    return TaskSnapshot()
      ..filePath = json["filePath"]
      ..timestamp = json["timestamp"] != null
          ? DateTime.parse(json["timestamp"])
          : null
      ..cameraName = json["cameraName"]
      ..isIssue = json["isIssue"] ?? false
      ..issueDescription = json["issueDescription"];
  }
}
// fl chart
@embedded
  class HistoryPointer {
    double hour=0;
    double value=0;
  }

@embedded
class TaskVideo {
  String? filePath;
  DateTime? timestamp;
  String? cameraName;

  Map<String, dynamic> toJson() => {
    "filePath": filePath,
    "timestamp": timestamp?.toIso8601String(),
    "cameraName": cameraName,
  };

  static TaskVideo fromJson(Map<String, dynamic> json) {
    return TaskVideo()
      ..filePath = json["filePath"]
      ..timestamp = json["timestamp"] != null
          ? DateTime.parse(json["timestamp"])
          : null
      ..cameraName = json["cameraName"];
  }
}
// resume task
// enum TaskStatus {
//   pending,
//   inProgress,
//   completed,
//   active,
//   paused,
// }

// @Enumerated(EnumType.name)
// late TaskStatus status;

// resume
class TaskStatus {
  static const String pending = 'PENDING';
  static const String inProgress = 'IN_PROGRESS';
  static const String completed = 'COMPLETED';
  static const String active = 'ACTIVE';
  static const String paused = 'PAUSED';
}


@collection
class Task {
  Id id = Isar.autoIncrement;

  int currentFace = 1;
  int currentStrip = 0;
  int? numberOfFaces;

  // Stores JSON of exact stretch counts, paths, and history!
  String mappingState = "{}";

  late String buildingName;
  late double buildingHeight;
  late double surfaceArea;

  String cameraALink = '';
  String cameraBLink = '';
  String telemetryPort = '';

  bool isSynced = false;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  bool isDeleted = false;

  late String deviceId;

  String status = 'PENDING';
  DateTime? sessionDate;
  double areaCovered = 0.0;
  double waterUsed = 0.0;
  double energyConsumed = 0.0;
  double carbonSaved = 0.0;
  double waterSaved = 0.0;

  // fl chart
  List<HistoryPointer> waterHistoryPersisted = [];
  List<HistoryPointer> energyHistoryPersisted = [];
  List<HistoryPointer> areaHistoryPersisted = [];

  List<TaskSnapshot> snapshots = [];
  List<AlertLog> alerts = [];
  List<TaskVideo> videos = [];

  Map<String, dynamic> toJson() => {
    "id": id,
    "currentFace": currentFace,
    "currentStrip": currentStrip,
    "numberOfFaces": numberOfFaces,
    "mappingState": mappingState,
    "buildingName": buildingName,
    "buildingHeight": buildingHeight,
    "surfaceArea": surfaceArea,
    "cameraALink": cameraALink,
    "cameraBLink": cameraBLink,
    "telemetryPort": telemetryPort,
    "deviceId": deviceId,
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "isDeleted": isDeleted,
    "status": status,
    "sessionDate": sessionDate?.toIso8601String(),
    "areaCovered": areaCovered,
    "waterUsed": waterUsed,
    "energyConsumed": energyConsumed,
    "carbonSaved": carbonSaved,
    "waterSaved": waterSaved,
    "snapshots": snapshots.map((s) => s.toJson()).toList(),
    "alerts": alerts.map((a) => a.toJson()).toList(),
    "videos": videos.map((v) => v.toJson()).toList(),
  };

  static Task fromJson(Map<String, dynamic> json) {
    return Task()
      ..id = json["id"]
      ..currentFace = json["currentFace"] ?? 1
      ..currentStrip = json["currentStrip"] ?? 0
      ..numberOfFaces = json["numberOfFaces"] as int?
      ..mappingState = json["mappingState"] ?? "{}"
      ..buildingName = json["buildingName"]
      ..buildingHeight = (json["buildingHeight"] as num).toDouble()
      ..surfaceArea = (json["surfaceArea"] as num).toDouble()
      ..cameraALink = json["cameraALink"] ?? ''
      ..cameraBLink = json["cameraBLink"] ?? ''
      ..telemetryPort = json["telemetryPort"] ?? ''
      ..deviceId = json["deviceId"]
      ..updatedAt = DateTime.parse(json["updatedAt"])
      ..createdAt = DateTime.parse(json["createdAt"])
      ..isDeleted = json["isDeleted"] ?? false
      ..isSynced = true
      ..status = json["status"] ?? 'PENDING'
      ..sessionDate = json["sessionDate"] != null
          ? DateTime.parse(json["sessionDate"])
          : null
      ..areaCovered = (json["areaCovered"] as num?)?.toDouble() ?? 0.0
      ..waterUsed = (json["waterUsed"] as num?)?.toDouble() ?? 0.0
      ..energyConsumed = (json["energyConsumed"] as num?)?.toDouble() ?? 0.0
      ..carbonSaved = (json["carbonSaved"] as num?)?.toDouble() ?? 0.0
      ..waterSaved = (json["waterSaved"] as num?)?.toDouble() ?? 0.0
      ..snapshots =
          (json["snapshots"] as List<dynamic>?)
              ?.map((s) => TaskSnapshot.fromJson(s as Map<String, dynamic>))
              .toList() ??
          []
      ..alerts =
          (json["alerts"] as List<dynamic>?)
              ?.map(
                (a) => AlertLog()
                  ..message = a["message"]
                  ..type = a["type"]
                  ..timestamp = a["timestamp"] != null
                      ? DateTime.parse(a["timestamp"])
                      : null,
              )
              .toList() ??
          []
      ..videos =
          (json["videos"] as List<dynamic>?)
              ?.map((v) => TaskVideo.fromJson(v as Map<String, dynamic>))
              .toList() ??
          [];
  }
}