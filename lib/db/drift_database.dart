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
/// specific duration for work, rest, and break times
class Grips extends Table {
  IntColumn get id => integer().autoIncrement()();
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

/// An intersection table that assignes a particular Grip to a Workout with a
/// sequence number that specifies the order of the Grip in that Workout
class WorkoutGrips extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get grip => integer().references(Grips, #id)();
  IntColumn get workout => integer().references(Workouts, #id)();
  IntColumn get sequenceNum =>
      integer().check(sequenceNum.isBiggerOrEqualValue(0))();
}

/// The Drift database object for the app
@DriftDatabase(tables: [GripTypes, Grips, Workouts, WorkoutGrips])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Returns a stream of workouts any time the workouts table is changed
  Stream<List<Workout>> watchAllWorkouts() => select(workouts).watch();

  /// Inserts a new workout in the database
  Future<int> addWorkout(WorkoutsCompanion entry) {
    return into(workouts).insert(entry);
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
