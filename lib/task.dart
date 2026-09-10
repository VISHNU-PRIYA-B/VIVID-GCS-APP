class AlertLog {
  DateTime? timestamp;
  String? message;
  String? type; 
}

class TaskSnapshot {
  String? filePath;
  DateTime? timestamp;
  String? cameraName;
  bool isIssue = false;
  String? issueDescription;
}

class TaskVideo {
  String? filePath;
  DateTime? timestamp;
  String? cameraName;
}

class Task {
  int id = 1;
  int currentFace = 1;
  int currentStrip = 0;

  String? buildingName;
  double? buildingHeight;
  double? surfaceArea;
  
  // 👉 THE NEW FIELD FOR HER TO USE
  int? numberOfPhases; 

  String cameraALink = '';
  String cameraBLink = '';
  String telemetryPort = '';

  bool isSynced = false;

  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  bool isDeleted = false;

  String deviceId = "sandbox-device";

  String status = 'PENDING';
  DateTime? sessionDate;
  
  // Telemetry variables she will update
  double areaCovered = 0.0;
  double waterUsed = 0.0;
  double energyConsumed = 0.0;
  double carbonSaved = 0.0;
  double waterSaved = 0.0;

  List<TaskSnapshot> snapshots = [];
  List<AlertLog> alerts = [];
  List<TaskVideo> videos = [];

  late int numberOfFaces;

  get mappingState => null;
}