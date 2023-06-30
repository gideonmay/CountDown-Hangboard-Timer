import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/forms/workout_form.dart';
import 'package:countdown_app/models/workout_dto.dart';

void main() {
  // Widget under test
  Widget workoutFormWidget(WorkoutDTO workoutDTO) {
    return MediaQuery(
        data: const MediaQueryData(),
        child: CupertinoApp(
            home: CupertinoPageScaffold(
          child: WorkoutForm(
            workoutDTO: workoutDTO,
            onFormSaved: () => null,
            buttonText: 'Submit',
          ),
        )));
  }

  testWidgets('WorkoutForm shows correct initial values', (tester) async {
    Widget workoutForm = workoutFormWidget(
        WorkoutDTO(name: 'My Workout', description: 'Something'));

    await tester.pumpWidget(workoutForm);

    expect(find.text('My Workout'), findsOneWidget);
    expect(find.text('Something'), findsOneWidget);
  });

  testWidgets('WorkoutForm shows two errors if name and description are blank',
      (tester) async {
    Widget workoutForm = workoutFormWidget(WorkoutDTO.blank());

    await tester.pumpWidget(workoutForm);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('WorkoutForm shows one error if name is blank', (tester) async {
    Widget workoutForm =
        workoutFormWidget(WorkoutDTO(name: null, description: 'Something'));

    await tester.pumpWidget(workoutForm);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a description'), findsNothing);
  });

  testWidgets('WorkoutForm shows one error if description is blank',
      (tester) async {
    Widget workoutForm =
        workoutFormWidget(WorkoutDTO(name: 'My Workout', description: null));

    await tester.pumpWidget(workoutForm);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsNothing);
    expect(find.text('Please enter a description'), findsOneWidget);
  });
}
