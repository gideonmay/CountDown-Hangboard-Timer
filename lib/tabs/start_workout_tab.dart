import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../widgets/workout_details_row.dart';

/// A tab that enables the user to view workout details and begin their workout
class StartWorkoutTab extends StatelessWidget {
  final Workout workout;

  const StartWorkoutTab({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          WorkoutDetailsRow(title: 'Workout Name', body: workout.name),
          WorkoutDetailsRow(title: 'Description', body: workout.description),
          const WorkoutDetailsRow(title: 'Last Used', body: 'Some Date'),
          const WorkoutDetailsRow(title: 'Total Time', body: '20:00'),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    minimumSize: const Size.fromHeight(40)),
                onPressed: () {},
                child: const Text('Start Workout',
                    style: TextStyle(fontSize: 20.0))),
          ),
        ],
      ),
    );
  }
}
