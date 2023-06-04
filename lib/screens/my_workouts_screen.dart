import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'create_workout_screen.dart';
import 'edit_workout_screen.dart';
import 'workout_detail_screen.dart';
import '../db/drift_database.dart';
import '../models/workout_dto.dart';
import '../theme/color_theme.dart';
import '../widgets/app_divider.dart';

/// A screen that lists all of the workouts available in the database
class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({super.key});

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
      ),
      body: _buildWorkoutList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToCreateWorkout(context);
        },
        tooltip: 'Add Workout',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Navigates to the CreateWorkoutScreen widget
  static _navigateToCreateWorkout(BuildContext context) {
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final workouts = snapshot.data ?? List.empty();

        if (workouts.isEmpty) {
          return const Center(
            child: Text('Add a workout to begin'),
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
          onPressed: (context) => _navigateToEditWorkout(context, workout),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          icon: Icons.edit_outlined,
          label: 'Edit',
        ),
        SlidableAction(
          onPressed: (context) => _showAlertDialog(context, workout),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: Column(
        children: [
          ListTile(
            leading: IconButton(
              icon: const Icon(Icons.play_arrow,
                  size: 40.0, color: AppColorTheme.green),
              onPressed: () {},
            ),
            title: Text(workout.name, overflow: TextOverflow.ellipsis),
            subtitle: Text(workout.description,
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Last Used:'),
                Text(' ${_getFormattedDate(workout.lastUsedDate)}'),
              ],
            ),
            onTap: () => _navigateToStartWorkout(context, workout),
          ),
          const AppDivider(indent: 80, height: 1.0),
        ],
      ),
    );
  }

  /// Navigates to the EditWorkoutScreen widget
  static _navigateToEditWorkout(BuildContext context, Workout workout) {
    final workoutDTO = WorkoutDTO(
        id: workout.id, name: workout.name, description: workout.description);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditWorkoutScreen(workoutDTO: workoutDTO)),
    );
  }

  /// Navigates to the StartWorkoutScreen widget
  static _navigateToStartWorkout(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WorkoutDetailScreen(workout: workout)),
    );
  }

  /// Shows a dialog box to confirm workout deletion
  Future<void> _showAlertDialog(BuildContext context, Workout workout) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Are you sure?'),
        content: Text(
            'The workout \'${workout.name}\' will be permanently deleted.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              _deleteWorkout(context, workout);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
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
}
