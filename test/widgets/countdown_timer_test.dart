import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/models/duration_status_list.dart';
import 'package:countdown_app/widgets/countdown_timer.dart';
import 'package:countdown_app/models/timer_durations_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CountdownTimer created from TimerDurationsDTO', () {
    late Widget timerFromTimerDTO;

    final timerDurations = TimerDurationsDTO(
        sets: 5,
        reps: 6,
        workSeconds: 7,
        restSeconds: 3,
        breakMinutes: 3,
        breakSeconds: 0);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      timerFromTimerDTO = MediaQuery(
          data: const MediaQueryData(),
          child: CupertinoApp(
              home: CountdownTimer(
                  timerDurations: timerDurations)));
    });

    testWidgets('CountdownTimer has correct initial state', (tester) async {
      await tester.pumpWidget(timerFromTimerDTO);

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
      await tester.pumpWidget(timerFromTimerDTO);
      await tester.tap(find.text('START'));
      await tester.pump(const Duration(seconds: 2));

      // START button disappears, but Pause, Reset, and Skip buttons appear
      expect(find.text('START'), findsNothing);
      expect(find.textContaining('Pause'), findsOneWidget);
      expect(find.textContaining('Reset'), findsOneWidget);
      expect(find.textContaining('Skip'), findsOneWidget);
    });

    testWidgets('The Resume button appears when timer is paused',
        (tester) async {
      await tester.pumpWidget(timerFromTimerDTO);
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
      await tester.pumpWidget(timerFromTimerDTO);
      await tester.tap(find.text('START'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();

      expect(find.text('WORK'), findsOneWidget);
      // Should be 2 work durations in timer and in timer details area
      expect(find.text('0:07'), findsAtLeastNWidgets(2));
    });

    testWidgets('The Reset button restores intial timer state', (tester) async {
      await tester.pumpWidget(timerFromTimerDTO);
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
      await tester.pumpWidget(timerFromTimerDTO);
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
      await tester.pumpWidget(timerFromTimerDTO);
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
  });

  group('CountdownTimer created from a DurationStatusList', () {
    late Widget timerFromList;

    const halfCrimpType = GripType(id: 1, name: 'Half Crimp');
    const warmUpJugType = GripType(id: 2, name: 'Warm Up Jug');

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

    final List<GripWithGripType> gripsList = [
      GripWithGripType(grip1Set1Rep, warmUpJugType),
      GripWithGripType(grip1Set1Rep, halfCrimpType),
    ];
    final durationsList = WorkoutDurationStatusList(gripList: gripsList);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      timerFromList = MediaQuery(
          data: const MediaQueryData(),
          child: CupertinoApp(
              home: CountdownTimer.fromList(
                  durationStatusList: durationsList)));
    });

    testWidgets('The first grip in workout is shown during PREPARE countdown',
        (tester) async {
      await tester.pumpWidget(timerFromList);
      await tester.tap(find.text('START'));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Warm Up Jug'), findsOneWidget);
    });

    testWidgets('The next grip in workout is shown during first WORK countdown',
        (tester) async {
      await tester.pumpWidget(timerFromList);
      await tester.tap(find.text('START'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();

      expect(find.text('WORK'), findsOneWidget);
      expect(find.text('Warm Up Jug'), findsOneWidget);
      expect(find.text('Next Grip: Half Crimp'), findsOneWidget);
    });

    testWidgets(
        'Only the next grip in workout is shown during first BREAK countdown',
        (tester) async {
      await tester.pumpWidget(timerFromList);
      await tester.tap(find.text('START'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();

      expect(find.text('BREAK'), findsOneWidget);
      expect(find.text('Half Crimp'), findsOneWidget);
    });

    testWidgets('Zero grips are shown when workout is complete',
        (tester) async {
      await tester.pumpWidget(timerFromList);
      await tester.tap(find.text('START'));
      await tester.pump(const Duration(seconds: 2));
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();
      await tester.tap(find.textContaining('Skip'));
      await tester.pump();

      expect(find.text('COMPLETE'), findsOneWidget);
      expect(find.text('Half Crimp'), findsNothing);
      expect(find.text('Warm Up Jug'), findsNothing);
    });
  });
}
