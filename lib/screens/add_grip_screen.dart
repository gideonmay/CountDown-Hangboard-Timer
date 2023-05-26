import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/grip_details_form.dart';
import '../widgets/helper_dialog.dart';

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
    // Get the maximum sequence number for all grips in the curent workout
    int maxSeqNum = await db.getMaxGripSeqNum(widget.workout.id) ?? 0;

    await db.addGrip(GripsCompanion.insert(
        workout: widget.workout.id,
        gripType: gripDTO.gripTypeID!,
        edgeSize: Value(gripDTO.edgeSize),
        setCount: gripDTO.sets.toInt(),
        repCount: gripDTO.reps.toInt(),
        workSeconds: gripDTO.workSeconds.toInt(),
        restSeconds: gripDTO.restSeconds.toInt(),
        breakMinutes: gripDTO.breakMinutes.toInt(),
        breakSeconds: gripDTO.breakSeconds.toInt(),
        lastBreakMinutes: gripDTO.lastBreakMinutes.toInt(),
        lastBreakSeconds: gripDTO.lastBreakSeconds.toInt(),
        sequenceNum: maxSeqNum + 1)); // Add 1 so new grip has largest seq num

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
          actions: [
            IconButton(
                onPressed: () => _showHelperDialog(context),
                icon: const Icon(Icons.help))
          ],
        ),
        body: SafeArea(
            child: GripDetailsForm(
          gripDTO: gripDTO,
          buttonText: 'Submit',
          onFormSaved: _createGrip,
        )));
  }

  Future<String?> _showHelperDialog(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => const HelperDialog(
            title: 'Adding Grips',
            body:
                'Specify the number of sets and reps, and the work, rest, and break durations for this grip.\n\n'
                'A grip type is also required for each grip. This is a name used to describe a grip which can be reused among other grips.'));
  }
}
