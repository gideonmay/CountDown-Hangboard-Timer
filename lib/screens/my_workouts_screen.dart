import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'create_workout_screen.dart';
import 'edit_workout_screen.dart';
import 'workout_detail_screen.dart';
import '../db/drift_database.dart';
import '../models/workout_dto.dart';

/// A screen that lists all of the workouts available in the database
class MyWorkoutsScreen extends StatefulWidget {
  const MyWorkoutsScreen({super.key});

  @override
  State<MyWorkoutsScreen> createState() => _MyWorkoutsScreenState();
}

class _MyWorkoutsScreenState extends State<MyWorkoutsScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CustomScrollView(slivers: <Widget>[
      CupertinoSliverNavigationBar(
        largeTitle: const Text('My Workouts'),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.add),
            onPressed: () => _navigateToCreateWorkout(context)),
      ),
      SliverSafeArea(
          top: false,
          minimum: const EdgeInsets.only(top: 0),
          sliver: SliverToBoxAdapter(
            child: _buildWorkoutList(context),
          ))
    ]));
  }

  /// Navigates to the CreateWorkoutScreen widget
  static _navigateToCreateWorkout(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const CreateWorkoutScreen()),
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

        return CupertinoListSection(
          topMargin: 0,
          dividerMargin: 50,
          children: [for (var workout in workouts) _slideableListTile(workout)],
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
          backgroundColor: CupertinoColors.systemIndigo,
          foregroundColor: CupertinoColors.white,
          icon: CupertinoIcons.pen,
          label: 'Edit',
        ),
        SlidableAction(
          onPressed: (context) => _showAlertDialog(context, workout),
          backgroundColor: CupertinoColors.systemRed,
          foregroundColor: CupertinoColors.white,
          icon: CupertinoIcons.delete,
          label: 'Delete',
        ),
      ]),
      child: CupertinoListTile(
        leading: CupertinoButton(
          onPressed: () {},
          child: const Icon(CupertinoIcons.play_arrow_solid,
              size: 35.0, color: CupertinoColors.activeGreen),
        ),
        leadingSize: 65.0,
        title: Text(workout.name, overflow: TextOverflow.ellipsis),
        subtitle: Text(workout.description,
            maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Last Used:', style: TextStyle(fontSize: 14.0)),
            Text(' ${_formattedDate(workout.lastUsedDate)}',
                style: const TextStyle(fontSize: 14.0)),
          ],
        ),
        onTap: () => _navigateToStartWorkout(context, workout),
      ),
    );
  }

  /// Navigates to the EditWorkoutScreen widget
  static _navigateToEditWorkout(BuildContext context, Workout workout) {
    final workoutDTO = WorkoutDTO(
        id: workout.id, name: workout.name, description: workout.description);

    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => EditWorkoutScreen(workoutDTO: workoutDTO)),
    );
  }

  /// Navigates to the StartWorkoutScreen widget
  static _navigateToStartWorkout(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      CupertinoPageRoute(
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
  String _formattedDate(DateTime? dateTime) {
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
