import 'package:flutter/material.dart';

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
        // body: SingleChildScrollView(child: AddGripForm(gripDTO: gripDTO))
        );
  }
}