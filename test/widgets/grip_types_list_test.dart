import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/models/grip_type_dto.dart';
import 'package:countdown_app/widgets/grip_types_list.dart';

void main() {
  final List<GripTypeWithGripCount> gripTypes = [
    GripTypeWithGripCount(const GripType(id: 1, name: 'Half Crimp'), 0),
    GripTypeWithGripCount(const GripType(id: 2, name: 'Open Hand Crimp'), 3),
    GripTypeWithGripCount(const GripType(id: 3, name: 'Three Finger Drag'), 1),
    GripTypeWithGripCount(const GripType(id: 4, name: 'Warm Up Jug'), 0),
  ];

  testWidgets('The correct grip type titles are rendered', (tester) async {
    Widget gripTypeList = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: CupertinoApp(
        home: CupertinoPageScaffold(
            child: GripTypesList(
          gripTypes: gripTypes,
          initialGripType: GripTypeDTO(id: 1, name: 'Half Crimp'),
          onGripTypeChanged: (newGripType) => null,
          previousPageTitle: 'Prev Page',
        )),
      ),
    );

    await tester.pumpWidget(gripTypeList);

    expect(find.byType(Icon), findsOneWidget); // Checkmark icon
    expect(find.text('Half Crimp'), findsOneWidget);
    expect(find.text('Open Hand Crimp'), findsOneWidget);
    expect(find.text('Three Finger Drag'), findsOneWidget);
    expect(find.text('Warm Up Jug'), findsOneWidget);
    expect(find.text('Used with 0 grips'), findsNWidgets(2));
    expect(find.text('Used with 3 grips'), findsOneWidget);
    expect(find.text('Used with 1 grips'), findsOneWidget);
  });
  testWidgets(
      'Error dialog shown if user tries to delete the currently selected grip type',
      (tester) async {
    Widget gripTypeList = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: CupertinoApp(
        home: CupertinoPageScaffold(
            child: GripTypesList(
          gripTypes: gripTypes,
          initialGripType: GripTypeDTO(id: 1, name: 'Half Crimp'),
          onGripTypeChanged: (newGripType) => null,
          previousPageTitle: 'Prev Page',
        )),
      ),
    );

    await tester.pumpWidget(gripTypeList);

    // Slide list tile to the left and tap the delete button
    final deleteButton = find.text('Delete');
    await tester.dragUntilVisible(
        deleteButton, find.text('Half Crimp'), const Offset(-200, 0),
        maxIteration: 1);
    await tester.pumpAndSettle();

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Grip Type cannot be deleted'), findsOneWidget);
  });

  testWidgets(
      'Correct dialog shown if user tries to delete a grip type with 3 grips',
      (tester) async {
    Widget gripTypeList = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: CupertinoApp(
        home: CupertinoPageScaffold(
            child: GripTypesList(
          gripTypes: gripTypes,
          initialGripType: GripTypeDTO(id: 1, name: 'Half Crimp'),
          onGripTypeChanged: (newGripType) => null,
          previousPageTitle: 'Prev Page',
        )),
      ),
    );

    await tester.pumpWidget(gripTypeList);

    // Slide list tile to the left and tap the delete button
    final deleteButton = find.text('Delete');
    await tester.dragUntilVisible(
        deleteButton, find.text('Open Hand Crimp'), const Offset(-200, 0),
        maxIteration: 1);
    await tester.pumpAndSettle();

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    final alertText = find.text(
        'The grip type \'${gripTypes[1].entry.name}\' will be permanently deleted along with the 3 grips that it is used on');

    expect(alertText, findsOneWidget);
  });

  testWidgets(
      'Correct dialog shown if user tries to delete a grip type with 1 grips',
      (tester) async {
    Widget gripTypeList = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: CupertinoApp(
        home: CupertinoPageScaffold(
            child: GripTypesList(
          gripTypes: gripTypes,
          initialGripType: GripTypeDTO(id: 1, name: 'Half Crimp'),
          onGripTypeChanged: (newGripType) => null,
          previousPageTitle: 'Prev Page',
        )),
      ),
    );

    await tester.pumpWidget(gripTypeList);

    // Slide list tile to the left and tap the delete button
    final deleteButton = find.text('Delete');
    await tester.dragUntilVisible(
        deleteButton, find.text('Three Finger Drag'), const Offset(-200, 0),
        maxIteration: 1);
    await tester.pumpAndSettle();

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    final alertText = find.text(
        'The grip type \'${gripTypes[2].entry.name}\' will be permanently deleted along with the 1 grip that it is used on');

    expect(alertText, findsOneWidget);
  });

  testWidgets(
      'Correct dialog shown if user tries to delete a grip type with 0 grips',
      (tester) async {
    Widget gripTypeList = Provider(
      create: (context) => AppDatabase(openConnection()),
      dispose: (context, db) => db.close(),
      child: CupertinoApp(
        home: CupertinoPageScaffold(
            child: GripTypesList(
          gripTypes: gripTypes,
          initialGripType: GripTypeDTO(id: 1, name: 'Half Crimp'),
          onGripTypeChanged: (newGripType) => null,
          previousPageTitle: 'Prev Page',
        )),
      ),
    );

    await tester.pumpWidget(gripTypeList);

    // Slide list tile to the left and tap the delete button
    final deleteButton = find.text('Delete');
    await tester.dragUntilVisible(
        deleteButton, find.text('Warm Up Jug'), const Offset(-200, 0),
        maxIteration: 1);
    await tester.pumpAndSettle();

    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    final alertText = find.text(
        'The grip type \'${gripTypes[3].entry.name}\' will be permanently deleted');

    expect(alertText, findsOneWidget);
  });
}
