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

  group('GripTypes table', () {
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

  group('GripTypes with Grip counts query', () {
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

  group('Grips table', () {
    late int gripTypeID;
    late int workoutID;

    setUp(() async {
      // Create a grip type and workout to be used to create test grips
      gripTypeID = await db.addGripType('Open Hand Crimp');
      final workoutDTO =
          WorkoutDTO(name: 'Test Workout', description: 'Test description');
      workoutID = await db.addWorkout(workoutDTO);
    });

    test('Grip is created with correct values', () async {
      final gripDTO = GripDTO.standard()
        ..edgeSize = 16
        ..gripTypeID = gripTypeID;

      await db.addGrip(workoutID, gripDTO);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;
      final grip = grips[0].entry;
      final gripType = grips[0].gripType;

      expect(grip.setCount, 1);
      expect(grip.repCount, 1);
      expect(grip.workSeconds, 10);
      expect(grip.restSeconds, 5);
      expect(grip.breakMinutes, 0);
      expect(grip.breakSeconds, 30);
      expect(grip.lastBreakMinutes, 0);
      expect(grip.lastBreakSeconds, 30);
      expect(grip.edgeSize, 16);
      expect(grip.sequenceNum, 1);
      expect(grip.workout, workoutID);
      expect(grip.gripType, gripTypeID);
      expect(gripType.name, 'Open Hand Crimp');
    });

    test('Grip is correctly created with a null edge size', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;

      await db.addGrip(workoutID, gripDTO);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;
      final grip = grips[0].entry;

      expect(grip.edgeSize, null);
    });

    test('Grips have correct sequence numbers', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO); // 1st grip
      await db.addGrip(workoutID, gripDTO); // 2nd grip
      await db.addGrip(workoutID, gripDTO); // 3rd grip

      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      expect(grips[0].entry.sequenceNum, 1);
      expect(grips[1].entry.sequenceNum, 2);
      expect(grips[2].entry.sequenceNum, 3);
    });

    test('Max sequence number is correct when zero grips exist', () async {
      final maxSeqNum = await db.getMaxGripSeqNum(workoutID);
      expect(maxSeqNum, 0);
    });

    test('Max sequence number is correct when one grip exists', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO);
      final maxSeqNum = await db.getMaxGripSeqNum(workoutID);

      expect(maxSeqNum, 1);
    });

    test('Max sequence number is correct when two grips exist', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO); // 1st grip
      await db.addGrip(workoutID, gripDTO); // 2nd grip
      final maxSeqNum = await db.getMaxGripSeqNum(workoutID);

      expect(maxSeqNum, 2);
    });

    test('Grip is correctly deleted', () async {
      // Add a new grip
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      int addedGripID = await db.addGrip(workoutID, gripDTO);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      // Delete the grip that was added
      int deletedGripID = await db.deleteGrip(grips[0].entry);
      grips = await db.watchAllGripsWithType(workoutID).first;

      expect(deletedGripID, addedGripID);
      expect(grips.length, 0);
    });

    test('Grip is correctly updated', () async {
      // TODO: Add this functionality
    });

    test('Grip sequence number is correctly updated', () async {
      // TODO: Add this functionality
    });

    test('A list of grips are updated with the correct seqNums', () async {
      // TODO: Add this functionality
    });

    test('Grip is correctly duplicated', () async {
      // TODO: Add this functionality
    });
  });
}
