import 'package:countdown_app/db/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'create_workout_screen.dart';

/// A screen that lists all of the workouts available in the database
class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({super.key});

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen> {
  /// Navigates to the countdown timer screen
  static _navigateToBuildWorkout(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateWorkoutScreen()),
    );
  }

  /// Returns the given datetime formatted as 'MM/DD/YYYY'. If dateTime is null,
  /// then returns 'Never'
  String _getFormattedDate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Never';
    }

    return DateFormat('MM/dd/yyyy').format(dateTime);
  }

  /// Deletes the given workout from the database
  void _deleteWorkout(BuildContext context, Workout workout) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.deleteWorkout(workout);
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
            return _slideableListTile(workout);
          },
        );
      },
    );
  }

  /// Returns a ListTile that can be slid left to reveal Edit and Delete buttons
  Widget _slideableListTile(Workout workout) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          icon: Icons.edit_outlined,
          label: 'Edit',
        ),
        SlidableAction(
          onPressed: (context) {
            _deleteWorkout(context, workout);
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: ListTile(
        title: Text(workout.name, overflow: TextOverflow.ellipsis),
        subtitle: Text(workout.description,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text('Last Used: ${_getFormattedDate(workout.lastUsedDate)}'),
      ),
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
          _navigateToBuildWorkout(context);
        },
        tooltip: 'Add Workout',
        child: const Icon(Icons.add),
      ),
    );
  }
}
