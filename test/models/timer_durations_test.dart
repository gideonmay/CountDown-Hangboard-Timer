import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/timer_durations_dto.dart';

void main() {
  test('TimerDurations has the correct getter values', () {
    final timerDurations = TimerDurationsDTO(
        sets: 1,
        reps: 1,
        workSeconds: 12,
        restSeconds: 5,
        breakMinutes: 1,
        breakSeconds: 25);

    expect(timerDurations.sets, 1);
    expect(timerDurations.reps, 1);
    expect(timerDurations.workSeconds, 12);
    expect(timerDurations.restSeconds, 5);
    expect(timerDurations.breakMinutes, 1);
    expect(timerDurations.breakSeconds, 25);
  });

  test('TimerDurations.standard() has the correct standard values', () {
    final timerDurations = TimerDurationsDTO.standard();

    expect(timerDurations.sets, 1);
    expect(timerDurations.reps, 1);
    expect(timerDurations.workSeconds, 10);
    expect(timerDurations.restSeconds, 5);
    expect(timerDurations.breakMinutes, 0);
    expect(timerDurations.breakSeconds, 30);
  });

  test('TimerDurations returns the correct rest, work and break durations', () {
    final timerDurations = TimerDurationsDTO(
        sets: 1,
        reps: 1,
        workSeconds: 12,
        restSeconds: 5,
        breakMinutes: 1,
        breakSeconds: 25);

    expect(timerDurations.workDuration, const Duration(seconds: 12));
    expect(timerDurations.restDuration, const Duration(seconds: 5));
    expect(
        timerDurations.breakDuration, const Duration(minutes: 1, seconds: 25));
  });
}
