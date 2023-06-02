import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/grip_details_form.dart';

enum PopupItem { delete, duplicate }

/// A screen with a form to edit the details of a given grip
class EditGripScreen extends StatefulWidget {
  final GripWithGripType grip;

  const EditGripScreen({super.key, required this.grip});

  @override
  State<EditGripScreen> createState() => _EditGripScreenState();
}

class _EditGripScreenState extends State<EditGripScreen> {
  final GripDTO gripDTO = GripDTO.standard();

  @override
  void initState() {
    super.initState();
    _initializeGripDTO();
  }

  /// Initializes the gripDTO with the given grip for this widget
  void _initializeGripDTO() {
    setState(() {
      gripDTO.gripTypeID = widget.grip.entry.gripType;
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
          actions: [_popupMenu()],
        ),
        body: SafeArea(
            child: GripDetailsForm(
                gripDTO: gripDTO,
                gripTypeStream: db.watchAllGripTypes(),
                buttonText: 'Save Changes',
                onFormSaved: _updateGrip)));
  }

  /// A popup menu displaying options to delete or duplicate the current grip
  Widget _popupMenu() {
    return PopupMenuButton<PopupItem>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupItem>>[
        PopupMenuItem<PopupItem>(
          value: PopupItem.duplicate,
          onTap: () => _duplicateGrip(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 150,
                  child: Text('Duplicate', style: TextStyle(fontSize: 20.0))),
              Icon(
                Icons.content_copy,
                color: Colors.grey,
              )
            ],
          ),
        ),
        PopupMenuItem<PopupItem>(
          value: PopupItem.delete,
          onTap: () => _deleteGrip(),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  width: 150,
                  child: Text('Delete', style: TextStyle(fontSize: 20.0))),
              Icon(
                Icons.delete,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ],
    );
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

  /// Deletes the current grip from the database
  void _deleteGrip() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.deleteGrip(widget.grip.entry);

    // Navigate back to Start Workout page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  /// Makes a duplicate of the current grip
  void _duplicateGrip() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.addDuplicateGrip(widget.grip.entry);

    // Navigate back to Start Workout page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
