import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../forms/grip_details_form.dart';

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
        ),
        child: SafeArea(
            child: GripDetailsForm(
          currentPageTitle: 'Add Grip',
          gripDTO: gripDTO,
          gripTypeStream: db.watchAllGripTypesWithCount(),
          buttonText: 'Submit',
          onFormSaved: _createGrip,
        )));
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
