import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../forms/workout_form.dart';
import '../models/workout_dto.dart';

/// A layout with a form to allow users to create new workouts
class AddWorkoutScreen extends StatefulWidget {
  const AddWorkoutScreen({super.key});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  final _workoutDTO = WorkoutDTO.blank();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: 'Workouts',
          middle: Text('Add Workout'),
        ),
        child: WorkoutForm(
            workoutDTO: _workoutDTO,
            onFormSaved: _createWorkout,
            buttonText: 'Submit'),
      ),
    );
  }

  /// Adds the workout to the database then navigates back to My Workouts screen
  void _createWorkout() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.addWorkout(_workoutDTO);

    // Navigate back to My Workouts page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
