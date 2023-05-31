import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/forms/grip_details_form.dart';
import 'package:countdown_app/models/grip_dto.dart';
import 'grip_details_form_test.mocks.dart';

@GenerateMocks([Stream])
void main() {
  // Define a mock stream to return a List of GripType objects
  var mockStream = MockStream<List<GripType>>();

  // Returns a List of GripTypes within a Stream
  Stream<List<GripType>> streamFunc() async* {
    yield [const GripType(id: 1, name: 'TestType')];
  }

  // Set the mock stream up to yield streamFunc when listened to
  when(mockStream.listen(
    any,
    onError: anyNamed('onError'),
    onDone: anyNamed('onDone'),
    cancelOnError: anyNamed('cancelOnError'),
  )).thenAnswer((inv) {
    var onData = inv.positionalArguments.single;
    var onError = inv.namedArguments[#onError];
    var onDone = inv.namedArguments[#onDone];
    var cancelOnError = inv.namedArguments[#cancelOnError];
    return streamFunc().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  });

  testWidgets('GripDetailsForm shows error if grip type not chosen',
      (tester) async {
    final gripDTO = GripDTO.standard();

    Widget gripForm = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        home: Scaffold(
            body: GripDetailsForm(
                gripDTO: gripDTO,
                gripTypeStream: mockStream,
                onFormSaved: () {},
                buttonText: 'Submit')),
      ),
    );

    await tester.pumpWidget(gripForm);

    // Scroll down until Submit button is in view
    final submitButton = find.text('Submit');
    await tester.dragUntilVisible(
        submitButton, find.byType(ListView), const Offset(0.0, -50.0),
        maxIteration: 100);
    await tester.pumpAndSettle();

    // Tap Submit button
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    // Scroll back up until error text found
    final errorText = find.textContaining('Please choose a grip type');
    await tester.dragUntilVisible(
        errorText, find.byType(ListView), const Offset(0.0, 50.0),
        maxIteration: 100);
    await tester.pumpAndSettle();

    expect(errorText, findsOneWidget);
  });
}
