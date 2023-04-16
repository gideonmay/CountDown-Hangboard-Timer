import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/screens/countdown_timer_screen.dart';
import 'package:countdown_app/models/timer_durations_dto.dart';

void main() {
  var timerDurations = TimerDurationsDTO(
      sets: 5,
      reps: 6,
      workSeconds: 7,
      restSeconds: 3,
      breakMinutes: 3,
      breakSeconds: 0);

  // Widget under test
  Widget countdownTimerScreen = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: CountdownTimerScreen(timerDurations: timerDurations)));

  testWidgets('CountdownTimer has correct initial state', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);

    expect(find.text('Set 1/5'), findsOneWidget);
    expect(find.text('Rep 1/6'), findsOneWidget);
    expect(find.text('Work 0:07'), findsOneWidget);
    expect(find.text('Rest 0:03'), findsOneWidget);
    expect(find.text('Break 3:00'), findsOneWidget);
    expect(find.text('0:15'), findsOneWidget); // The initial PREPARE duration
    expect(find.text('PREPARE'), findsOneWidget);
    expect(find.text('Total '), findsOneWidget);
    expect(find.text('Elapsed '), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('The correct buttons appear when timer is started',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 2));

    // Start button disappears, but Resume, Reset, and Skip buttons appear
    expect(find.text('Start'), findsNothing);
    expect(find.text('Pause'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('The Resume button appears when timer is paused', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Pause'));
    await tester.pump();

    expect(find.text('Start'), findsNothing);
    expect(find.text('Resume'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('The Skip button skips to the first Work duration',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(find.text('WORK'), findsOneWidget);
    expect(find.text('0:07'), findsOneWidget); // Correct work duration
  });

  testWidgets('The Reset button restores intial timer state', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Reset'));
    await tester.pump();

    expect(find.text('Work 0:07'), findsOneWidget);
    expect(find.text('Rest 0:03'), findsOneWidget);
    expect(find.text('Break 3:00'), findsOneWidget);
    expect(find.text('0:15'), findsOneWidget); // The initial PREPARE duration
    expect(find.text('PREPARE'), findsOneWidget);
    expect(find.text('Total '), findsOneWidget);
    expect(find.text('Elapsed '), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });

  testWidgets('Reps increments by one after first work duration is complete',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('Start'));
    // Skip to the first Rest duration
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.text('Skip'));
    await tester.pump();
    await tester.tap(find.text('Skip'));
    await tester.pump();

    expect(find.text('REST'), findsOneWidget);
  });

  testWidgets('Checks that ending state of timer is correct',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('Start'));
    await tester.pump(const Duration(seconds: 2));

    // Skip until timer has completed
    while (!tester.any(find.text('COMPLETE'))) {
      await tester.tap(find.text('Skip'));
      await tester.pump();
    }

    expect(find.text('0:00'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });
}
