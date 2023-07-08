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

    test('Grips from a stream have correct sequence numbers', () async {
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

    test('Grips from a Future have correct sequence numbers', () async {
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO); // 1st grip
      await db.addGrip(workoutID, gripDTO); // 2nd grip
      await db.addGrip(workoutID, gripDTO); // 3rd grip

      List<GripWithGripType> grips =
          await db.fetchAllGripsWithType(workoutID);

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
      GripDTO gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      int addedGripID = await db.addGrip(workoutID, gripDTO);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      // Change all grip attributes
      gripDTO.edgeSize = 25;
      gripDTO.sets = 10;
      gripDTO.reps = 8;
      gripDTO.workSeconds = 21;
      gripDTO.restSeconds = 22;
      gripDTO.breakMinutes = 3;
      gripDTO.breakSeconds = 4;
      gripDTO.lastBreakMinutes = 5;
      gripDTO.lastBreakSeconds = 6;

      await db.updateGrip(addedGripID, gripDTO);
      grips = await db.watchAllGripsWithType(workoutID).first;
      final grip = grips[0].entry;
      final gripType = grips[0].gripType;

      expect(grip.setCount, gripDTO.sets);
      expect(grip.repCount, gripDTO.reps);
      expect(grip.workSeconds, gripDTO.workSeconds);
      expect(grip.restSeconds, gripDTO.restSeconds);
      expect(grip.breakMinutes, gripDTO.breakMinutes);
      expect(grip.breakSeconds, gripDTO.breakSeconds);
      expect(grip.lastBreakMinutes, gripDTO.lastBreakMinutes);
      expect(grip.lastBreakSeconds, gripDTO.lastBreakSeconds);
      expect(grip.edgeSize, gripDTO.edgeSize);
      expect(grip.workout, workoutID);
      expect(grip.gripType, gripTypeID);
      expect(gripType.name, 'Open Hand Crimp');
    });

    test('Grip sequence number is correctly updated', () async {
      GripDTO gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      int addedGripID = await db.addGrip(workoutID, gripDTO);
      await db.updateGripSeqNum(addedGripID, 99);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      expect(grips[0].entry.sequenceNum, 99);
    });

    test('Grip type of a grip is correctly updated', () async {
      GripDTO gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      int addedGripID = await db.addGrip(workoutID, gripDTO);
      int newGripTypeID = await db.addGripType('Half Crimp');

      await db.updateGripType(addedGripID, newGripTypeID);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      expect(grips[0].entry.gripType, newGripTypeID);
    });

    test('A list of grips are updated with the correct seqNums', () async {
      // Create grips with distinct edge sizes of 10, 15, and 20
      GripDTO gripDTO = GripDTO.standard()
        ..gripTypeID = gripTypeID
        ..edgeSize = 10;
      await db.addGrip(workoutID, gripDTO); // 1st grip
      gripDTO.edgeSize = 15;
      await db.addGrip(workoutID, gripDTO); // 2nd grip
      gripDTO.edgeSize = 20;
      await db.addGrip(workoutID, gripDTO); // 3rd grip

      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      // Swap grips so new order in terms of grip edge sizes is [15, 20, 10]
      GripWithGripType grip = grips.removeAt(0);
      grips.insert(1, grip);
      grip = grips.removeAt(1);
      grips.insert(2, grip);
      await db.updateMultipleGripSeqNum(grips);
      grips = await db.watchAllGripsWithType(workoutID).first;

      expect(grips[0].entry.edgeSize, 15);
      expect(grips[1].entry.edgeSize, 20);
      expect(grips[2].entry.edgeSize, 10);
    });

    test('Grip is correctly duplicated', () async {
      // Add a new grip
      final gripDTO = GripDTO.standard()..gripTypeID = gripTypeID;
      await db.addGrip(workoutID, gripDTO);
      List<GripWithGripType> grips =
          await db.watchAllGripsWithType(workoutID).first;

      // Create a duplicate of the added grip
      final addedGrip = grips[0].entry;
      await db.addDuplicateGrip(addedGrip);

      grips = await db.watchAllGripsWithType(workoutID).first;
      final grip1 = grips[0].entry;
      final grip2 = grips[1].entry;

      expect(grip1.setCount, grip2.setCount);
      expect(grip1.repCount, grip2.repCount);
      expect(grip1.workSeconds, grip2.workSeconds);
      expect(grip1.restSeconds, grip2.restSeconds);
      expect(grip1.breakMinutes, grip2.breakMinutes);
      expect(grip1.breakSeconds, grip2.breakSeconds);
      expect(grip1.lastBreakMinutes, grip2.lastBreakMinutes);
      expect(grip1.lastBreakSeconds, grip2.lastBreakSeconds);
      expect(grip1.edgeSize, grip2.edgeSize);
      expect(grip1.sequenceNum, lessThan(grip2.sequenceNum));
      expect(grip1.workout, grip2.workout);
      expect(grip1.gripType, grip2.gripType);
    });
  });
}
