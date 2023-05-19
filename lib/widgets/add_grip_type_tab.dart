import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../forms/add_grip_type_form.dart';

/// A tab containing a form to add a grip type
class AddGripTypeTab extends StatelessWidget {
  final List<GripTypeWithGripCount> gripTypes;

  const AddGripTypeTab({super.key, required this.gripTypes});

  @override
  Widget build(BuildContext context) {
    return AddGripTypeForm(gripTypes: gripTypes);
  }
}