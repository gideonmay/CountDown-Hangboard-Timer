import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/duration_status.dart';
import 'package:countdown_app/models/status_value.dart';
import 'package:countdown_app/models/timer_details_dto.dart';

void main() {
  final timerDetails = TimerDetailsDTO(
      totalSets: 1,
      totalReps: 1,
      workDuration: const Duration(seconds: 10),
      restDuration: const Duration(seconds: 3),
      breakDuration: const Duration(seconds: 30));
  test('DurationStatus object has correct values', () {
    final durationStatus = DurationStatus(
        timerDetails: timerDetails,
        duration: const Duration(seconds: 10),
        statusValue: StatusValue.isWorking(),
        statusColor: const Color.fromARGB(0, 255, 0, 0),
        startTime: const Duration(seconds: 0),
        currRep: 1,
        currSet: 1);

    expect(durationStatus.duration, const Duration(seconds: 10));
    expect(durationStatus.statusValue.status, 'work');
    expect(durationStatus.statusColor, const Color.fromARGB(0, 255, 0, 0));
    expect(durationStatus.startTime, Duration.zero);
  });

  test('DurationStatus toString returns correct value', () {
    final durationStatus = DurationStatus(
        timerDetails: timerDetails,
        duration: const Duration(seconds: 10),
        statusValue: StatusValue.isWorking(),
        statusColor: const Color.fromARGB(0, 255, 0, 0),
        startTime: const Duration(seconds: 0),
        currRep: 1,
        currSet: 1);

    expect(durationStatus.toString(), '(work for 10 sec)');
  });

  test('DurationStatus status getter returns correct value', () {
    final durationStatus = DurationStatus(
        timerDetails: timerDetails,
        duration: const Duration(seconds: 10),
        statusValue: StatusValue.isWorking(),
        statusColor: const Color.fromARGB(0, 255, 0, 0),
        startTime: const Duration(seconds: 0),
        currRep: 1,
        currSet: 1);

    expect(durationStatus.status, 'WORK');
  });
}
