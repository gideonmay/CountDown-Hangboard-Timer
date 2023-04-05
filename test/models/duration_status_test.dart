import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/duration_status.dart';
import 'package:countdown_app/models/status_value.dart';

void main() {
  test('DurationStatus object has correct values', () {
    final durationStatus = DurationStatus(
        duration: const Duration(seconds: 10),
        statusValue: StatusValue.isWorking(),
        statusColor: const Color.fromARGB(0, 255, 0, 0));

    expect(durationStatus.duration, const Duration(seconds: 10));
    expect(durationStatus.statusValue.status, 'work');
    expect(durationStatus.statusColor, const Color.fromARGB(0, 255, 0, 0));
  });

  test('DurationStatus toString returns correct value', () {
    final durationStatus = DurationStatus(
        duration: const Duration(seconds: 10),
        statusValue: StatusValue.isWorking(),
        statusColor: const Color.fromARGB(0, 255, 0, 0));

    expect(durationStatus.toString(), '(work for 10 sec)');
  });

  test('DurationStatus status getter returns correct value', () {
    final durationStatus = DurationStatus(
        duration: const Duration(seconds: 10),
        statusValue: StatusValue.isWorking(),
        statusColor: const Color.fromARGB(0, 255, 0, 0));

    expect(durationStatus.status, 'WORK');
  });
}
