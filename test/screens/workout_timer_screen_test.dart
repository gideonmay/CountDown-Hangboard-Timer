import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/models/duration_status_list.dart';
import 'package:countdown_app/screens/workout_timer_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
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
    const halfCrimpType = GripType(id: 1, name: 'Half Crimp');

    final List<GripWithGripType> gripList = [
      GripWithGripType(grip1Set1Rep, halfCrimpType),
    ];
    final durationStatusList = WorkoutDurationStatusList(gripList: gripList);

    chooseSoundScreen = CupertinoApp(
        home: WorkoutTimerScreen(
      durationStatusList: durationStatusList,
      title: 'Test Workout',
    ));
  });

  testWidgets('WorkoutTimerScreen renders without any errors', (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
