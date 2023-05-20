import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../widgets/app_header.dart';
import '../widgets/workout_details_row.dart';

/// A tab that enables the user to view workout details and begin their workout
class StartWorkoutTab extends StatelessWidget {
  final Workout workout;

  const StartWorkoutTab({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const AppHeader(title: 'Workout Details'),
        WorkoutDetailsRow(title: 'Name', body: workout.name),
        WorkoutDetailsRow(title: 'Description', body: workout.description),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  minimumSize: const Size.fromHeight(40)),
              onPressed: () {},
              child: const Text('Start Workout',
                  style: TextStyle(fontSize: 20.0))),
        ),
      ],
    );
  }
}
