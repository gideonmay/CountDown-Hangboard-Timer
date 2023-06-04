import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/widgets/grip_types_list.dart';

void main() {
  final List<GripTypeWithGripCount> gripTypes = [
    GripTypeWithGripCount(const GripType(id: 1, name: 'Half Crimp'), 0),
    GripTypeWithGripCount(const GripType(id: 2, name: 'Open Hand Crimp'), 3),
    GripTypeWithGripCount(const GripType(id: 3, name: 'Three Finger Drag'), 1),
    GripTypeWithGripCount(const GripType(id: 4, name: 'Warm Up Jug'), 0),
  ];

  testWidgets(
      'Error dialog shown if user tries to delete the grip type that is currently being edited',
      (tester) async {
    Widget gripForm = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        home: Scaffold(
            body: GripTypesList(gripTypes: gripTypes, currGripTypeID: 1)),
      ),
    );

    await tester.pumpWidget(gripForm);

    final deleteButton = find.byKey(const Key('deleteIcon0'));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Grip type cannot be deleted'), findsOneWidget);
  });

  testWidgets(
      'Correct dialog shown if user tries to delete a grip type with 3 grips',
      (tester) async {
    Widget gripForm = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        home: Scaffold(
            body: GripTypesList(gripTypes: gripTypes, currGripTypeID: 1)),
      ),
    );

    await tester.pumpWidget(gripForm);

    final deleteButton = find.byKey(const Key('deleteIcon1'));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    final alertText = find.text(
        'The grip type \'${gripTypes[1].entry.name}\' will be permanently deleted along with the 3 grips that it is used on');

    expect(alertText, findsOneWidget);
  });

  testWidgets(
      'Correct dialog shown if user tries to delete a grip type with 1 grips',
      (tester) async {
    Widget gripForm = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        home: Scaffold(
            body: GripTypesList(gripTypes: gripTypes, currGripTypeID: 1)),
      ),
    );

    await tester.pumpWidget(gripForm);

    final deleteButton = find.byKey(const Key('deleteIcon2'));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    final alertText = find.text(
        'The grip type \'${gripTypes[2].entry.name}\' will be permanently deleted along with the 1 grip that it is used on');

    expect(alertText, findsOneWidget);
  });

  testWidgets(
      'Correct dialog shown if user tries to delete a grip type with 0 grips',
      (tester) async {
    Widget gripForm = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: MaterialApp(
        home: Scaffold(
            body: GripTypesList(gripTypes: gripTypes, currGripTypeID: 1)),
      ),
    );

    await tester.pumpWidget(gripForm);

    final deleteButton = find.byKey(const Key('deleteIcon3'));
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    final alertText = find.text(
        'The grip type \'${gripTypes[3].entry.name}\' will be permanently deleted');

    expect(alertText, findsOneWidget);
  });
}
