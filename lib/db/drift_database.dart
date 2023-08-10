// ignore_for_file: recursive_getters

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/grip_dto.dart';
import '../models/workout_dto.dart';

part 'drift_database.g.dart';

/// A particular type of grip that is used during a workout
class GripTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
}

/// A grip that is performed for a certain number of reps and sets, and with a
/// specific duration for work, rest, and break times. Each grip is associated
/// with one workout.
class Grips extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get workout =>
      integer().references(Workouts, #id, onDelete: KeyAction.cascade)();
  IntColumn get gripType =>
      integer().references(GripTypes, #id, onDelete: KeyAction.cascade)();
  IntColumn get edgeSize => integer().nullable()();
  IntColumn get setCount => integer().check(setCount.isBetweenValues(1, 30))();
  IntColumn get repCount => integer().check(repCount.isBetweenValues(1, 30))();
  IntColumn get workSeconds =>
      integer().check(workSeconds.isBetweenValues(1, 60))();
  IntColumn get restSeconds =>
      integer().check(restSeconds.isBetweenValues(1, 60))();
  IntColumn get breakMinutes =>
      integer().check(breakMinutes.isBetweenValues(0, 30))();
  IntColumn get breakSeconds =>
      integer().check(breakSeconds.isBetweenValues(0, 60))();

  /// The break minutes that occur after this grip is complete
  IntColumn get lastBreakMinutes =>
      integer().check(lastBreakMinutes.isBetweenValues(0, 30))();

  /// The break seconds that occur after this grip is complete
  IntColumn get lastBreakSeconds =>
      integer().check(lastBreakSeconds.isBetweenValues(0, 60))();
  IntColumn get sequenceNum =>
      integer().check(sequenceNum.isBiggerOrEqualValue(0))();
}

/// A workout that has a name, description, a creation date, and a date on which
/// the workout was last used
class Workouts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 40)();
  TextColumn get description => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdDate =>
      dateTime().withDefault(Constant(DateTime.now()))();
  DateTimeColumn get lastUsedDate =>
      dateTime().nullable()(); // Current timestamp
}

/// A grip with a grip type
class GripWithGripType {
  final Grip entry;
  final GripType gripType;

  GripWithGripType(this.entry, this.gripType);
}

/// A grip type with the count of grips that use the grip type
class GripTypeWithGripCount {
  final GripType entry;

  /// The number of grips this grip type is associated with
  final int? gripCount;

  GripTypeWithGripCount(this.entry, this.gripCount);

  @override
  String toString() {
    return '${entry.toString()} gripCount: $gripCount';
  }
}

