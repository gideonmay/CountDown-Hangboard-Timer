import 'package:flutter/cupertino.dart';
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
      child: CupertinoApp(
          home: CountdownTimerScreen(timerDurations: timerDurations)));

  testWidgets('CountdownTimer has correct initial state', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);

    expect(find.text('0:07'), findsOneWidget); // Work time
    expect(find.text('0:03'), findsOneWidget); // Rest time
    expect(find.text('3:00'), findsOneWidget); // Break time
    expect(find.text('0:15'), findsOneWidget); // The initial PREPARE duration
    expect(find.text('PREPARE'), findsOneWidget);
    expect(find.text('Total '), findsOneWidget);
    expect(find.text('Elapsed '), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
  });

  testWidgets('The correct buttons appear when timer is started',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('START'));
    await tester.pump(const Duration(seconds: 2));

    // START button disappears, but Pause, Reset, and Skip buttons appear
    expect(find.text('START'), findsNothing);
    expect(find.textContaining('Pause'), findsOneWidget);
    expect(find.textContaining('Reset'), findsOneWidget);
    expect(find.textContaining('Skip'), findsOneWidget);
  });

  testWidgets('The Resume button appears when timer is paused', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('START'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.textContaining('Pause'));
    await tester.pump();

    expect(find.text('START'), findsNothing);
    expect(find.textContaining('Resume'), findsOneWidget);
    expect(find.textContaining('Reset'), findsOneWidget);
    expect(find.textContaining('Skip'), findsOneWidget);
  });

  testWidgets('The Skip button skips to the first Work duration',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('START'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.textContaining('Skip'));
    await tester.pump();

    expect(find.text('WORK'), findsOneWidget);
    // Should be 2 work durations in timer and in timer details area
    expect(find.text('0:07'), findsAtLeastNWidgets(2));
  });

  testWidgets('The Reset button restores intial timer state', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('START'));
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.textContaining('Reset'));
    await tester.pump();

    expect(find.text('0:07'), findsOneWidget); // Work time
    expect(find.text('0:03'), findsOneWidget); // Rest time
    expect(find.text('3:00'), findsOneWidget); // Break time
    expect(find.text('0:15'), findsOneWidget); // The initial PREPARE duration
    expect(find.text('PREPARE'), findsOneWidget);
    expect(find.text('Total '), findsOneWidget);
    expect(find.text('Elapsed '), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
  });

  testWidgets('Reps increments by one after first work duration is complete',
      (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('START'));
    // Skip to the first Rest duration
    await tester.pump(const Duration(seconds: 2));
    await tester.tap(find.textContaining('Skip'));
    await tester.pump();
    await tester.tap(find.textContaining('Skip'));
    await tester.pump();

    expect(find.text('REST'), findsOneWidget);
  });

  testWidgets('Checks that ending state of timer is correct', (tester) async {
    await tester.pumpWidget(countdownTimerScreen);
    await tester.tap(find.text('START'));
    await tester.pump(const Duration(seconds: 2));

    // Skip until timer has completed
    while (!tester.any(find.text('COMPLETE'))) {
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();
    }

    expect(find.text('0:00'), findsOneWidget);
    expect(find.text('START'), findsOneWidget);
  });
}
