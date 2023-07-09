import 'package:countdown_app/models/grip_type_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/grip_details_form.dart';

/// A screen with a form to edit the details of a given grip
class EditGripScreen extends StatefulWidget {
  final GripWithGripType grip;
  final Workout workout;

  const EditGripScreen({super.key, required this.grip, required this.workout});

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
      gripDTO.gripTypeName = widget.grip.gripType.name;
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

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: widget.workout.name,
          middle: const Text('Edit Grip'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.ellipsis_circle),
            onPressed: () => _showActionSheet(context),
          ),
        ),
        child: SafeArea(
            child: GripDetailsForm(
          currentPageTitle: 'Edit Grip',
          gripDTO: gripDTO,
          gripTypeStream: db.watchAllGripTypesWithCount(),
          buttonText: 'Save Changes',
          onFormSaved: _updateGrip,
          onGripTypeChanged: _updateGripType,
        )));
  }

  /// Shows an action sheet allowing user navigate to screen to edit grip types
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              _duplicateGrip();
              Navigator.pop(context);
            },
            child: const Text('Duplicate Grip'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              _deleteGrip();
              Navigator.pop(context);
            },
            child: const Text('Delete Grip'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
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

  /// Updates the grip type of the grip
  void _updateGripType(GripTypeDTO newGripType) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.updateGripType(widget.grip.entry.id, newGripType.id!);
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