/// The Drift database object for the app
@DriftDatabase(tables: [GripTypes, Grips, Workouts])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
        // Add a handful of initial grip types so user doesn't need to add many
        onCreate: (Migrator m) async {
      await m.createAll();

      // 11 initial grip types
      await addGripType('Full Crimp');
      await addGripType('Half Crimp');
      await addGripType('Open Hand Crimp');
      await addGripType('Pocket 2-Finger IM');
      await addGripType('Pocket 2-Finger MR');
      await addGripType('Pocket Index Finger');
      await addGripType('Pocket Middle Finger');
      await addGripType('Pocket Pinky Finger');
      await addGripType('Pocket Ring Finger');
      await addGripType('Three Finger Drag');
      await addGripType('Warm Up Jug');
    },
        // Must manually enable foreign key constraints for SQLite db
        beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    });
  }

  /// Returns a stream of workouts any time the workouts table is changed
  Stream<List<Workout>> watchAllWorkouts() =>
      (select(workouts)..orderBy([(w) => OrderingTerm.asc(w.name)])).watch();

  /// Returns a stream of all grip types sorted by grip name in ascending order
  Stream<List<GripType>> watchAllGripTypes() =>
      (select(gripTypes)..orderBy([(g) => OrderingTerm.asc(g.name)])).watch();

  /// Returns a stream of grips for a given workout ID
  Stream<List<Grip>> watchGripsForWorkout(int workoutID) => (select(grips)
        ..where((g) => g.workout.equals(workoutID))
        ..orderBy([(g) => OrderingTerm.asc(g.sequenceNum)]))
      .watch();

  /// Returns a stream of grips with grip type included
  Stream<List<GripWithGripType>> watchAllGripsWithType(int workoutID) {
    final query = select(grips).join(
        [leftOuterJoin(gripTypes, gripTypes.id.equalsExp(grips.gripType))])
      ..where(grips.workout.equals(workoutID))
      ..orderBy([OrderingTerm.asc(grips.sequenceNum)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return GripWithGripType(row.readTable(grips), row.readTable(gripTypes));
      }).toList();
    });
  }

  /// Returns a Future to a List of all the Grips for a given workout ordered by
  /// the sequene number of each Grip
  Future<List<GripWithGripType>> fetchAllGripsWithType(int workoutID) {
    final query = select(grips).join(
        [leftOuterJoin(gripTypes, gripTypes.id.equalsExp(grips.gripType))])
      ..where(grips.workout.equals(workoutID))
      ..orderBy([OrderingTerm.asc(grips.sequenceNum)]);

    return query
        .map((row) =>
            GripWithGripType(row.readTable(grips), row.readTable(gripTypes)))
        .get();
  }

  /// Returns a stream of grip types with a count of the number of grips that
  /// grip type is used by
  Stream<List<GripTypeWithGripCount>> watchAllGripTypesWithCount() {
    final gripCounts = grips.id.count();

    final query = select(gripTypes).join([
      leftOuterJoin(grips, grips.gripType.equalsExp(gripTypes.id),
          useColumns: false)
    ])
      ..orderBy([OrderingTerm.asc(gripTypes.name)]);

    query
      ..addColumns([gripCounts])
      ..groupBy([gripTypes.id]);

    return query.map((row) {
      return GripTypeWithGripCount(
          row.readTable(gripTypes), row.read(gripCounts));
    }).watch();
  }

  /// Creates a new workout
  Future<int> addWorkout(WorkoutDTO workoutDTO) {
    return into(workouts).insert(WorkoutsCompanion.insert(
        name: workoutDTO.name!, description: workoutDTO.description!));
  }

  /// Creates a new grip
  Future<int> addGrip(int workoutID, GripDTO gripDTO) async {
    // Get the maximum sequence number for all grips in the curent workout
    int maxSeqNum = await getMaxGripSeqNum(workoutID);

    return into(grips).insert(GripsCompanion.insert(
        workout: workoutID,
        gripType: gripDTO.gripTypeID!,
        edgeSize: Value(gripDTO.edgeSize),
        setCount: gripDTO.sets,
        repCount: gripDTO.reps,
        workSeconds: gripDTO.workSeconds,
        restSeconds: gripDTO.restSeconds,
        breakMinutes: gripDTO.breakMinutes,
        breakSeconds: gripDTO.breakSeconds,
        lastBreakMinutes: gripDTO.lastBreakMinutes,
        lastBreakSeconds: gripDTO.lastBreakSeconds,
        sequenceNum: maxSeqNum + 1)); // Add 1 so new grip has largest seq num
  }

  /// Creates duplicate of the given grip. The duplicate grip will have the
  /// largest sequence number so that it is placed after all other grips in the
  /// workout.
  Future<int> addDuplicateGrip(Grip grip) async {
    int maxSeqNum = await getMaxGripSeqNum(grip.workout);

    return into(grips).insert(GripsCompanion.insert(
        workout: grip.workout,
        gripType: grip.gripType,
        edgeSize: Value(grip.edgeSize),
        setCount: grip.setCount,
        repCount: grip.repCount,
        workSeconds: grip.workSeconds,
        restSeconds: grip.restSeconds,
        breakMinutes: grip.breakMinutes,
        breakSeconds: grip.breakSeconds,
        lastBreakMinutes: grip.lastBreakMinutes,
        lastBreakSeconds: grip.lastBreakSeconds,
        sequenceNum: maxSeqNum + 1));
  }

  /// Returns the largest sequence number among all grips in a given workout. If
  /// there are no grips created yet then zero is returned.
  Future<int> getMaxGripSeqNum(int workoutID) async {
    final maxSeqNum = grips.sequenceNum.max();
    final query = selectOnly(grips)..addColumns([maxSeqNum]);
    int? result = await query.map((row) => row.read(maxSeqNum)).getSingle();
    return result ?? 0;
  }

  /// Creates a new grip type
  Future<int> addGripType(String name) {
    return into(gripTypes).insert(GripTypesCompanion.insert(name: name));
  }

  /// Edits the workout with the given id using the given name and description
  Future<int> updateWorkout(int workoutID, String name, String description) {
    return (update(workouts)..where((w) => w.id.equals(workoutID))).write(
        WorkoutsCompanion(name: Value(name), description: Value(description)));
  }

  /// Updates the last used date for the given workout
  Future<int> updateWorkoutLastUsed(int workoutID, DateTime newDate) {
    return (update(workouts)..where((w) => w.id.equals(workoutID)))
        .write(WorkoutsCompanion(lastUsedDate: Value(newDate)));
  }

  /// Updates the sequence number for a given grip
  Future<int> updateGripSeqNum(int gripID, int newSeqNum) {
    return (update(grips)..where((g) => g.id.equals(gripID)))
        .write(GripsCompanion(sequenceNum: Value(newSeqNum)));
  }

  /// Updates the grip type for the given grip
  Future<int> updateGripType(int gripID, int newGripTypeID) {
    return (update(grips)..where((g) => g.id.equals(gripID)))
        .write(GripsCompanion(gripType: Value(newGripTypeID)));
  }

  /// Updates the grip with the given gripID using the given GripDTO
  Future<int> updateGrip(int gripID, GripDTO gripDTO) {
    return (update(grips)..where((g) => g.id.equals(gripID)))
        .write(GripsCompanion(
      gripType: Value(gripDTO.gripTypeID!),
      edgeSize: Value(gripDTO.edgeSize),
      setCount: Value(gripDTO.sets),
      repCount: Value(gripDTO.reps),
      workSeconds: Value(gripDTO.workSeconds),
      restSeconds: Value(gripDTO.restSeconds),
      breakMinutes: Value(gripDTO.breakMinutes),
      breakSeconds: Value(gripDTO.breakSeconds),
      lastBreakMinutes: Value(gripDTO.lastBreakMinutes),
      lastBreakSeconds: Value(gripDTO.lastBreakSeconds),
    ));
  }

  /// Updates the sequence number for any grips in the given list that have
  /// been reordered. Uses a single transaction to improve performance when
  /// many grips must be updated.
  Future<void> updateMultipleGripSeqNum(List<GripWithGripType> gripsList) {
    return transaction(() async {
      for (int index = 0; index < gripsList.length; index++) {
        if (gripsList[index].entry.sequenceNum != index) {
          await (update(grips)
                ..where((g) => g.id.equals(gripsList[index].entry.id)))
              .write(GripsCompanion(sequenceNum: Value(index)));
        }
      }
    });
  }

  /// Deletes the given workout
  Future<int> deleteWorkout(Workout workout) =>
      delete(workouts).delete(workout);

  /// Delete the given grip type
  Future<int> deleteGripType(GripType gripType) =>
      delete(gripTypes).delete(gripType);

  /// Delete the given grip
  Future<int> deleteGrip(Grip grip) => delete(grips).delete(grip);
}

/// Returns a connection to the native SQLite database
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
