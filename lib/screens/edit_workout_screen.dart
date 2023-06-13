import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../forms/workout_form.dart';
import '../models/workout_dto.dart';

/// A layout with a form that allows the details of a workout to be edited
class EditWorkoutScreen extends StatefulWidget {
  final WorkoutDTO workoutDTO;

  const EditWorkoutScreen({super.key, required this.workoutDTO});

  @override
  State<EditWorkoutScreen> createState() => _EditWorkoutScreenState();
}

class _EditWorkoutScreenState extends State<EditWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGrey6,
      navigationBar: const CupertinoNavigationBar(
        previousPageTitle: 'Workouts',
        middle: Text('Add Workout'),
      ),
      child: WorkoutForm(
          workoutDTO: widget.workoutDTO,
          onFormSaved: _updateWorkout,
          buttonText: 'Save Changes'),
    );
  }

  /// Edits workout in the database then navigates back to My Workouts screen
  void _updateWorkout() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.updateWorkout(widget.workoutDTO.id!, widget.workoutDTO.name!,
        widget.workoutDTO.description!);

    // Navigate back to My Workouts page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
