import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/widgets/grip_type_picker.dart';
import 'package:countdown_app/models/grip_dto.dart';
import 'grip_type_dropdown_test.mocks.dart';

@GenerateMocks([Stream])
void main() {
  // Define a mock stream to return a List of GripType objects
  var mockStream = MockStream<List<GripType>>();

  // Returns a List of GripTypes within a Stream
  Stream<List<GripType>> streamFunc() async* {
    yield [const GripType(id: 1, name: 'TestType1')];
    yield [const GripType(id: 2, name: 'TestType2')];
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
  var mockStreamEmpty = MockStream<List<GripType>>();

  // Returns an empty List within a Stream
  Stream<List<GripType>> streamFuncEmpty() async* {
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

  testWidgets('Dropdown shows "No grip types added" if grip type list is empty',
      (tester) async {
    final gripDTO = GripDTO.standard();

    Widget dropdown = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: GripTypePicker(
              gripDTO: gripDTO,
              gripTypeStream: mockStreamEmpty,
            ),
          ),
        ));

    await tester.pumpWidget(dropdown);
    expect(find.text('No grip types added'), findsOneWidget);
  });
}
