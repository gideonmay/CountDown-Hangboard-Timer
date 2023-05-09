import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  /// Adds the grip defined by the gripDTO to the database
  void _createGrip() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    // Get the total count of grips for the current workout
    int gripCount = await db.getGripCount(widget.workout.id) ?? 0;

    await db.addGrip(GripsCompanion.insert(
        workout: widget.workout.id,
        gripType: gripDTO.gripTypeID!,
        setCount: gripDTO.sets.toInt(),
        repCount: gripDTO.reps.toInt(),
        workSeconds: gripDTO.workSeconds.toInt(),
        restSeconds: gripDTO.restSeconds.toInt(),
        breakMinutes: gripDTO.breakMinutes.toInt(),
        breakSeconds: gripDTO.breakSeconds.toInt(),
        lastBreakMinutes: gripDTO.lastBreakMinutes.toInt(),
        lastBreakSeconds: gripDTO.lastBreakSeconds.toInt(),
        sequenceNum: gripCount));

    // Navigate back to Start Workout page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Grip'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: AddGripForm(
          gripDTO: gripDTO,
          onFormSaved: _createGrip,
        ))));
  }
}
