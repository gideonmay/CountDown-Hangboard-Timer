import 'package:countdown_app/db/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_workout_screen.dart';

/// A screen that lists all of the workouts available in the database
class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({super.key});

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen> {
  /// Navigates to the countdown timer screen
  static navigateToBuildWorkout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateWorkoutScreen()),
    );
  }

  /// Returns a ListView widget that lists each workout in the database. If the
  /// data changes, then a new widget is returned with fresh data.
  StreamBuilder<List<Workout>> _buildWorkoutList(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: db.watchAllWorkouts(),
      builder: (context, AsyncSnapshot<List<Workout>> snapshot) {
        final workouts = snapshot.data ?? List.empty();

        if (workouts.isEmpty) {
          return const Center(
            child: Text('Created workouts will show up here'),
          );
        }

        return ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return ListTile(
              title: Text(workout.name),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
      ),
      body: _buildWorkoutList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToBuildWorkout(context);
        },
        tooltip: 'Add Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}
