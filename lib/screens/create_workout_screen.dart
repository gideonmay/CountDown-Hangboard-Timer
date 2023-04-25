import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../widgets/workout_form.dart';
import '../models/workout_dto.dart';

/// Provides a layout with a form to allow users to create new workouts
class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final _workoutDTO = WorkoutDTO.blank();

  /// Adds the workout to the database then navigates back to My Workouts screen
  void _createWorkout() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.addWorkout(WorkoutsCompanion.insert(
        name: _workoutDTO.name!, description: _workoutDTO.description!));

    // Navigate back to My Workouts page
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Workout'),
      ),
      body: WorkoutForm(
          workoutDTO: _workoutDTO,
          onFormSaved: _createWorkout,
          buttonText: 'Submit'),
    );
  }
}
