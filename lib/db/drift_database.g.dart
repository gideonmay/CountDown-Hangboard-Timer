// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $GripTypesTable extends GripTypes
    with TableInfo<$GripTypesTable, GripType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GripTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? 'grip_types';
  @override
  String get actualTableName => 'grip_types';
  @override
  VerificationContext validateIntegrity(Insertable<GripType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GripType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GripType(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $GripTypesTable createAlias(String alias) {
    return $GripTypesTable(attachedDatabase, alias);
  }
}

class GripType extends DataClass implements Insertable<GripType> {
  final int id;
  final String name;
  const GripType({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  GripTypesCompanion toCompanion(bool nullToAbsent) {
    return GripTypesCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory GripType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GripType(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  GripType copyWith({int? id, String? name}) => GripType(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('GripType(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GripType && other.id == this.id && other.name == this.name);
}

class GripTypesCompanion extends UpdateCompanion<GripType> {
  final Value<int> id;
  final Value<String> name;
  const GripTypesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  GripTypesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<GripType> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  GripTypesCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return GripTypesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GripTypesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 40),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdDateMeta =
      const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
      'created_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime.now()));
  static const VerificationMeta _lastUsedDateMeta =
      const VerificationMeta('lastUsedDate');
  @override
  late final GeneratedColumn<DateTime> lastUsedDate = GeneratedColumn<DateTime>(
      'last_used_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, description, createdDate, lastUsedDate];
  @override
  String get aliasedName => _alias ?? 'workouts';
  @override
  String get actualTableName => 'workouts';
  @override
  VerificationContext validateIntegrity(Insertable<Workout> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
          _createdDateMeta,
          createdDate.isAcceptableOrUnknown(
              data['created_date']!, _createdDateMeta));
    }
    if (data.containsKey('last_used_date')) {
      context.handle(
          _lastUsedDateMeta,
          lastUsedDate.isAcceptableOrUnknown(
              data['last_used_date']!, _lastUsedDateMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      createdDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_date'])!,
      lastUsedDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_used_date']),
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final int id;
  final String name;
  final String description;
  final DateTime createdDate;
  final DateTime? lastUsedDate;
  const Workout(
      {required this.id,
      required this.name,
      required this.description,
      required this.createdDate,
      this.lastUsedDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['created_date'] = Variable<DateTime>(createdDate);
    if (!nullToAbsent || lastUsedDate != null) {
      map['last_used_date'] = Variable<DateTime>(lastUsedDate);
    }
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      createdDate: Value(createdDate),
      lastUsedDate: lastUsedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedDate),
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      lastUsedDate: serializer.fromJson<DateTime?>(json['lastUsedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'lastUsedDate': serializer.toJson<DateTime?>(lastUsedDate),
    };
  }

  Workout copyWith(
          {int? id,
          String? name,
          String? description,
          DateTime? createdDate,
          Value<DateTime?> lastUsedDate = const Value.absent()}) =>
      Workout(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdDate: createdDate ?? this.createdDate,
        lastUsedDate:
            lastUsedDate.present ? lastUsedDate.value : this.lastUsedDate,
      );
  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastUsedDate: $lastUsedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, createdDate, lastUsedDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.createdDate == this.createdDate &&
          other.lastUsedDate == this.lastUsedDate);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<DateTime> createdDate;
  final Value<DateTime?> lastUsedDate;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.lastUsedDate = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    this.createdDate = const Value.absent(),
    this.lastUsedDate = const Value.absent(),
  })  : name = Value(name),
        description = Value(description);
  static Insertable<Workout> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? createdDate,
    Expression<DateTime>? lastUsedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (createdDate != null) 'created_date': createdDate,
      if (lastUsedDate != null) 'last_used_date': lastUsedDate,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? description,
      Value<DateTime>? createdDate,
      Value<DateTime?>? lastUsedDate}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdDate: createdDate ?? this.createdDate,
      lastUsedDate: lastUsedDate ?? this.lastUsedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (lastUsedDate.present) {
      map['last_used_date'] = Variable<DateTime>(lastUsedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('createdDate: $createdDate, ')
          ..write('lastUsedDate: $lastUsedDate')
          ..write(')'))
        .toString();
  }
}

class $GripsTable extends Grips with TableInfo<$GripsTable, Grip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _workoutMeta =
      const VerificationMeta('workout');
  @override
  late final GeneratedColumn<int> workout = GeneratedColumn<int>(
      'workout', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE CASCADE'));
  static const VerificationMeta _gripTypeMeta =
      const VerificationMeta('gripType');
  @override
  late final GeneratedColumn<int> gripType = GeneratedColumn<int>(
      'grip_type', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES grip_types (id) ON DELETE CASCADE'));
  static const VerificationMeta _edgeSizeMeta =
      const VerificationMeta('edgeSize');
  @override
  late final GeneratedColumn<int> edgeSize = GeneratedColumn<int>(
      'edge_size', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _setCountMeta =
      const VerificationMeta('setCount');
  @override
  late final GeneratedColumn<int> setCount = GeneratedColumn<int>(
      'set_count', aliasedName, false,
      check: () => setCount.isBetweenValues(1, 30),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _repCountMeta =
      const VerificationMeta('repCount');
  @override
  late final GeneratedColumn<int> repCount = GeneratedColumn<int>(
      'rep_count', aliasedName, false,
      check: () => repCount.isBetweenValues(1, 30),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _workSecondsMeta =
      const VerificationMeta('workSeconds');
  @override
  late final GeneratedColumn<int> workSeconds = GeneratedColumn<int>(
      'work_seconds', aliasedName, false,
      check: () => workSeconds.isBetweenValues(1, 60),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _restSecondsMeta =
      const VerificationMeta('restSeconds');
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
      'rest_seconds', aliasedName, false,
      check: () => restSeconds.isBetweenValues(1, 60),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _breakMinutesMeta =
      const VerificationMeta('breakMinutes');
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
      'break_minutes', aliasedName, false,
      check: () => breakMinutes.isBetweenValues(0, 30),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _breakSecondsMeta =
      const VerificationMeta('breakSeconds');
  @override
  late final GeneratedColumn<int> breakSeconds = GeneratedColumn<int>(
      'break_seconds', aliasedName, false,
      check: () => breakSeconds.isBetweenValues(0, 60),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _lastBreakMinutesMeta =
      const VerificationMeta('lastBreakMinutes');
  @override
  late final GeneratedColumn<int> lastBreakMinutes = GeneratedColumn<int>(
      'last_break_minutes', aliasedName, false,
      check: () => lastBreakMinutes.isBetweenValues(0, 30),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _lastBreakSecondsMeta =
      const VerificationMeta('lastBreakSeconds');
  @override
  late final GeneratedColumn<int> lastBreakSeconds = GeneratedColumn<int>(
      'last_break_seconds', aliasedName, false,
      check: () => lastBreakSeconds.isBetweenValues(0, 60),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _sequenceNumMeta =
      const VerificationMeta('sequenceNum');
  @override
  late final GeneratedColumn<int> sequenceNum = GeneratedColumn<int>(
      'sequence_num', aliasedName, false,
      check: () => sequenceNum.isBiggerOrEqualValue(0),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        workout,
        gripType,
        edgeSize,
        setCount,
        repCount,
        workSeconds,
        restSeconds,
        breakMinutes,
        breakSeconds,
        lastBreakMinutes,
        lastBreakSeconds,
        sequenceNum
      ];
  @override
  String get aliasedName => _alias ?? 'grips';
  @override
  String get actualTableName => 'grips';
  @override
  VerificationContext validateIntegrity(Insertable<Grip> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout')) {
      context.handle(_workoutMeta,
          workout.isAcceptableOrUnknown(data['workout']!, _workoutMeta));
    } else if (isInserting) {
      context.missing(_workoutMeta);
    }
    if (data.containsKey('grip_type')) {
      context.handle(_gripTypeMeta,
          gripType.isAcceptableOrUnknown(data['grip_type']!, _gripTypeMeta));
    } else if (isInserting) {
      context.missing(_gripTypeMeta);
    }
    if (data.containsKey('edge_size')) {
      context.handle(_edgeSizeMeta,
          edgeSize.isAcceptableOrUnknown(data['edge_size']!, _edgeSizeMeta));
    }
    if (data.containsKey('set_count')) {
      context.handle(_setCountMeta,
          setCount.isAcceptableOrUnknown(data['set_count']!, _setCountMeta));
    } else if (isInserting) {
      context.missing(_setCountMeta);
    }
    if (data.containsKey('rep_count')) {
      context.handle(_repCountMeta,
          repCount.isAcceptableOrUnknown(data['rep_count']!, _repCountMeta));
    } else if (isInserting) {
      context.missing(_repCountMeta);
    }
    if (data.containsKey('work_seconds')) {
      context.handle(
          _workSecondsMeta,
          workSeconds.isAcceptableOrUnknown(
              data['work_seconds']!, _workSecondsMeta));
    } else if (isInserting) {
      context.missing(_workSecondsMeta);
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
          _restSecondsMeta,
          restSeconds.isAcceptableOrUnknown(
              data['rest_seconds']!, _restSecondsMeta));
    } else if (isInserting) {
      context.missing(_restSecondsMeta);
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
          _breakMinutesMeta,
          breakMinutes.isAcceptableOrUnknown(
              data['break_minutes']!, _breakMinutesMeta));
    } else if (isInserting) {
      context.missing(_breakMinutesMeta);
    }
    if (data.containsKey('break_seconds')) {
      context.handle(
          _breakSecondsMeta,
          breakSeconds.isAcceptableOrUnknown(
              data['break_seconds']!, _breakSecondsMeta));
    } else if (isInserting) {
      context.missing(_breakSecondsMeta);
    }
    if (data.containsKey('last_break_minutes')) {
      context.handle(
          _lastBreakMinutesMeta,
          lastBreakMinutes.isAcceptableOrUnknown(
              data['last_break_minutes']!, _lastBreakMinutesMeta));
    } else if (isInserting) {
      context.missing(_lastBreakMinutesMeta);
    }
    if (data.containsKey('last_break_seconds')) {
      context.handle(
          _lastBreakSecondsMeta,
          lastBreakSeconds.isAcceptableOrUnknown(
              data['last_break_seconds']!, _lastBreakSecondsMeta));
    } else if (isInserting) {
      context.missing(_lastBreakSecondsMeta);
    }
    if (data.containsKey('sequence_num')) {
      context.handle(
          _sequenceNumMeta,
          sequenceNum.isAcceptableOrUnknown(
              data['sequence_num']!, _sequenceNumMeta));
    } else if (isInserting) {
      context.missing(_sequenceNumMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Grip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Grip(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      workout: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}workout'])!,
      gripType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grip_type'])!,
      edgeSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}edge_size']),
      setCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}set_count'])!,
      repCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rep_count'])!,
      workSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}work_seconds'])!,
      restSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_seconds'])!,
      breakMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}break_minutes'])!,
      breakSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}break_seconds'])!,
      lastBreakMinutes: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_break_minutes'])!,
      lastBreakSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_break_seconds'])!,
      sequenceNum: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sequence_num'])!,
    );
  }

  @override
  $GripsTable createAlias(String alias) {
    return $GripsTable(attachedDatabase, alias);
  }
}

class Grip extends DataClass implements Insertable<Grip> {
  final int id;
  final int workout;
  final int gripType;
  final int? edgeSize;
  final int setCount;
  final int repCount;
  final int workSeconds;
  final int restSeconds;
  final int breakMinutes;
  final int breakSeconds;

  /// The break minutes that occur after this grip is complete
  final int lastBreakMinutes;

  /// The break seconds that occur after this grip is complete
  final int lastBreakSeconds;
  final int sequenceNum;
  const Grip(
      {required this.id,
      required this.workout,
      required this.gripType,
      this.edgeSize,
      required this.setCount,
      required this.repCount,
      required this.workSeconds,
      required this.restSeconds,
      required this.breakMinutes,
      required this.breakSeconds,
      required this.lastBreakMinutes,
      required this.lastBreakSeconds,
      required this.sequenceNum});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout'] = Variable<int>(workout);
    map['grip_type'] = Variable<int>(gripType);
    if (!nullToAbsent || edgeSize != null) {
      map['edge_size'] = Variable<int>(edgeSize);
    }
    map['set_count'] = Variable<int>(setCount);
    map['rep_count'] = Variable<int>(repCount);
    map['work_seconds'] = Variable<int>(workSeconds);
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['break_seconds'] = Variable<int>(breakSeconds);
    map['last_break_minutes'] = Variable<int>(lastBreakMinutes);
    map['last_break_seconds'] = Variable<int>(lastBreakSeconds);
    map['sequence_num'] = Variable<int>(sequenceNum);
    return map;
  }

  GripsCompanion toCompanion(bool nullToAbsent) {
    return GripsCompanion(
      id: Value(id),
      workout: Value(workout),
      gripType: Value(gripType),
      edgeSize: edgeSize == null && nullToAbsent
          ? const Value.absent()
          : Value(edgeSize),
      setCount: Value(setCount),
      repCount: Value(repCount),
      workSeconds: Value(workSeconds),
      restSeconds: Value(restSeconds),
      breakMinutes: Value(breakMinutes),
      breakSeconds: Value(breakSeconds),
      lastBreakMinutes: Value(lastBreakMinutes),
      lastBreakSeconds: Value(lastBreakSeconds),
      sequenceNum: Value(sequenceNum),
    );
  }

  factory Grip.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Grip(
      id: serializer.fromJson<int>(json['id']),
      workout: serializer.fromJson<int>(json['workout']),
      gripType: serializer.fromJson<int>(json['gripType']),
      edgeSize: serializer.fromJson<int?>(json['edgeSize']),
      setCount: serializer.fromJson<int>(json['setCount']),
      repCount: serializer.fromJson<int>(json['repCount']),
      workSeconds: serializer.fromJson<int>(json['workSeconds']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      breakSeconds: serializer.fromJson<int>(json['breakSeconds']),
      lastBreakMinutes: serializer.fromJson<int>(json['lastBreakMinutes']),
      lastBreakSeconds: serializer.fromJson<int>(json['lastBreakSeconds']),
      sequenceNum: serializer.fromJson<int>(json['sequenceNum']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workout': serializer.toJson<int>(workout),
      'gripType': serializer.toJson<int>(gripType),
      'edgeSize': serializer.toJson<int?>(edgeSize),
      'setCount': serializer.toJson<int>(setCount),
      'repCount': serializer.toJson<int>(repCount),
      'workSeconds': serializer.toJson<int>(workSeconds),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'breakSeconds': serializer.toJson<int>(breakSeconds),
      'lastBreakMinutes': serializer.toJson<int>(lastBreakMinutes),
      'lastBreakSeconds': serializer.toJson<int>(lastBreakSeconds),
      'sequenceNum': serializer.toJson<int>(sequenceNum),
    };
  }

  Grip copyWith(
          {int? id,
          int? workout,
          int? gripType,
          Value<int?> edgeSize = const Value.absent(),
          int? setCount,
          int? repCount,
          int? workSeconds,
          int? restSeconds,
          int? breakMinutes,
          int? breakSeconds,
          int? lastBreakMinutes,
          int? lastBreakSeconds,
          int? sequenceNum}) =>
      Grip(
        id: id ?? this.id,
        workout: workout ?? this.workout,
        gripType: gripType ?? this.gripType,
        edgeSize: edgeSize.present ? edgeSize.value : this.edgeSize,
        setCount: setCount ?? this.setCount,
        repCount: repCount ?? this.repCount,
        workSeconds: workSeconds ?? this.workSeconds,
        restSeconds: restSeconds ?? this.restSeconds,
        breakMinutes: breakMinutes ?? this.breakMinutes,
        breakSeconds: breakSeconds ?? this.breakSeconds,
        lastBreakMinutes: lastBreakMinutes ?? this.lastBreakMinutes,
        lastBreakSeconds: lastBreakSeconds ?? this.lastBreakSeconds,
        sequenceNum: sequenceNum ?? this.sequenceNum,
      );
  @override
  String toString() {
    return (StringBuffer('Grip(')
          ..write('id: $id, ')
          ..write('workout: $workout, ')
          ..write('gripType: $gripType, ')
          ..write('edgeSize: $edgeSize, ')
          ..write('setCount: $setCount, ')
          ..write('repCount: $repCount, ')
          ..write('workSeconds: $workSeconds, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('breakSeconds: $breakSeconds, ')
          ..write('lastBreakMinutes: $lastBreakMinutes, ')
          ..write('lastBreakSeconds: $lastBreakSeconds, ')
          ..write('sequenceNum: $sequenceNum')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      workout,
      gripType,
      edgeSize,
      setCount,
      repCount,
      workSeconds,
      restSeconds,
      breakMinutes,
      breakSeconds,
      lastBreakMinutes,
      lastBreakSeconds,
      sequenceNum);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Grip &&
          other.id == this.id &&
          other.workout == this.workout &&
          other.gripType == this.gripType &&
          other.edgeSize == this.edgeSize &&
          other.setCount == this.setCount &&
          other.repCount == this.repCount &&
          other.workSeconds == this.workSeconds &&
          other.restSeconds == this.restSeconds &&
          other.breakMinutes == this.breakMinutes &&
          other.breakSeconds == this.breakSeconds &&
          other.lastBreakMinutes == this.lastBreakMinutes &&
          other.lastBreakSeconds == this.lastBreakSeconds &&
          other.sequenceNum == this.sequenceNum);
}

class GripsCompanion extends UpdateCompanion<Grip> {
  final Value<int> id;
  final Value<int> workout;
  final Value<int> gripType;
  final Value<int?> edgeSize;
  final Value<int> setCount;
  final Value<int> repCount;
  final Value<int> workSeconds;
  final Value<int> restSeconds;
  final Value<int> breakMinutes;
  final Value<int> breakSeconds;
  final Value<int> lastBreakMinutes;
  final Value<int> lastBreakSeconds;
  final Value<int> sequenceNum;
  const GripsCompanion({
    this.id = const Value.absent(),
    this.workout = const Value.absent(),
    this.gripType = const Value.absent(),
    this.edgeSize = const Value.absent(),
    this.setCount = const Value.absent(),
    this.repCount = const Value.absent(),
    this.workSeconds = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.breakSeconds = const Value.absent(),
    this.lastBreakMinutes = const Value.absent(),
    this.lastBreakSeconds = const Value.absent(),
    this.sequenceNum = const Value.absent(),
  });
  GripsCompanion.insert({
    this.id = const Value.absent(),
    required int workout,
    required int gripType,
    this.edgeSize = const Value.absent(),
    required int setCount,
    required int repCount,
    required int workSeconds,
    required int restSeconds,
    required int breakMinutes,
    required int breakSeconds,
    required int lastBreakMinutes,
    required int lastBreakSeconds,
    required int sequenceNum,
  })  : workout = Value(workout),
        gripType = Value(gripType),
        setCount = Value(setCount),
        repCount = Value(repCount),
        workSeconds = Value(workSeconds),
        restSeconds = Value(restSeconds),
        breakMinutes = Value(breakMinutes),
        breakSeconds = Value(breakSeconds),
        lastBreakMinutes = Value(lastBreakMinutes),
        lastBreakSeconds = Value(lastBreakSeconds),
        sequenceNum = Value(sequenceNum);
  static Insertable<Grip> custom({
    Expression<int>? id,
    Expression<int>? workout,
    Expression<int>? gripType,
    Expression<int>? edgeSize,
    Expression<int>? setCount,
    Expression<int>? repCount,
    Expression<int>? workSeconds,
    Expression<int>? restSeconds,
    Expression<int>? breakMinutes,
    Expression<int>? breakSeconds,
    Expression<int>? lastBreakMinutes,
    Expression<int>? lastBreakSeconds,
    Expression<int>? sequenceNum,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workout != null) 'workout': workout,
      if (gripType != null) 'grip_type': gripType,
      if (edgeSize != null) 'edge_size': edgeSize,
      if (setCount != null) 'set_count': setCount,
      if (repCount != null) 'rep_count': repCount,
      if (workSeconds != null) 'work_seconds': workSeconds,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (breakSeconds != null) 'break_seconds': breakSeconds,
      if (lastBreakMinutes != null) 'last_break_minutes': lastBreakMinutes,
      if (lastBreakSeconds != null) 'last_break_seconds': lastBreakSeconds,
      if (sequenceNum != null) 'sequence_num': sequenceNum,
    });
  }

  GripsCompanion copyWith(
      {Value<int>? id,
      Value<int>? workout,
      Value<int>? gripType,
      Value<int?>? edgeSize,
      Value<int>? setCount,
      Value<int>? repCount,
      Value<int>? workSeconds,
      Value<int>? restSeconds,
      Value<int>? breakMinutes,
      Value<int>? breakSeconds,
      Value<int>? lastBreakMinutes,
      Value<int>? lastBreakSeconds,
      Value<int>? sequenceNum}) {
    return GripsCompanion(
      id: id ?? this.id,
      workout: workout ?? this.workout,
      gripType: gripType ?? this.gripType,
      edgeSize: edgeSize ?? this.edgeSize,
      setCount: setCount ?? this.setCount,
      repCount: repCount ?? this.repCount,
      workSeconds: workSeconds ?? this.workSeconds,
      restSeconds: restSeconds ?? this.restSeconds,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      breakSeconds: breakSeconds ?? this.breakSeconds,
      lastBreakMinutes: lastBreakMinutes ?? this.lastBreakMinutes,
      lastBreakSeconds: lastBreakSeconds ?? this.lastBreakSeconds,
      sequenceNum: sequenceNum ?? this.sequenceNum,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workout.present) {
      map['workout'] = Variable<int>(workout.value);
    }
    if (gripType.present) {
      map['grip_type'] = Variable<int>(gripType.value);
    }
    if (edgeSize.present) {
      map['edge_size'] = Variable<int>(edgeSize.value);
    }
    if (setCount.present) {
      map['set_count'] = Variable<int>(setCount.value);
    }
    if (repCount.present) {
      map['rep_count'] = Variable<int>(repCount.value);
    }
    if (workSeconds.present) {
      map['work_seconds'] = Variable<int>(workSeconds.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (breakSeconds.present) {
      map['break_seconds'] = Variable<int>(breakSeconds.value);
    }
    if (lastBreakMinutes.present) {
      map['last_break_minutes'] = Variable<int>(lastBreakMinutes.value);
    }
    if (lastBreakSeconds.present) {
      map['last_break_seconds'] = Variable<int>(lastBreakSeconds.value);
    }
    if (sequenceNum.present) {
      map['sequence_num'] = Variable<int>(sequenceNum.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GripsCompanion(')
          ..write('id: $id, ')
          ..write('workout: $workout, ')
          ..write('gripType: $gripType, ')
          ..write('edgeSize: $edgeSize, ')
          ..write('setCount: $setCount, ')
          ..write('repCount: $repCount, ')
          ..write('workSeconds: $workSeconds, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('breakSeconds: $breakSeconds, ')
          ..write('lastBreakMinutes: $lastBreakMinutes, ')
          ..write('lastBreakSeconds: $lastBreakSeconds, ')
          ..write('sequenceNum: $sequenceNum')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $GripTypesTable gripTypes = $GripTypesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $GripsTable grips = $GripsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [gripTypes, workouts, grips];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('workouts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('grips', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('grip_types',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('grips', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
