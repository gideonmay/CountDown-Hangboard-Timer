import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/grip_details_form.dart';
import '../utils/navigation_utils.dart';

/// A screen that allows the user to add a new grip to the workout
class AddGripScreen extends StatefulWidget {
  final Workout workout;

  const AddGripScreen({super.key, required this.workout});

  @override
  State<AddGripScreen> createState() => _AddGripScreenState();
}

class _AddGripScreenState extends State<AddGripScreen> {
  final gripDTO = GripDTO.standard();

  /// Adds the grip defined by the gripDTO to the database
  void _createGrip() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.addGrip(widget.workout.id, gripDTO);

    // Navigate back to Start Workout page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: widget.workout.name,
          middle: const Text('Add Grip'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.ellipsis_circle),
            onPressed: () => _showActionSheet(context),
          ),
        ),
        child: SafeArea(
            child: GripDetailsForm(
          gripDTO: gripDTO,
          gripTypeStream: db.watchAllGripTypes(),
          buttonText: 'Submit',
          onFormSaved: _createGrip,
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
              navigateToGripTypeScreen(context);
              Navigator.pop(context);
            },
            child: const Text('Edit Grip Types'),
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

  // TODO: Show this when user first visits this screen
  // Future<String?> _showHelperDialog(BuildContext context) {
  //   return showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => const HelperDialog(
  //           title: 'Adding Grips',
  //           body:
  //               'Specify the number of sets and reps, and the work, rest, and break durations for this grip.\n\n'
  //               'A grip type is also required for each grip. This is a name used to describe a grip which can be reused among other grips.'));
  // }
}
