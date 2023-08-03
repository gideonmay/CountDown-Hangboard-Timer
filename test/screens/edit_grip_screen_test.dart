import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/screens/edit_grip_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
    final testGrip = GripWithGripType(
        const Grip(
            id: 1,
            workout: 1,
            gripType: 1,
            setCount: 1,
            repCount: 1,
            workSeconds: 3,
            restSeconds: 7,
            breakMinutes: 1,
            breakSeconds: 30,
            lastBreakMinutes: 2,
            lastBreakSeconds: 30,
            sequenceNum: 1),
        const GripType(id: 1, name: 'Half Crimp'));
    final testWorkout = Workout(
        id: 1,
        name: 'Test Workout',
        description: 'A test workout',
        createdDate: DateTime(2023, 7, 12));

    chooseSoundScreen = CupertinoApp(
        home: Provider(
            create: (context) => AppDatabase(openConnection()),
            dispose: (context, db) => db.close(),
            child: EditGripScreen(grip: testGrip, workout: testWorkout)));
  });

  testWidgets('EditGripScreen renders without any errors', (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
