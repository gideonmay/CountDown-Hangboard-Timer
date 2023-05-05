import 'package:flutter/material.dart';
import '../forms/add_grip_type_form.dart';

/// A screen that allows the user to create new grip types and delete existing
/// grips that they no longer want listed
class AddGripTypeScreen extends StatefulWidget {
  const AddGripTypeScreen({super.key});

  @override
  State<AddGripTypeScreen> createState() => _AddGripTypeScreenState();
}

class _AddGripTypeScreenState extends State<AddGripTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grip Type'),
      ),
      body: const AddGripTypeForm());
  }
}
