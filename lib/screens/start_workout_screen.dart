import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../screens/add_grip_screen.dart';
import '../widgets/grip_sequencer.dart';
import '../widgets/workout_details_row.dart';

/// A screen that displays the details of a workout and allows the user to
/// add, edit, and organize grips for their workout
class StartWorkoutScreen extends StatelessWidget {
  final Workout workout;

  const StartWorkoutScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Workout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Workout Details',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
            ),
            WorkoutDetailsRow(title: 'Name', body: workout.name),
            WorkoutDetailsRow(title: 'Description', body: workout.description),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {},
                  child: const Text('Start',
                      style: TextStyle(fontSize: 20.0))),
            ),
            const Divider(thickness: 1.0, indent: 5.0, endIndent: 5.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Grip Sequence',
                  style:
                      TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                  'Use this area to add and sequence grips for your workout'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GripSequencer(
                workout: workout,
              ),
            ),
            Center(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary),
                    onPressed: () => _navigateToAddGrip(context, workout),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Grip'))),
          ],
        ),
      ),
    );
  }

  /// Navigates to the AddGripScreen widget
  static _navigateToAddGrip(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddGripScreen(workout: workout)),
    );
  }
}
