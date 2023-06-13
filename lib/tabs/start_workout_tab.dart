import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../widgets/workout_details_row.dart';

/// A tab that enables the user to view workout details and begin their workout
class StartWorkoutTab extends StatelessWidget {
  final Workout workout;

  const StartWorkoutTab({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _workoutDetailRows(),
        _startWorkoutButton(),
      ],
    );
  }

  /// A set of rows displaying details about the current workout
  Widget _workoutDetailRows() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Column(children: [
        WorkoutDetailsRow(title: 'Workout Name', body: workout.name),
        WorkoutDetailsRow(title: 'Description', body: workout.description),
        const WorkoutDetailsRow(title: 'Last Used', body: 'Some Date'),
        const WorkoutDetailsRow(title: 'Total Time', body: '20:00'),
      ]),
    );
  }

  Widget _startWorkoutButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            onPressed: () {},
            child: const Text(
              'Start Workout',
            )),
      ),
    );
  }
}
