import 'package:countdown_app/db/drift_database.dart';
import 'package:countdown_app/forms/add_grip_type_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  final gripTypes = [
    GripTypeWithGripCount(const GripType(id: 1, name: 'Half Crimp'), 1),
    GripTypeWithGripCount(const GripType(id: 2, name: 'Open Hand Crimp'), 1),
  ];

  testWidgets('Form shows an error message if grip type already exists',
      (tester) async {
    Widget addGripTypeForm = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: AddGripTypeForm(gripTypes: gripTypes),
          ),
        ));

    await tester.pumpWidget(addGripTypeForm);

    await tester.enterText(find.byType(CupertinoTextField), 'Half Crimp');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('This grip type already exists'), findsOneWidget);
  });

  testWidgets('Form shows an error message if only a space was entered',
      (tester) async {
    Widget addGripTypeForm = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: AddGripTypeForm(gripTypes: gripTypes),
          ),
        ));

    await tester.pumpWidget(addGripTypeForm);

    await tester.enterText(find.byType(CupertinoTextField), ' ');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a grip type name'), findsOneWidget);
  });

  testWidgets('Form shows an error message if no grip type was entered',
      (tester) async {
    Widget addGripTypeForm = Provider(
        create: (context) => AppDatabase(openConnection()),
        dispose: (context, db) => db.close(),
        child: CupertinoApp(
          home: CupertinoPageScaffold(
            child: AddGripTypeForm(gripTypes: gripTypes),
          ),
        ));

    await tester.pumpWidget(addGripTypeForm);

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a grip type name'), findsOneWidget);
  });
}
