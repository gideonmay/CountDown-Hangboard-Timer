import 'package:flutter/material.dart';
import 'grip_types_list.dart';
import 'app_header.dart';
import '../db/drift_database.dart';

/// A tab containing a list of existing grip types
class ViewGripTypesTab extends StatelessWidget {
  final List<GripTypeWithGripCount> gripTypes;

  const ViewGripTypesTab({super.key, required this.gripTypes});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppHeader(title: 'Grip Types'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'All grip types can be viewed and delete here',
                textAlign: TextAlign.center,
              ),
            ),
            GripTypesList(gripTypes: gripTypes),
          ],
        ),
      ),
    );
  }
}
