import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/models/workout_dto.dart';
import 'package:countdown_app/screens/edit_workout_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
    chooseSoundScreen = CupertinoApp(
        home: Provider(
            create: (context) => AppDatabase(openConnection()),
            dispose: (context, db) => db.close(),
            child: EditWorkoutScreen(
              workoutDTO: WorkoutDTO(
                  id: 1, name: 'Test Workout', description: 'A test workout'),
            )));
  });

  testWidgets('EditWorkoutScreen renders without any errors', (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
