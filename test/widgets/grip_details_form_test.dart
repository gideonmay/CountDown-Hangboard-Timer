import 'package:flutter/cupertino.dart';
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
  var mockStream = MockStream<List<GripTypeWithGripCount>>();

  // Returns a List of GripTypes within a Stream
  Stream<List<GripTypeWithGripCount>> streamFunc() async* {
    yield [GripTypeWithGripCount(const GripType(id: 1, name: 'TestType1'), 1)];
    yield [GripTypeWithGripCount(const GripType(id: 1, name: 'TestType2'), 1)];
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

  // Define a mock stream to return an empty List
  var mockStreamEmpty = MockStream<List<GripTypeWithGripCount>>();

  // Returns an empty List within a Stream
  Stream<List<GripTypeWithGripCount>> streamFuncEmpty() async* {
    yield [];
  }

  // Set the mock stream up to yield streamFuncEmpty when listened to
  when(mockStreamEmpty.listen(
    any,
    onError: anyNamed('onError'),
    onDone: anyNamed('onDone'),
    cancelOnError: anyNamed('cancelOnError'),
  )).thenAnswer((inv) {
    var onData = inv.positionalArguments.single;
    var onError = inv.namedArguments[#onError];
    var onDone = inv.namedArguments[#onDone];
    var cancelOnError = inv.namedArguments[#cancelOnError];
    return streamFuncEmpty().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  });

  testWidgets(
      'Form shows an error message if no grip type is chosen when grip types list is empty',
      (tester) async {
    final gripDTO = GripDTO.standard();

    Widget picker = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: GripDetailsForm(
                gripDTO: gripDTO,
                onFormSaved: () {},
                buttonText: 'Submit',
                gripTypeStream: mockStreamEmpty),
          ),
        ));

    await tester.pumpWidget(picker);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Please choose a grip type'), findsOneWidget);
  });

  testWidgets(
      'Form shows an error message if no grip type is chosen when grip types list is not empty',
      (tester) async {
    final gripDTO = GripDTO.standard();

    Widget picker = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: GripDetailsForm(
                gripDTO: gripDTO,
                onFormSaved: () {},
                buttonText: 'Submit',
                gripTypeStream: mockStream),
          ),
        ));

    await tester.pumpWidget(picker);
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(find.text('Please choose a grip type'), findsOneWidget);
  });
}
