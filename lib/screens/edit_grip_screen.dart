import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/grip_details_form.dart';

/// A creen with a form to edit the details of a given grip
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
      gripDTO.sets = widget.grip.entry.setCount;
      gripDTO.reps = widget.grip.entry.repCount;
      gripDTO.workSeconds = widget.grip.entry.workSeconds;
      gripDTO.restSeconds = widget.grip.entry.restSeconds;
      gripDTO.breakMinutes = widget.grip.entry.breakMinutes;
      gripDTO.breakSeconds = widget.grip.entry.breakSeconds;
      gripDTO.lastBreakMinutes = widget.grip.entry.lastBreakMinutes;
      gripDTO.lastBreakSeconds = widget.grip.entry.lastBreakSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Grip'),
        ),
        body: SafeArea(
            child: GripDetailsForm(
                gripDTO: gripDTO,
                gripTypeStream: db.watchAllGripTypes(),
                buttonText: 'Save Changes',
                onFormSaved: _updateGrip)));
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
