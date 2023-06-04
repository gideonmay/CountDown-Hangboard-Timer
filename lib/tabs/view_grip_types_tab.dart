import 'package:flutter/material.dart';
import '../widgets/grip_types_list.dart';
import '../db/drift_database.dart';

/// A tab containing a list of existing grip types
class ViewGripTypesTab extends StatelessWidget {
  final List<GripTypeWithGripCount> gripTypes;

  /// The grip type that is currently chosen in the dropdown
  final int? currGripTypeID;

  const ViewGripTypesTab(
      {super.key, required this.gripTypes, this.currGripTypeID});

  @override
  Widget build(BuildContext context) {
    if (gripTypes.isEmpty) {
      return const Center(
          child: Text(
        'Any grip types you create will appear here',
        style: TextStyle(fontSize: 16.0),
      ));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            GripTypesList(gripTypes: gripTypes, currGripTypeID: currGripTypeID),
          ],
        ),
      ),
    );
  }
}
