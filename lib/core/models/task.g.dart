// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTaskCollection on Isar {
  IsarCollection<Task> get tasks => this.collection();
}

const TaskSchema = CollectionSchema(
  name: r'Task',
  id: 2998003626758701373,
  properties: {
    r'alerts': PropertySchema(
      id: 0,
      name: r'alerts',
      type: IsarType.objectList,
      target: r'AlertLog',
    ),
    r'areaCovered': PropertySchema(
      id: 1,
      name: r'areaCovered',
      type: IsarType.double,
    ),
    r'areaHistoryPersisted': PropertySchema(
      id: 2,
      name: r'areaHistoryPersisted',
      type: IsarType.objectList,
      target: r'HistoryPointer',
    ),
    r'buildingHeight': PropertySchema(
      id: 3,
      name: r'buildingHeight',
      type: IsarType.double,
    ),
    r'buildingName': PropertySchema(
      id: 4,
      name: r'buildingName',
      type: IsarType.string,
    ),
    r'cameraALink': PropertySchema(
      id: 5,
      name: r'cameraALink',
      type: IsarType.string,
    ),
    r'cameraBLink': PropertySchema(
      id: 6,
      name: r'cameraBLink',
      type: IsarType.string,
    ),
    r'carbonSaved': PropertySchema(
      id: 7,
      name: r'carbonSaved',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 8,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentFace': PropertySchema(
      id: 9,
      name: r'currentFace',
      type: IsarType.long,
    ),
    r'currentStrip': PropertySchema(
      id: 10,
      name: r'currentStrip',
      type: IsarType.long,
    ),
    r'deviceId': PropertySchema(
      id: 11,
      name: r'deviceId',
      type: IsarType.string,
    ),
    r'energyConsumed': PropertySchema(
      id: 12,
      name: r'energyConsumed',
      type: IsarType.double,
    ),
    r'energyHistoryPersisted': PropertySchema(
      id: 13,
      name: r'energyHistoryPersisted',
      type: IsarType.objectList,
      target: r'HistoryPointer',
    ),
    r'isDeleted': PropertySchema(
      id: 14,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'isSynced': PropertySchema(
      id: 15,
      name: r'isSynced',
      type: IsarType.bool,
    ),
    r'mappingState': PropertySchema(
      id: 16,
      name: r'mappingState',
      type: IsarType.string,
    ),
    r'numberOfFaces': PropertySchema(
      id: 17,
      name: r'numberOfFaces',
      type: IsarType.long,
    ),
    r'sessionDate': PropertySchema(
      id: 18,
      name: r'sessionDate',
      type: IsarType.dateTime,
    ),
    r'snapshots': PropertySchema(
      id: 19,
      name: r'snapshots',
      type: IsarType.objectList,
      target: r'TaskSnapshot',
    ),
    r'status': PropertySchema(
      id: 20,
      name: r'status',
      type: IsarType.string,
    ),
    r'surfaceArea': PropertySchema(
      id: 21,
      name: r'surfaceArea',
      type: IsarType.double,
    ),
    r'telemetryPort': PropertySchema(
      id: 22,
      name: r'telemetryPort',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 23,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'videos': PropertySchema(
      id: 24,
      name: r'videos',
      type: IsarType.objectList,
      target: r'TaskVideo',
    ),
    r'waterHistoryPersisted': PropertySchema(
      id: 25,
      name: r'waterHistoryPersisted',
      type: IsarType.objectList,
      target: r'HistoryPointer',
    ),
    r'waterSaved': PropertySchema(
      id: 26,
      name: r'waterSaved',
      type: IsarType.double,
    ),
    r'waterUsed': PropertySchema(
      id: 27,
      name: r'waterUsed',
      type: IsarType.double,
    )
  },
  estimateSize: _taskEstimateSize,
  serialize: _taskSerialize,
  deserialize: _taskDeserialize,
  deserializeProp: _taskDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'HistoryPointer': HistoryPointerSchema,
    r'TaskSnapshot': TaskSnapshotSchema,
    r'AlertLog': AlertLogSchema,
    r'TaskVideo': TaskVideoSchema
  },
  getId: _taskGetId,
  getLinks: _taskGetLinks,
  attach: _taskAttach,
  version: '3.1.0+1',
);

int _taskEstimateSize(
  Task object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.alerts.length * 3;
  {
    final offsets = allOffsets[AlertLog]!;
    for (var i = 0; i < object.alerts.length; i++) {
      final value = object.alerts[i];
      bytesCount += AlertLogSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.areaHistoryPersisted.length * 3;
  {
    final offsets = allOffsets[HistoryPointer]!;
    for (var i = 0; i < object.areaHistoryPersisted.length; i++) {
      final value = object.areaHistoryPersisted[i];
      bytesCount +=
          HistoryPointerSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.buildingName.length * 3;
  bytesCount += 3 + object.cameraALink.length * 3;
  bytesCount += 3 + object.cameraBLink.length * 3;
  bytesCount += 3 + object.deviceId.length * 3;
  bytesCount += 3 + object.energyHistoryPersisted.length * 3;
  {
    final offsets = allOffsets[HistoryPointer]!;
    for (var i = 0; i < object.energyHistoryPersisted.length; i++) {
      final value = object.energyHistoryPersisted[i];
      bytesCount +=
          HistoryPointerSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.mappingState.length * 3;
  bytesCount += 3 + object.snapshots.length * 3;
  {
    final offsets = allOffsets[TaskSnapshot]!;
    for (var i = 0; i < object.snapshots.length; i++) {
      final value = object.snapshots[i];
      bytesCount += TaskSnapshotSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.telemetryPort.length * 3;
  bytesCount += 3 + object.videos.length * 3;
  {
    final offsets = allOffsets[TaskVideo]!;
    for (var i = 0; i < object.videos.length; i++) {
      final value = object.videos[i];
      bytesCount += TaskVideoSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.waterHistoryPersisted.length * 3;
  {
    final offsets = allOffsets[HistoryPointer]!;
    for (var i = 0; i < object.waterHistoryPersisted.length; i++) {
      final value = object.waterHistoryPersisted[i];
      bytesCount +=
          HistoryPointerSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _taskSerialize(
  Task object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<AlertLog>(
    offsets[0],
    allOffsets,
    AlertLogSchema.serialize,
    object.alerts,
  );
  writer.writeDouble(offsets[1], object.areaCovered);
  writer.writeObjectList<HistoryPointer>(
    offsets[2],
    allOffsets,
    HistoryPointerSchema.serialize,
    object.areaHistoryPersisted,
  );
  writer.writeDouble(offsets[3], object.buildingHeight);
  writer.writeString(offsets[4], object.buildingName);
  writer.writeString(offsets[5], object.cameraALink);
  writer.writeString(offsets[6], object.cameraBLink);
  writer.writeDouble(offsets[7], object.carbonSaved);
  writer.writeDateTime(offsets[8], object.createdAt);
  writer.writeLong(offsets[9], object.currentFace);
  writer.writeLong(offsets[10], object.currentStrip);
  writer.writeString(offsets[11], object.deviceId);
  writer.writeDouble(offsets[12], object.energyConsumed);
  writer.writeObjectList<HistoryPointer>(
    offsets[13],
    allOffsets,
    HistoryPointerSchema.serialize,
    object.energyHistoryPersisted,
  );
  writer.writeBool(offsets[14], object.isDeleted);
  writer.writeBool(offsets[15], object.isSynced);
  writer.writeString(offsets[16], object.mappingState);
  writer.writeLong(offsets[17], object.numberOfFaces);
  writer.writeDateTime(offsets[18], object.sessionDate);
  writer.writeObjectList<TaskSnapshot>(
    offsets[19],
    allOffsets,
    TaskSnapshotSchema.serialize,
    object.snapshots,
  );
  writer.writeString(offsets[20], object.status);
  writer.writeDouble(offsets[21], object.surfaceArea);
  writer.writeString(offsets[22], object.telemetryPort);
  writer.writeDateTime(offsets[23], object.updatedAt);
  writer.writeObjectList<TaskVideo>(
    offsets[24],
    allOffsets,
    TaskVideoSchema.serialize,
    object.videos,
  );
  writer.writeObjectList<HistoryPointer>(
    offsets[25],
    allOffsets,
    HistoryPointerSchema.serialize,
    object.waterHistoryPersisted,
  );
  writer.writeDouble(offsets[26], object.waterSaved);
  writer.writeDouble(offsets[27], object.waterUsed);
}

Task _taskDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Task();
  object.alerts = reader.readObjectList<AlertLog>(
        offsets[0],
        AlertLogSchema.deserialize,
        allOffsets,
        AlertLog(),
      ) ??
      [];
  object.areaCovered = reader.readDouble(offsets[1]);
  object.areaHistoryPersisted = reader.readObjectList<HistoryPointer>(
        offsets[2],
        HistoryPointerSchema.deserialize,
        allOffsets,
        HistoryPointer(),
      ) ??
      [];
  object.buildingHeight = reader.readDouble(offsets[3]);
  object.buildingName = reader.readString(offsets[4]);
  object.cameraALink = reader.readString(offsets[5]);
  object.cameraBLink = reader.readString(offsets[6]);
  object.carbonSaved = reader.readDouble(offsets[7]);
  object.createdAt = reader.readDateTime(offsets[8]);
  object.currentFace = reader.readLong(offsets[9]);
  object.currentStrip = reader.readLong(offsets[10]);
  object.deviceId = reader.readString(offsets[11]);
  object.energyConsumed = reader.readDouble(offsets[12]);
  object.energyHistoryPersisted = reader.readObjectList<HistoryPointer>(
        offsets[13],
        HistoryPointerSchema.deserialize,
        allOffsets,
        HistoryPointer(),
      ) ??
      [];
  object.id = id;
  object.isDeleted = reader.readBool(offsets[14]);
  object.isSynced = reader.readBool(offsets[15]);
  object.mappingState = reader.readString(offsets[16]);
  object.numberOfFaces = reader.readLongOrNull(offsets[17]);
  object.sessionDate = reader.readDateTimeOrNull(offsets[18]);
  object.snapshots = reader.readObjectList<TaskSnapshot>(
        offsets[19],
        TaskSnapshotSchema.deserialize,
        allOffsets,
        TaskSnapshot(),
      ) ??
      [];
  object.status = reader.readString(offsets[20]);
  object.surfaceArea = reader.readDouble(offsets[21]);
  object.telemetryPort = reader.readString(offsets[22]);
  object.updatedAt = reader.readDateTime(offsets[23]);
  object.videos = reader.readObjectList<TaskVideo>(
        offsets[24],
        TaskVideoSchema.deserialize,
        allOffsets,
        TaskVideo(),
      ) ??
      [];
  object.waterHistoryPersisted = reader.readObjectList<HistoryPointer>(
        offsets[25],
        HistoryPointerSchema.deserialize,
        allOffsets,
        HistoryPointer(),
      ) ??
      [];
  object.waterSaved = reader.readDouble(offsets[26]);
  object.waterUsed = reader.readDouble(offsets[27]);
  return object;
}

P _taskDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<AlertLog>(
            offset,
            AlertLogSchema.deserialize,
            allOffsets,
            AlertLog(),
          ) ??
          []) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readObjectList<HistoryPointer>(
            offset,
            HistoryPointerSchema.deserialize,
            allOffsets,
            HistoryPointer(),
          ) ??
          []) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readObjectList<HistoryPointer>(
            offset,
            HistoryPointerSchema.deserialize,
            allOffsets,
            HistoryPointer(),
          ) ??
          []) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readLongOrNull(offset)) as P;
    case 18:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 19:
      return (reader.readObjectList<TaskSnapshot>(
            offset,
            TaskSnapshotSchema.deserialize,
            allOffsets,
            TaskSnapshot(),
          ) ??
          []) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    case 23:
      return (reader.readDateTime(offset)) as P;
    case 24:
      return (reader.readObjectList<TaskVideo>(
            offset,
            TaskVideoSchema.deserialize,
            allOffsets,
            TaskVideo(),
          ) ??
          []) as P;
    case 25:
      return (reader.readObjectList<HistoryPointer>(
            offset,
            HistoryPointerSchema.deserialize,
            allOffsets,
            HistoryPointer(),
          ) ??
          []) as P;
    case 26:
      return (reader.readDouble(offset)) as P;
    case 27:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _taskGetId(Task object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _taskGetLinks(Task object) {
  return [];
}

void _taskAttach(IsarCollection<dynamic> col, Id id, Task object) {
  object.id = id;
}

extension TaskQueryWhereSort on QueryBuilder<Task, Task, QWhere> {
  QueryBuilder<Task, Task, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TaskQueryWhere on QueryBuilder<Task, Task, QWhereClause> {
  QueryBuilder<Task, Task, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Task, Task, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskQueryFilter on QueryBuilder<Task, Task, QFilterCondition> {
  QueryBuilder<Task, Task, QAfterFilterCondition> alertsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alerts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> alertsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alerts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> alertsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alerts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> alertsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alerts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> alertsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alerts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> alertsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'alerts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> areaCoveredEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'areaCovered',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> areaCoveredGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'areaCovered',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> areaCoveredLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'areaCovered',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> areaCoveredBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'areaCovered',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      areaHistoryPersistedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'areaHistoryPersisted',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      areaHistoryPersistedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'areaHistoryPersisted',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      areaHistoryPersistedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'areaHistoryPersisted',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      areaHistoryPersistedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'areaHistoryPersisted',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      areaHistoryPersistedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'areaHistoryPersisted',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      areaHistoryPersistedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'areaHistoryPersisted',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buildingHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'buildingHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'buildingHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'buildingHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buildingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'buildingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'buildingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'buildingName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'buildingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'buildingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'buildingName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'buildingName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'buildingName',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> buildingNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'buildingName',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraALink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cameraALink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cameraALink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cameraALink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cameraALink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cameraALink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cameraALink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cameraALink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraALink',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraALinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cameraALink',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraBLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cameraBLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cameraBLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cameraBLink',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cameraBLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cameraBLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cameraBLink',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cameraBLink',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraBLink',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> cameraBLinkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cameraBLink',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> carbonSavedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'carbonSaved',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> carbonSavedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'carbonSaved',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> carbonSavedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'carbonSaved',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> carbonSavedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'carbonSaved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentFaceEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentFace',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentFaceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentFace',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentFaceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentFace',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentFaceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentFace',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentStripEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentStrip',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentStripGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentStrip',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentStripLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentStrip',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> currentStripBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentStrip',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deviceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'deviceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'deviceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> deviceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'deviceId',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> energyConsumedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyConsumed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> energyConsumedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyConsumed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> energyConsumedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyConsumed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> energyConsumedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyConsumed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      energyHistoryPersistedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyHistoryPersisted',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      energyHistoryPersistedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyHistoryPersisted',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      energyHistoryPersistedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyHistoryPersisted',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      energyHistoryPersistedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyHistoryPersisted',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      energyHistoryPersistedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyHistoryPersisted',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      energyHistoryPersistedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'energyHistoryPersisted',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> isSyncedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isSynced',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mappingState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mappingState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mappingState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mappingState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mappingState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mappingState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mappingState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mappingState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mappingState',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> mappingStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mappingState',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> numberOfFacesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'numberOfFaces',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> numberOfFacesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'numberOfFaces',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> numberOfFacesEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numberOfFaces',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> numberOfFacesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numberOfFaces',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> numberOfFacesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numberOfFaces',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> numberOfFacesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numberOfFaces',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> sessionDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sessionDate',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> sessionDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sessionDate',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> sessionDateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sessionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> sessionDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sessionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> sessionDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sessionDate',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> sessionDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sessionDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshots',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshots',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshots',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshots',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshots',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'snapshots',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> surfaceAreaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'surfaceArea',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> surfaceAreaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'surfaceArea',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> surfaceAreaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'surfaceArea',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> surfaceAreaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'surfaceArea',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telemetryPort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'telemetryPort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'telemetryPort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'telemetryPort',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'telemetryPort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'telemetryPort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'telemetryPort',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'telemetryPort',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'telemetryPort',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> telemetryPortIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'telemetryPort',
        value: '',
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'videos',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      waterHistoryPersistedLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterHistoryPersisted',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      waterHistoryPersistedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterHistoryPersisted',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      waterHistoryPersistedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterHistoryPersisted',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      waterHistoryPersistedLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterHistoryPersisted',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      waterHistoryPersistedLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterHistoryPersisted',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition>
      waterHistoryPersistedLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'waterHistoryPersisted',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterSavedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'waterSaved',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterSavedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'waterSaved',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterSavedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'waterSaved',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterSavedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'waterSaved',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterUsedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'waterUsed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterUsedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'waterUsed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterUsedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'waterUsed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterUsedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'waterUsed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TaskQueryObject on QueryBuilder<Task, Task, QFilterCondition> {
  QueryBuilder<Task, Task, QAfterFilterCondition> alertsElement(
      FilterQuery<AlertLog> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'alerts');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> areaHistoryPersistedElement(
      FilterQuery<HistoryPointer> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'areaHistoryPersisted');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> energyHistoryPersistedElement(
      FilterQuery<HistoryPointer> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'energyHistoryPersisted');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> snapshotsElement(
      FilterQuery<TaskSnapshot> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'snapshots');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> videosElement(
      FilterQuery<TaskVideo> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'videos');
    });
  }

  QueryBuilder<Task, Task, QAfterFilterCondition> waterHistoryPersistedElement(
      FilterQuery<HistoryPointer> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'waterHistoryPersisted');
    });
  }
}

extension TaskQueryLinks on QueryBuilder<Task, Task, QFilterCondition> {}

extension TaskQuerySortBy on QueryBuilder<Task, Task, QSortBy> {
  QueryBuilder<Task, Task, QAfterSortBy> sortByAreaCovered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaCovered', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByAreaCoveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaCovered', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByBuildingHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingHeight', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByBuildingHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingHeight', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByBuildingName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingName', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByBuildingNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingName', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCameraALink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraALink', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCameraALinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraALink', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCameraBLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraBLink', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCameraBLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraBLink', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCarbonSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbonSaved', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCarbonSavedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbonSaved', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCurrentFace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentFace', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCurrentFaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentFace', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCurrentStrip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStrip', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByCurrentStripDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStrip', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByEnergyConsumed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyConsumed', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByEnergyConsumedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyConsumed', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByMappingState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappingState', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByMappingStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappingState', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByNumberOfFaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfFaces', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByNumberOfFacesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfFaces', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortBySessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortBySurfaceArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortBySurfaceAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByTelemetryPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telemetryPort', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByTelemetryPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telemetryPort', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByWaterSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterSaved', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByWaterSavedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterSaved', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByWaterUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterUsed', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> sortByWaterUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterUsed', Sort.desc);
    });
  }
}

extension TaskQuerySortThenBy on QueryBuilder<Task, Task, QSortThenBy> {
  QueryBuilder<Task, Task, QAfterSortBy> thenByAreaCovered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaCovered', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByAreaCoveredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'areaCovered', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByBuildingHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingHeight', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByBuildingHeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingHeight', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByBuildingName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingName', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByBuildingNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'buildingName', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCameraALink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraALink', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCameraALinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraALink', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCameraBLink() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraBLink', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCameraBLinkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cameraBLink', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCarbonSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbonSaved', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCarbonSavedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carbonSaved', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCurrentFace() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentFace', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCurrentFaceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentFace', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCurrentStrip() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStrip', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByCurrentStripDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStrip', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByDeviceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByDeviceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deviceId', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByEnergyConsumed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyConsumed', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByEnergyConsumedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyConsumed', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByIsSyncedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isSynced', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByMappingState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappingState', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByMappingStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mappingState', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByNumberOfFaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfFaces', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByNumberOfFacesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numberOfFaces', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenBySessionDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionDate', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenBySurfaceArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenBySurfaceAreaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'surfaceArea', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByTelemetryPort() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telemetryPort', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByTelemetryPortDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'telemetryPort', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByWaterSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterSaved', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByWaterSavedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterSaved', Sort.desc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByWaterUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterUsed', Sort.asc);
    });
  }

  QueryBuilder<Task, Task, QAfterSortBy> thenByWaterUsedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'waterUsed', Sort.desc);
    });
  }
}

