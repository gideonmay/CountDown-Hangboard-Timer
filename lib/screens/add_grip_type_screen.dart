import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../forms/add_grip_type_form.dart';

class AddGripTypeScreen extends StatelessWidget {
  final List<GripTypeWithGripCount> gripTypes;

  const AddGripTypeScreen({super.key, required this.gripTypes});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Close the keyboard when user taps away from input box
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoPageScaffold(
          backgroundColor: CupertinoColors.systemGrey6,
          navigationBar: const CupertinoNavigationBar(
            previousPageTitle: 'Choose Grip Type',
            middle: Text('Add Grip Type'),
          ),
          child: SafeArea(child: AddGripTypeForm(gripTypes: gripTypes))),
    );
  }
}
