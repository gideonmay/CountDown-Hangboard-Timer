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
          gripTypeStream: db.watchAllGripTypes(),
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
