import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

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
  IntColumn get workout => integer().references(Workouts, #id)();
  IntColumn get gripType => integer().references(GripTypes, #id)();
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

/// The Drift database object for the app
@DriftDatabase(tables: [GripTypes, Grips, Workouts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Returns a stream of workouts any time the workouts table is changed
  Stream<List<Workout>> watchAllWorkouts() => select(workouts).watch();

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

  /// Creates a new workout
  Future<int> addWorkout(WorkoutsCompanion entry) {
    return into(workouts).insert(entry);
  }

  /// Creates a new grip
  Future<int> addGrip(GripsCompanion entry) {
    return into(grips).insert(entry);
  }

  /// Creates a new grip type
  Future<int> addGripType(GripTypesCompanion entry) {
    return into(gripTypes).insert(entry);
  }

  /// Edits the workout with the given id using the given name and description
  Future<int> updateWorkout(int workoutID, String name, String description) {
    return (update(workouts)..where((w) => w.id.equals(workoutID))).write(
        WorkoutsCompanion(name: Value(name), description: Value(description)));
  }

  /// Updates the sequence number for a given grip
  Future<int> updateGripSeqNum(int gripID, int newSeqNum) {
    return (update(grips)..where((g) => g.id.equals(gripID)))
        .write(GripsCompanion(sequenceNum: Value(newSeqNum)));
  }

  /// Updates the sequence number for any grips in the given list that have
  /// been reordered. Uses a single transaction to improve performance when
  /// many grips must be updated.
  Future<void> updateMultipleGripSeqNum(
      List<GripWithGripType> gripsList) {
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
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
