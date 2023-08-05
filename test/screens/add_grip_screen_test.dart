import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/screens/add_grip_screen.dart';
import 'package:provider/provider.dart';

void main() {
  late Widget addGripScreen;

  setUp(() {
    final workout = Workout(
        id: 1,
        name: 'Test Workout',
        description: 'A test workout',
        createdDate: DateTime(2023, 7, 14));

    addGripScreen = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(home: AddGripScreen(workout: workout)));
  });

  testWidgets('AddGripScreen renders without any errors', (tester) async {
    await tester.pumpWidget(addGripScreen);
  });
}
