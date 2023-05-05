import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/add_grip_form.dart';

/// A screen that allows the user to add a new grip to the workout
class AddGripScreen extends StatefulWidget {
  final Workout workout;

  const AddGripScreen({super.key, required this.workout});

  @override
  State<AddGripScreen> createState() => _AddGripScreenState();
}

class _AddGripScreenState extends State<AddGripScreen> {
  final gripDTO =
      GripDTO(gripName: '', lastBreakMinutes: 0, lastBreakSeconds: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Grip'),
        ),
        body: SingleChildScrollView(child: AddGripForm(gripDTO: gripDTO)));
  }
}
