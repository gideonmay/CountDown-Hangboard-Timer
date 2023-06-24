import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../forms/add_grip_type_form.dart';

class AddGripTypeScreen extends StatelessWidget {
  final List<GripTypeWithGripCount> gripTypes;

  const AddGripTypeScreen(
      {super.key, required this.gripTypes});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: 'Choose Grip Type',
          middle: Text('Add Grip Type'),
        ),
        child: SafeArea(child: AddGripTypeForm(gripTypes: gripTypes)));
  }
}
