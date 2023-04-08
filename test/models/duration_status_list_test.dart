import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/duration_status_list.dart';

void main() {
  test('All variables given as parameters are initialized properly', () {
    var durationsList = DurationStatusList(
        sets: 3,
        reps: 2,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

    expect(durationsList.sets, 3);
    expect(durationsList.reps, 2);
    expect(durationsList.workDuration, const Duration(seconds: 10));
    expect(durationsList.restDuration, const Duration(seconds: 3));
    expect(durationsList.breakDuration, const Duration(seconds: 30));
    expect(durationsList.includePrepare, true);
  });

  test('A list with 0 sets and 0 reps only has one element', () {
    var durationsList = DurationStatusList(
        sets: 0,
        reps: 0,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

    expect(durationsList.length, 1);
    expect(durationsList.totalSeconds, 0);
    expect(durationsList[0].toString(), '(complete for 0 sec)');
  });

  test('A list with 0 sets and 1 rep only has one element', () {
    var durationsList = DurationStatusList(
        sets: 0,
        reps: 1,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

    expect(durationsList.length, 1);
    expect(durationsList.totalSeconds, 0);
    expect(durationsList[0].toString(), '(complete for 0 sec)');
  });

  test('A list with 1 sets and 0 reps is only has one element', () {
    var durationsList = DurationStatusList(
        sets: 1,
        reps: 0,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

    expect(durationsList.length, 1);
    expect(durationsList.totalSeconds, 0);
    expect(durationsList[0].toString(), '(complete for 0 sec)');
  });

  test('A list with includePrepare == false does not start with a prepare', () {
    var durationsList = DurationStatusList(
        sets: 1,
        reps: 1,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: false);

    expect(durationsList.length, 2);
    expect(durationsList.totalSeconds, 10);
    expect(durationsList[0].toString(), '(work for 10 sec)');
    expect(durationsList[1].toString(), '(complete for 0 sec)');
  });

  test('A list with 1 sets and 1 reps contains 3 elements', () {
    var durationsList = DurationStatusList(
        sets: 1,
        reps: 1,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

    expect(durationsList.length, 3);
    expect(durationsList.totalSeconds, 25);
    expect(durationsList[0].toString(), '(prepare for 15 sec)');
    expect(durationsList[1].toString(), '(work for 10 sec)');
    expect(durationsList[2].toString(), '(complete for 0 sec)');
  });

  test('A list with 1 sets and 2 reps contains the correct durations', () {
    var durationsList = DurationStatusList(
        sets: 1,
        reps: 2,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

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
    expect(durationsList[4].currRep, 2);
    expect(durationsList[4].currSet, 1);
  });

  test('A list with 2 sets and 1 reps contains the correct durations', () {
    var durationsList = DurationStatusList(
        sets: 2,
        reps: 1,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

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
    expect(durationsList[4].currRep, 1);
    expect(durationsList[4].currSet, 2);
  });

  test('A list with 2 sets and 2 reps contains the correct durations', () {
    var durationsList = DurationStatusList(
        sets: 2,
        reps: 2,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

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
    expect(durationsList[8].currRep, 2);
    expect(durationsList[8].currSet, 2);
  });

  test('The correct startTime is present at each index in the list', () {
    var durationsList = DurationStatusList(
        sets: 2,
        reps: 1,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30),
        includePrepare: true);

    expect(durationsList.length, 5);
    expect(durationsList.totalSeconds, 65);
    expect(durationsList[0].startTime, const Duration(seconds: 0));
    expect(durationsList[1].startTime, const Duration(seconds: 15));
    expect(durationsList[2].startTime, const Duration(seconds: 25));
    expect(durationsList[3].startTime, const Duration(seconds: 55));
    expect(durationsList[4].startTime, const Duration(seconds: 65));
  });
}