extension TaskQueryWhereDistinct on QueryBuilder<Task, Task, QDistinct> {
  QueryBuilder<Task, Task, QDistinct> distinctByAreaCovered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'areaCovered');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByBuildingHeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'buildingHeight');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByBuildingName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'buildingName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCameraALink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cameraALink', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCameraBLink(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cameraBLink', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCarbonSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carbonSaved');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCurrentFace() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentFace');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByCurrentStrip() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStrip');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByDeviceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deviceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByEnergyConsumed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyConsumed');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByIsSynced() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isSynced');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByMappingState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mappingState', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByNumberOfFaces() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numberOfFaces');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctBySessionDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionDate');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctBySurfaceArea() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'surfaceArea');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByTelemetryPort(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'telemetryPort',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByWaterSaved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'waterSaved');
    });
  }

  QueryBuilder<Task, Task, QDistinct> distinctByWaterUsed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'waterUsed');
    });
  }
}

extension TaskQueryProperty on QueryBuilder<Task, Task, QQueryProperty> {
  QueryBuilder<Task, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Task, List<AlertLog>, QQueryOperations> alertsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alerts');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> areaCoveredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaCovered');
    });
  }

  QueryBuilder<Task, List<HistoryPointer>, QQueryOperations>
      areaHistoryPersistedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'areaHistoryPersisted');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> buildingHeightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'buildingHeight');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> buildingNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'buildingName');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> cameraALinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cameraALink');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> cameraBLinkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cameraBLink');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> carbonSavedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carbonSaved');
    });
  }

  QueryBuilder<Task, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Task, int, QQueryOperations> currentFaceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentFace');
    });
  }

  QueryBuilder<Task, int, QQueryOperations> currentStripProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStrip');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> deviceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deviceId');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> energyConsumedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyConsumed');
    });
  }

  QueryBuilder<Task, List<HistoryPointer>, QQueryOperations>
      energyHistoryPersistedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyHistoryPersisted');
    });
  }

  QueryBuilder<Task, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<Task, bool, QQueryOperations> isSyncedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isSynced');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> mappingStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mappingState');
    });
  }

  QueryBuilder<Task, int?, QQueryOperations> numberOfFacesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numberOfFaces');
    });
  }

  QueryBuilder<Task, DateTime?, QQueryOperations> sessionDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionDate');
    });
  }

  QueryBuilder<Task, List<TaskSnapshot>, QQueryOperations> snapshotsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snapshots');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> surfaceAreaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'surfaceArea');
    });
  }

  QueryBuilder<Task, String, QQueryOperations> telemetryPortProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'telemetryPort');
    });
  }

  QueryBuilder<Task, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Task, List<TaskVideo>, QQueryOperations> videosProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'videos');
    });
  }

  QueryBuilder<Task, List<HistoryPointer>, QQueryOperations>
      waterHistoryPersistedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterHistoryPersisted');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> waterSavedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterSaved');
    });
  }

  QueryBuilder<Task, double, QQueryOperations> waterUsedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'waterUsed');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const AlertLogSchema = Schema(
  name: r'AlertLog',
  id: -5692522613300311536,
  properties: {
    r'message': PropertySchema(
      id: 0,
      name: r'message',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 1,
      name: r'timestamp',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 2,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _alertLogEstimateSize,
  serialize: _alertLogSerialize,
  deserialize: _alertLogDeserialize,
  deserializeProp: _alertLogDeserializeProp,
);

int _alertLogEstimateSize(
  AlertLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.message;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _alertLogSerialize(
  AlertLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.message);
  writer.writeDateTime(offsets[1], object.timestamp);
  writer.writeString(offsets[2], object.type);
}

AlertLog _alertLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AlertLog();
  object.message = reader.readStringOrNull(offsets[0]);
  object.timestamp = reader.readDateTimeOrNull(offsets[1]);
  object.type = reader.readStringOrNull(offsets[2]);
  return object;
}

P _alertLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension AlertLogQueryFilter
    on QueryBuilder<AlertLog, AlertLog, QFilterCondition> {
  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'message',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'message',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'message',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'message',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> messageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'message',
        value: '',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> timestampEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> timestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> timestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> timestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<AlertLog, AlertLog, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension AlertLogQueryObject
    on QueryBuilder<AlertLog, AlertLog, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TaskSnapshotSchema = Schema(
  name: r'TaskSnapshot',
  id: -7641505856818164579,
  properties: {
    r'cameraName': PropertySchema(
      id: 0,
      name: r'cameraName',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 1,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'isIssue': PropertySchema(
      id: 2,
      name: r'isIssue',
      type: IsarType.bool,
    ),
    r'issueDescription': PropertySchema(
      id: 3,
      name: r'issueDescription',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 4,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _taskSnapshotEstimateSize,
  serialize: _taskSnapshotSerialize,
  deserialize: _taskSnapshotDeserialize,
  deserializeProp: _taskSnapshotDeserializeProp,
);

int _taskSnapshotEstimateSize(
  TaskSnapshot object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cameraName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.issueDescription;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _taskSnapshotSerialize(
  TaskSnapshot object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cameraName);
  writer.writeString(offsets[1], object.filePath);
  writer.writeBool(offsets[2], object.isIssue);
  writer.writeString(offsets[3], object.issueDescription);
  writer.writeDateTime(offsets[4], object.timestamp);
}

TaskSnapshot _taskSnapshotDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskSnapshot();
  object.cameraName = reader.readStringOrNull(offsets[0]);
  object.filePath = reader.readStringOrNull(offsets[1]);
  object.isIssue = reader.readBool(offsets[2]);
  object.issueDescription = reader.readStringOrNull(offsets[3]);
  object.timestamp = reader.readDateTimeOrNull(offsets[4]);
  return object;
}

P _taskSnapshotDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TaskSnapshotQueryFilter
    on QueryBuilder<TaskSnapshot, TaskSnapshot, QFilterCondition> {
  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cameraName',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cameraName',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cameraName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cameraName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraName',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      cameraNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cameraName',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      isIssueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isIssue',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'issueDescription',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'issueDescription',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issueDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'issueDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'issueDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'issueDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'issueDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'issueDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'issueDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'issueDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'issueDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      issueDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'issueDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      timestampEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      timestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskSnapshot, TaskSnapshot, QAfterFilterCondition>
      timestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskSnapshotQueryObject
    on QueryBuilder<TaskSnapshot, TaskSnapshot, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const HistoryPointerSchema = Schema(
  name: r'HistoryPointer',
  id: 794295191223211930,
  properties: {
    r'hour': PropertySchema(
      id: 0,
      name: r'hour',
      type: IsarType.double,
    ),
    r'value': PropertySchema(
      id: 1,
      name: r'value',
      type: IsarType.double,
    )
  },
  estimateSize: _historyPointerEstimateSize,
  serialize: _historyPointerSerialize,
  deserialize: _historyPointerDeserialize,
  deserializeProp: _historyPointerDeserializeProp,
);

int _historyPointerEstimateSize(
  HistoryPointer object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _historyPointerSerialize(
  HistoryPointer object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.hour);
  writer.writeDouble(offsets[1], object.value);
}

HistoryPointer _historyPointerDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryPointer();
  object.hour = reader.readDouble(offsets[0]);
  object.value = reader.readDouble(offsets[1]);
  return object;
}

P _historyPointerDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension HistoryPointerQueryFilter
    on QueryBuilder<HistoryPointer, HistoryPointer, QFilterCondition> {
  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      hourEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hour',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      hourGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hour',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      hourLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hour',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      hourBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hour',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'value',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HistoryPointer, HistoryPointer, QAfterFilterCondition>
      valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'value',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension HistoryPointerQueryObject
    on QueryBuilder<HistoryPointer, HistoryPointer, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const TaskVideoSchema = Schema(
  name: r'TaskVideo',
  id: -1392608524875316515,
  properties: {
    r'cameraName': PropertySchema(
      id: 0,
      name: r'cameraName',
      type: IsarType.string,
    ),
    r'filePath': PropertySchema(
      id: 1,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 2,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _taskVideoEstimateSize,
  serialize: _taskVideoSerialize,
  deserialize: _taskVideoDeserialize,
  deserializeProp: _taskVideoDeserializeProp,
);

int _taskVideoEstimateSize(
  TaskVideo object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.cameraName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _taskVideoSerialize(
  TaskVideo object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cameraName);
  writer.writeString(offsets[1], object.filePath);
  writer.writeDateTime(offsets[2], object.timestamp);
}

TaskVideo _taskVideoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TaskVideo();
  object.cameraName = reader.readStringOrNull(offsets[0]);
  object.filePath = reader.readStringOrNull(offsets[1]);
  object.timestamp = reader.readDateTimeOrNull(offsets[2]);
  return object;
}

P _taskVideoDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension TaskVideoQueryFilter
    on QueryBuilder<TaskVideo, TaskVideo, QFilterCondition> {
  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cameraName',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      cameraNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cameraName',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      cameraNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cameraName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      cameraNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cameraName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> cameraNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cameraName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      cameraNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cameraName',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      cameraNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cameraName',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> timestampIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      timestampIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'timestamp',
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> timestampEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition>
      timestampGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> timestampLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<TaskVideo, TaskVideo, QAfterFilterCondition> timestampBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TaskVideoQueryObject
    on QueryBuilder<TaskVideo, TaskVideo, QFilterCondition> {}
