import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/widgets/workout_form.dart';
import 'package:countdown_app/models/workout_dto.dart';

void main() {
  testWidgets('WorkoutForm shows correct initial values', (tester) async {
    Widget workoutForm = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: Scaffold(
          body: WorkoutForm(
            workoutDTO:
                WorkoutDTO(name: 'My Workout', description: 'Something'),
            onFormSaved: () => null,
            buttonText: 'Submit',
          ),
        )));

    await tester.pumpWidget(workoutForm);

    expect(find.text('My Workout'), findsOneWidget);
    expect(find.text('Something'), findsOneWidget);
  });

  testWidgets('WorkoutForm shows two errors if name and description are blank',
      (tester) async {
    Widget workoutForm = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: Scaffold(
          body: WorkoutForm(
            workoutDTO: WorkoutDTO.blank(),
            onFormSaved: () => null,
            buttonText: 'Submit',
          ),
        )));

    await tester.pumpWidget(workoutForm);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
  });

  testWidgets('WorkoutForm shows one error if name is blank',
      (tester) async {
    Widget workoutForm = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: Scaffold(
          body: WorkoutForm(
            workoutDTO: WorkoutDTO(name: null, description: 'Something'),
            onFormSaved: () => null,
            buttonText: 'Submit',
          ),
        )));

    await tester.pumpWidget(workoutForm);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(find.text('Please enter a description'), findsNothing);
  });

  testWidgets('WorkoutForm shows one error if description is blank',
      (tester) async {
    Widget workoutForm = MediaQuery(
        data: const MediaQueryData(),
        child: MaterialApp(
            home: Scaffold(
          body: WorkoutForm(
            workoutDTO: WorkoutDTO(name: 'My Workout', description: null),
            onFormSaved: () => null,
            buttonText: 'Submit',
          ),
        )));

    await tester.pumpWidget(workoutForm);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsNothing);
    expect(find.text('Please enter a description'), findsOneWidget);
  });
}