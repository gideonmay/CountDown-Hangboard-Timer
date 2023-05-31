import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/models/grip_dto.dart';
import 'package:countdown_app/models/workout_dto.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  group('Workouts table', () {
    test('Workout is created with correct values', () async {
      final workoutDTO =
          WorkoutDTO(name: 'Test Workout', description: 'Test description');
      await db.addWorkout(workoutDTO);
      final workouts = await db.watchAllWorkouts().first;

      expect(workouts[0].name, workoutDTO.name);
      expect(workouts[0].description, workoutDTO.description);
    });

    test('Workout is correctly deleted', () async {
      // Create new workout
      final workoutDTO =
          WorkoutDTO(name: 'Test Workout', description: 'Test description');
      await db.addWorkout(workoutDTO);
      List<Workout> workouts = await db.watchAllWorkouts().first;

      // Delete the created workout
      await db.deleteWorkout(workouts[0]);
      workouts = await db.watchAllWorkouts().first;

      expect(workouts.length, 0);
    });
  });

  group('GripTypes', () {
    test('GripType is created with correct values', () async {
      await db.addGripType('Half Crimp');
      final gripTypes = await db.watchAllGripTypes().first;

      expect(gripTypes[0].name, 'Half Crimp');
    });

    test('GripType is correctly deleted', () async {
      // Create a new grip type
      await db.addGripType('Half Crimp');
      List<GripType> gripTypes = await db.watchAllGripTypes().first;

      // Delete the created grip type
      await db.deleteGripType(gripTypes[0]);
      gripTypes = await db.watchAllGripTypes().first;

      expect(gripTypes.length, 0);
    });
  });

  group('GripTypes with Grip counts', () {
    late int gripTypeID;
    late int workoutID;

    setUp(() async {
      // Create a grip type and workout to be used to create test grips
      gripTypeID = await db.addGripType('Open Hand Crimp');
      final workoutDTO =
          WorkoutDTO(name: 'Test Workout', description: 'Test description');
      workoutID = await db.addWorkout(workoutDTO);
    });

    test('A grip type used with no grips returns a count of zero', () async {
      final gripTypes = await db.watchAllGripTypesWithCount().first;

      expect(gripTypes[0].gripCount, 0);
    });

    test('A grip type used with one grip returns the correct count', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO);
      final gripTypes = await db.watchAllGripTypesWithCount().first;

      expect(gripTypes[0].gripCount, 1);
    });

    test('A grip type used with two grips returns the correct count', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO); // 1st grip
      await db.addGrip(workoutID, gripDTO); // 2nd grip
      final gripTypes = await db.watchAllGripTypesWithCount().first;

      expect(gripTypes[0].gripCount, 2);
    });
  });

  // group('Grips table', () {
  //   late final int workoutID;

  //   setUp(() async {
  //     final workoutDTO =
  //         WorkoutDTO(name: 'Test Workout', description: 'Test description');
  //     workoutID = await db.addWorkout(workoutDTO);
  //   });

  //   test('Grip is created with correct values', () async {
  //     final gripDTO = GripDTO(
  //         gripName: 'Test Grip', lastBreakMinutes: 1, lastBreakSeconds: 30);
  //     gripDTO.edgeSize = 16;
  //     gripDTO.

  //     await db.addGrip(workoutID, gripDTO);
  //     final grips = await db.watchAllGripsWithType(workoutID).first;
  //   });

  //   test('Max sequence number is correct when zero grips exist', () {});

  //   test('Max sequence number is correct when multiple grips exist', () {});
  // });
}
