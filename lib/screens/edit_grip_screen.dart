import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/add_grip_form.dart';
import '../widgets/helper_dialog.dart';

class EditGripScreen extends StatefulWidget {
  final GripWithGripType grip;

  const EditGripScreen({super.key, required this.grip});

  @override
  State<EditGripScreen> createState() => _EditGripScreenState();
}

class _EditGripScreenState extends State<EditGripScreen> {
  final GripDTO gripDTO =
      GripDTO(gripName: '', lastBreakMinutes: 0, lastBreakSeconds: 30);

  @override
  void initState() {
    super.initState();
    _initializeGripDTO();
  }

  /// Initializes the gripDTO with the given grip for this widget
  void _initializeGripDTO() {
    setState(() {
      gripDTO.gripTypeID = widget.grip.entry.gripType;
      gripDTO.gripName = widget.grip.gripType.name;
      gripDTO.edgeSize = widget.grip.entry.edgeSize;
      gripDTO.sets = widget.grip.entry.setCount.toDouble();
      gripDTO.reps = widget.grip.entry.repCount.toDouble();
      gripDTO.workSeconds = widget.grip.entry.workSeconds.toDouble();
      gripDTO.restSeconds = widget.grip.entry.restSeconds.toDouble();
      gripDTO.breakMinutes = widget.grip.entry.breakMinutes.toDouble();
      gripDTO.breakSeconds = widget.grip.entry.breakSeconds.toDouble();
      gripDTO.lastBreakMinutes = widget.grip.entry.lastBreakMinutes.toDouble();
      gripDTO.lastBreakSeconds = widget.grip.entry.lastBreakSeconds.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Grip'),
        ),
        body: SafeArea(
            child: AddGripForm(gripDTO: gripDTO, onFormSaved: _updateGrip)));
  }

  /// Updates the grip using data kept in the gripDTO
  void _updateGrip() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.updateGrip(widget.grip.entry.id, gripDTO);

    // Navigate back to Start Workout page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
