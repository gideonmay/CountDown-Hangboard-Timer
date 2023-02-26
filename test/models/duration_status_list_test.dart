import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/duration_status_list.dart';

void main() {
  test('All variables given as parameters are initialized properly', () {
    var durationsList = DurationStatusList(
        sets: 3,
        reps: 2,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30));

    expect(durationsList.sets, 3);
    expect(durationsList.reps, 2);
    expect(durationsList.workDuration, const Duration(seconds: 10));
    expect(durationsList.restDuration, const Duration(seconds: 3));
    expect(durationsList.breakDuration, const Duration(seconds: 30));
  });

  test('A list with 0 sets and 0 reps only contains one DurationStatus', () {
    var durationsList = DurationStatusList(
        sets: 0,
        reps: 0,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30));

    expect(durationsList.length, 1);
    expect(durationsList[0].toString(), '(prepare for 15 sec)');
  });

  test('A list with 0 sets and 1 rep only contains one DurationStatus', () {
    var durationsList = DurationStatusList(
        sets: 0,
        reps: 1,
        workDuration: const Duration(seconds: 10),
        restDuration: const Duration(seconds: 3),
        breakDuration: const Duration(seconds: 30));

    expect(durationsList.length, 1);
    expect(durationsList[0].toString(), '(prepare for 15 sec)');
  });
}
