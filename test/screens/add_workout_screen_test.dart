import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/screens/add_workout_screen.dart';
import 'package:provider/provider.dart';

void main() {
  late Widget addWorkoutScreen;

  setUp(() {
    addWorkoutScreen = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: const CupertinoApp(home: AddWorkoutScreen()));
  });

  testWidgets('AddWorkoutScreen renders without any errors', (tester) async {
    await tester.pumpWidget(addWorkoutScreen);
  });
}
