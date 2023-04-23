import 'package:flutter/material.dart';
import '../widgets/create_workout_form.dart';

/// Provides a layout with a form to allow users to create new workouts
class CreateWorkoutScreen extends StatelessWidget {
  const CreateWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a Workout'),
      ),
      body: const CreateWorkoutForm(),
    );
  }
}
