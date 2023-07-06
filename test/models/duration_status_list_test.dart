import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/duration_status_list.dart';
import 'package:countdown_app/db/drift_database.dart';

void main() {
  group('DurationStatusListDTO', () {
    test('All variables given as parameters are initialized properly', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 3,
          reps: 2,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);

      expect(durationsListDTO.sets, 3);
      expect(durationsListDTO.reps, 2);
      expect(durationsListDTO.workDuration, const Duration(seconds: 10));
      expect(durationsListDTO.restDuration, const Duration(seconds: 3));
      expect(durationsListDTO.breakDuration, const Duration(seconds: 30));
      expect(durationsListDTO.includePrepare, true);
    });

    test(
        'AssertionError thrown if includeLastBreak == true but lastBreakDuration not included',
        () {
      expect(
          () => DurationStatusListDTO(
              sets: 1,
              reps: 1,
              workDuration: const Duration(seconds: 10),
              restDuration: const Duration(seconds: 3),
              breakDuration: const Duration(seconds: 30),
              includePrepare: false,
              includeLastBreak: true),
          throwsAssertionError);
    });
  });
  group('TimerDurationStatusList', () {
    test('A list with 0 sets and 0 reps only has one element', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 0,
          reps: 0,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 1);
      expect(durationsList.totalSeconds, 0);
      expect(durationsList[0].toString(), '(complete for 0 sec)');
    });

    test('A list with 0 sets and 1 rep only has one element', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 0,
          reps: 1,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 1);
      expect(durationsList.totalSeconds, 0);
      expect(durationsList[0].toString(), '(complete for 0 sec)');
    });

    test('A list with 1 sets and 0 reps is only has one element', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 1,
          reps: 0,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 1);
      expect(durationsList.totalSeconds, 0);
      expect(durationsList[0].toString(), '(complete for 0 sec)');
    });

    test('A list with includePrepare == false does not start with a prepare',
        () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 1,
          reps: 1,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: false,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 2);
      expect(durationsList.totalSeconds, 10);
      expect(durationsList[0].toString(), '(work for 10 sec)');
      expect(durationsList[1].toString(), '(complete for 0 sec)');
    });

    test(
        'A list with includeLastBreak == true ends with the last break duration',
        () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 1,
          reps: 1,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: false,
          includeLastBreak: true,
          lastBreakDuration: const Duration(seconds: 35));
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 2);
      expect(durationsList.totalSeconds, 45);
      expect(durationsList[0].toString(), '(work for 10 sec)');
      expect(durationsList[1].toString(), '(break for 35 sec)');
    });

    test('A list with 1 sets and 1 reps contains 3 elements', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 1,
          reps: 1,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 3);
      expect(durationsList.totalSeconds, 25);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[1].toString(), '(work for 10 sec)');
      expect(durationsList[2].toString(), '(complete for 0 sec)');
    });

    test('A list with 1 sets and 2 reps contains the correct durations', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 1,
          reps: 2,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 38);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);

      expect(durationsList[1].toString(), '(work for 10 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);

      expect(durationsList[2].toString(), '(rest for 3 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 1);

      expect(durationsList[3].toString(), '(work for 10 sec)');
      expect(durationsList[3].currRep, 2);
      expect(durationsList[3].currSet, 1);

      expect(durationsList[4].toString(), '(complete for 0 sec)');
      expect(durationsList[4].currRep, 3);
      expect(durationsList[4].currSet, 2);
    });

    test('A list with 2 sets and 1 reps contains the correct durations', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 2,
          reps: 1,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 65);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);

      expect(durationsList[1].toString(), '(work for 10 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);

      expect(durationsList[2].toString(), '(break for 30 sec)');
      expect(durationsList[2].currRep, 1);
      expect(durationsList[2].currSet, 2);

      expect(durationsList[3].toString(), '(work for 10 sec)');
      expect(durationsList[3].currRep, 1);
      expect(durationsList[3].currSet, 2);

      expect(durationsList[4].toString(), '(complete for 0 sec)');
      expect(durationsList[4].currRep, 2);
      expect(durationsList[4].currSet, 3);
    });

    test('A list with 2 sets and 2 reps contains the correct durations', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 2,
          reps: 2,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 9);
      expect(durationsList.totalSeconds, 91);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);

      expect(durationsList[1].toString(), '(work for 10 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);

      expect(durationsList[2].toString(), '(rest for 3 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 1);

      expect(durationsList[3].toString(), '(work for 10 sec)');
      expect(durationsList[3].currRep, 2);
      expect(durationsList[3].currSet, 1);

      expect(durationsList[4].toString(), '(break for 30 sec)');
      expect(durationsList[4].currRep, 1);
      expect(durationsList[4].currSet, 2);

      expect(durationsList[5].toString(), '(work for 10 sec)');
      expect(durationsList[5].currRep, 1);
      expect(durationsList[5].currSet, 2);

      expect(durationsList[6].toString(), '(rest for 3 sec)');
      expect(durationsList[6].currRep, 2);
      expect(durationsList[6].currSet, 2);

      expect(durationsList[7].toString(), '(work for 10 sec)');
      expect(durationsList[7].currRep, 2);
      expect(durationsList[7].currSet, 2);

      expect(durationsList[8].toString(), '(complete for 0 sec)');
      expect(durationsList[8].currRep, 3);
      expect(durationsList[8].currSet, 3);
    });

    test(
        'A list with a gripName and nextGripName contains correct grips and durations',
        () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 1,
          reps: 2,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: true,
          lastBreakDuration: const Duration(seconds: 35),
          gripName: 'Half Crimp',
          nextGripName: 'Open Hand Crimp');
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 73);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Half Crimp');

      expect(durationsList[1].toString(), '(work for 10 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Half Crimp');
      expect(durationsList[1].nextGripName, 'Open Hand Crimp');

      expect(durationsList[2].toString(), '(rest for 3 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 1);
      expect(durationsList[2].gripName, 'Half Crimp');
      expect(durationsList[2].nextGripName, 'Open Hand Crimp');

      expect(durationsList[3].toString(), '(work for 10 sec)');
      expect(durationsList[3].currRep, 2);
      expect(durationsList[3].currSet, 1);
      expect(durationsList[3].gripName, 'Half Crimp');
      expect(durationsList[3].nextGripName, 'Open Hand Crimp');

      expect(durationsList[4].toString(), '(break for 35 sec)');
      expect(durationsList[4].currRep, 1);
      expect(durationsList[4].currSet, 1);
      expect(durationsList[4].gripName, 'Open Hand Crimp');
      expect(durationsList[4].nextGripName, null);
    });

    test('The correct startTime is present at each index in the list', () {
      final durationsListDTO = DurationStatusListDTO(
          sets: 2,
          reps: 1,
          workDuration: const Duration(seconds: 10),
          restDuration: const Duration(seconds: 3),
          breakDuration: const Duration(seconds: 30),
          includePrepare: true,
          includeLastBreak: false);
      final durationsList =
          TimerDurationStatusList(durationStatusListDTO: durationsListDTO);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 65);
      expect(durationsList[0].startTime, const Duration(seconds: 0));
      expect(durationsList[1].startTime, const Duration(seconds: 15));
      expect(durationsList[2].startTime, const Duration(seconds: 25));
      expect(durationsList[3].startTime, const Duration(seconds: 55));
      expect(durationsList[4].startTime, const Duration(seconds: 65));
    });
  });

  group('WorkoutDurationStatusList', () {
    const halfCrimpType = GripType(id: 1, name: 'Half Crimp');
    const warmUpJugType = GripType(id: 1, name: 'Warm Up Jug');

    // Various grips with different numbers or sets and reps
    const grip1Set1Rep = Grip(
        id: 1,
        workout: 1,
        gripType: 1,
        setCount: 1,
        repCount: 1,
        workSeconds: 7,
        restSeconds: 3,
        breakMinutes: 0,
        breakSeconds: 30,
        lastBreakMinutes: 0,
        lastBreakSeconds: 45,
        sequenceNum: 1);

    const grip1Set2Rep = Grip(
        id: 1,
        workout: 1,
        gripType: 1,
        setCount: 1,
        repCount: 2,
        workSeconds: 7,
        restSeconds: 3,
        breakMinutes: 0,
        breakSeconds: 30,
        lastBreakMinutes: 0,
        lastBreakSeconds: 45,
        sequenceNum: 1);

    const grip2Set1Rep = Grip(
        id: 1,
        workout: 1,
        gripType: 1,
        setCount: 2,
        repCount: 1,
        workSeconds: 7,
        restSeconds: 3,
        breakMinutes: 0,
        breakSeconds: 30,
        lastBreakMinutes: 0,
        lastBreakSeconds: 45,
        sequenceNum: 1);

    const grip2set2rep = Grip(
        id: 1,
        workout: 1,
        gripType: 1,
        setCount: 2,
        repCount: 2,
        workSeconds: 7,
        restSeconds: 3,
        breakMinutes: 0,
        breakSeconds: 30,
        lastBreakMinutes: 0,
        lastBreakSeconds: 45,
        sequenceNum: 1);
    test('A workout with one grip of 1 set and 1 rep is created correctly', () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip1Set1Rep, halfCrimpType)
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 3);
      expect(durationsList.totalSeconds, 22);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Half Crimp');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Half Crimp');
      expect(durationsList[1].nextGripName, null);
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(complete for 0 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 2);
      expect(durationsList[2].gripName, null);
      expect(durationsList[2].nextGripName, null);
      expect(durationsList[2].currGrip, 2);
    });

    test('A workout with one grip of 1 set and 2 reps is created correctly',
        () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip1Set2Rep, halfCrimpType)
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 32);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Half Crimp');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Half Crimp');
      expect(durationsList[1].nextGripName, null);
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(rest for 3 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 1);
      expect(durationsList[2].gripName, 'Half Crimp');
      expect(durationsList[2].nextGripName, null);
      expect(durationsList[2].currGrip, 1);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 2);
      expect(durationsList[3].currSet, 1);
      expect(durationsList[3].gripName, 'Half Crimp');
      expect(durationsList[3].nextGripName, null);
      expect(durationsList[3].currGrip, 1);

      expect(durationsList[4].toString(), '(complete for 0 sec)');
      expect(durationsList[4].currRep, 3);
      expect(durationsList[4].currSet, 2);
      expect(durationsList[4].gripName, null);
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 2);
    });

    test('A workout with one grip of 2 sets and 1 rep is created correctly',
        () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip2Set1Rep, halfCrimpType)
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 59);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Half Crimp');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Half Crimp');
      expect(durationsList[1].nextGripName, null);
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(break for 30 sec)');
      expect(durationsList[2].currRep, 1);
      expect(durationsList[2].currSet, 2);
      expect(durationsList[2].gripName, 'Half Crimp');
      expect(durationsList[2].nextGripName, null);
      expect(durationsList[2].currGrip, 1);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 1);
      expect(durationsList[3].currSet, 2);
      expect(durationsList[3].gripName, 'Half Crimp');
      expect(durationsList[3].nextGripName, null);
      expect(durationsList[3].currGrip, 1);

      expect(durationsList[4].toString(), '(complete for 0 sec)');
      expect(durationsList[4].currRep, 2);
      expect(durationsList[4].currSet, 3);
      expect(durationsList[4].gripName, null);
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 2);
    });

    test('A workout with one grip of 2 sets and 2 reps is created correctly',
        () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip2set2rep, halfCrimpType)
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 9);
      expect(durationsList.totalSeconds, 79);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Half Crimp');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Half Crimp');
      expect(durationsList[1].nextGripName, null);
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(rest for 3 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 1);
      expect(durationsList[2].gripName, 'Half Crimp');
      expect(durationsList[2].nextGripName, null);
      expect(durationsList[2].currGrip, 1);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 2);
      expect(durationsList[3].currSet, 1);
      expect(durationsList[3].gripName, 'Half Crimp');
      expect(durationsList[3].nextGripName, null);
      expect(durationsList[3].currGrip, 1);

      expect(durationsList[4].toString(), '(break for 30 sec)');
      expect(durationsList[4].currRep, 1);
      expect(durationsList[4].currSet, 2);
      expect(durationsList[4].gripName, 'Half Crimp');
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 1);

      expect(durationsList[5].toString(), '(work for 7 sec)');
      expect(durationsList[5].currRep, 1);
      expect(durationsList[5].currSet, 2);
      expect(durationsList[5].gripName, 'Half Crimp');
      expect(durationsList[5].nextGripName, null);
      expect(durationsList[5].currGrip, 1);

      expect(durationsList[6].toString(), '(rest for 3 sec)');
      expect(durationsList[6].currRep, 2);
      expect(durationsList[6].currSet, 2);
      expect(durationsList[6].gripName, 'Half Crimp');
      expect(durationsList[6].nextGripName, null);
      expect(durationsList[6].currGrip, 1);

      expect(durationsList[7].toString(), '(work for 7 sec)');
      expect(durationsList[7].currRep, 2);
      expect(durationsList[7].currSet, 2);
      expect(durationsList[7].gripName, 'Half Crimp');
      expect(durationsList[7].nextGripName, null);
      expect(durationsList[7].currGrip, 1);

      expect(durationsList[8].toString(), '(complete for 0 sec)');
      expect(durationsList[8].currRep, 3);
      expect(durationsList[8].currSet, 3);
      expect(durationsList[8].gripName, null);
      expect(durationsList[8].nextGripName, null);
      expect(durationsList[8].currGrip, 2);
    });

    test('A workout with two grips of 1 set and 1 rep is created correctly',
        () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip1Set1Rep, warmUpJugType),
        GripWithGripType(grip1Set1Rep, halfCrimpType),
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 5);
      expect(durationsList.totalSeconds, 74);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Warm Up Jug');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Warm Up Jug');
      expect(durationsList[1].nextGripName, 'Half Crimp');
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(break for 45 sec)');
      expect(durationsList[2].currRep, 1);
      expect(durationsList[2].currSet, 1);
      expect(durationsList[2].gripName, 'Half Crimp');
      expect(durationsList[2].nextGripName, null);
      expect(durationsList[2].currGrip, 2);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 1);
      expect(durationsList[3].currSet, 1);
      expect(durationsList[3].gripName, 'Half Crimp');
      expect(durationsList[3].nextGripName, null);
      expect(durationsList[3].currGrip, 2);

      expect(durationsList[4].toString(), '(complete for 0 sec)');
      expect(durationsList[4].currRep, 2);
      expect(durationsList[4].currSet, 2);
      expect(durationsList[4].gripName, null);
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 3);
    });

    test('A workout with two grips of unequal reps is created correctly', () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip1Set2Rep, warmUpJugType),
        GripWithGripType(grip1Set1Rep, halfCrimpType),
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 7);
      expect(durationsList.totalSeconds, 84);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Warm Up Jug');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Warm Up Jug');
      expect(durationsList[1].nextGripName, 'Half Crimp');
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(rest for 3 sec)');
      expect(durationsList[2].currRep, 2);
      expect(durationsList[2].currSet, 1);
      expect(durationsList[2].gripName, 'Warm Up Jug');
      expect(durationsList[2].nextGripName, 'Half Crimp');
      expect(durationsList[2].currGrip, 1);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 2);
      expect(durationsList[3].currSet, 1);
      expect(durationsList[3].gripName, 'Warm Up Jug');
      expect(durationsList[3].nextGripName, 'Half Crimp');
      expect(durationsList[3].currGrip, 1);

      expect(durationsList[4].toString(), '(break for 45 sec)');
      expect(durationsList[4].currRep, 1);
      expect(durationsList[4].currSet, 1);
      expect(durationsList[4].gripName, 'Half Crimp');
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 2);

      expect(durationsList[5].toString(), '(work for 7 sec)');
      expect(durationsList[5].currRep, 1);
      expect(durationsList[5].currSet, 1);
      expect(durationsList[5].gripName, 'Half Crimp');
      expect(durationsList[5].nextGripName, null);
      expect(durationsList[5].currGrip, 2);

      expect(durationsList[6].toString(), '(complete for 0 sec)');
      expect(durationsList[6].currRep, 2);
      expect(durationsList[6].currSet, 2);
      expect(durationsList[6].gripName, null);
      expect(durationsList[6].nextGripName, null);
      expect(durationsList[6].currGrip, 3);
    });

    test('A workout with two grips and unequal sets is created correctly', () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip2Set1Rep, warmUpJugType),
        GripWithGripType(grip1Set1Rep, halfCrimpType),
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 7);
      expect(durationsList.totalSeconds, 111);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Warm Up Jug');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Warm Up Jug');
      expect(durationsList[1].nextGripName, 'Half Crimp');
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(break for 30 sec)');
      expect(durationsList[2].currRep, 1);
      expect(durationsList[2].currSet, 2);
      expect(durationsList[2].gripName, 'Warm Up Jug');
      expect(durationsList[2].nextGripName, 'Half Crimp');
      expect(durationsList[2].currGrip, 1);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 1);
      expect(durationsList[3].currSet, 2);
      expect(durationsList[3].gripName, 'Warm Up Jug');
      expect(durationsList[3].nextGripName, 'Half Crimp');
      expect(durationsList[3].currGrip, 1);

      expect(durationsList[4].toString(), '(break for 45 sec)');
      expect(durationsList[4].currRep, 1);
      expect(durationsList[4].currSet, 1);
      expect(durationsList[4].gripName, 'Half Crimp');
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 2);

      expect(durationsList[5].toString(), '(work for 7 sec)');
      expect(durationsList[5].currRep, 1);
      expect(durationsList[5].currSet, 1);
      expect(durationsList[5].gripName, 'Half Crimp');
      expect(durationsList[5].nextGripName, null);
      expect(durationsList[5].currGrip, 2);

      expect(durationsList[6].toString(), '(complete for 0 sec)');
      expect(durationsList[6].currRep, 2);
      expect(durationsList[6].currSet, 2);
      expect(durationsList[6].gripName, null);
      expect(durationsList[6].nextGripName, null);
      expect(durationsList[6].currGrip, 3);
    });

    test(
        'A workout with two grips of unequal sets and reps is created correctly',
        () {
      final List<GripWithGripType> gripsList = [
        GripWithGripType(grip2Set1Rep, warmUpJugType),
        GripWithGripType(grip1Set2Rep, halfCrimpType),
      ];
      final durationsList = WorkoutDurationStatusList(gripList: gripsList);

      expect(durationsList.length, 9);
      expect(durationsList.totalSeconds, 121);
      expect(durationsList[0].toString(), '(prepare for 15 sec)');
      expect(durationsList[0].currRep, 1);
      expect(durationsList[0].currSet, 1);
      expect(durationsList[0].gripName, null);
      expect(durationsList[0].nextGripName, 'Warm Up Jug');
      expect(durationsList[0].currGrip, 1);

      expect(durationsList[1].toString(), '(work for 7 sec)');
      expect(durationsList[1].currRep, 1);
      expect(durationsList[1].currSet, 1);
      expect(durationsList[1].gripName, 'Warm Up Jug');
      expect(durationsList[1].nextGripName, 'Half Crimp');
      expect(durationsList[1].currGrip, 1);

      expect(durationsList[2].toString(), '(break for 30 sec)');
      expect(durationsList[2].currRep, 1);
      expect(durationsList[2].currSet, 2);
      expect(durationsList[2].gripName, 'Warm Up Jug');
      expect(durationsList[2].nextGripName, 'Half Crimp');
      expect(durationsList[2].currGrip, 1);

      expect(durationsList[3].toString(), '(work for 7 sec)');
      expect(durationsList[3].currRep, 1);
      expect(durationsList[3].currSet, 2);
      expect(durationsList[3].gripName, 'Warm Up Jug');
      expect(durationsList[3].nextGripName, 'Half Crimp');
      expect(durationsList[3].currGrip, 1);

      expect(durationsList[4].toString(), '(break for 45 sec)');
      expect(durationsList[4].currRep, 1);
      expect(durationsList[4].currSet, 1);
      expect(durationsList[4].gripName, 'Half Crimp');
      expect(durationsList[4].nextGripName, null);
      expect(durationsList[4].currGrip, 2);

      expect(durationsList[5].toString(), '(work for 7 sec)');
      expect(durationsList[5].currRep, 1);
      expect(durationsList[5].currSet, 1);
      expect(durationsList[5].gripName, 'Half Crimp');
      expect(durationsList[5].nextGripName, null);
      expect(durationsList[5].currGrip, 2);

      expect(durationsList[6].toString(), '(rest for 3 sec)');
      expect(durationsList[6].currRep, 2);
      expect(durationsList[6].currSet, 1);
      expect(durationsList[6].gripName, 'Half Crimp');
      expect(durationsList[6].nextGripName, null);
      expect(durationsList[6].currGrip, 2);

      expect(durationsList[7].toString(), '(work for 7 sec)');
      expect(durationsList[7].currRep, 2);
      expect(durationsList[7].currSet, 1);
      expect(durationsList[7].gripName, 'Half Crimp');
      expect(durationsList[7].nextGripName, null);
      expect(durationsList[7].currGrip, 2);

      expect(durationsList[8].toString(), '(complete for 0 sec)');
      expect(durationsList[8].currRep, 3);
      expect(durationsList[8].currSet, 2);
      expect(durationsList[8].gripName, null);
      expect(durationsList[8].nextGripName, null);
      expect(durationsList[8].currGrip, 3);
    });
  });
}
