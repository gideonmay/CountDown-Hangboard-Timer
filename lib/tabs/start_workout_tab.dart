import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../screens/workout_timer_screen.dart';

/// A tab that enables the user to view workout details and begin their workout
class StartWorkoutTab extends StatelessWidget {
  final Workout workout;

  const StartWorkoutTab({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _workoutDetailRows(),
      const SizedBox(height: 20.0),
      _buildStartButton(context),
    ]);
  }

  /// A set of rows displaying details about the current workout
  Widget _workoutDetailRows() {
    return CupertinoListSection.insetGrouped(children: [
      CupertinoListTile(
        title: const Text('Workout Name'),
        trailing: Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              workout.name,
              textAlign: TextAlign.right,
              style: const TextStyle(color: CupertinoColors.systemGrey),
            ),
          ),
        ),
      ),
      CupertinoListTile(
        title: const Text('Description'),
        trailing: Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              workout.description,
              textAlign: TextAlign.right,
              style: const TextStyle(color: CupertinoColors.systemGrey),
            ),
          ),
        ),
      ),
      CupertinoListTile(
        title: const Text('Last Used'),
        trailing: Text(
          'Date Here',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
      CupertinoListTile(
        title: const Text('Workout Time'),
        trailing: Text(
          '42:00',
          style: TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
    ]);
  }

  /// Returns a start button widget if the stream of Grips for the current
  /// workout is not empty
  StreamBuilder<List<GripWithGripType>> _buildStartButton(
      BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    return StreamBuilder(
      stream: db.watchAllGripsWithType(workout.id),
      builder: (context, AsyncSnapshot<List<GripWithGripType>> snapshot) {
        final gripList = snapshot.data ?? List.empty();

        // Show message to user if they have not yet added any grips
        if (gripList.isEmpty) {
          return const Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: CupertinoButton.filled(
                      disabledColor: CupertinoColors.systemGrey4,
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      onPressed: null,
                      child: Text(
                        'Start Workout',
                      )),
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Grips must be added prior to starting workout',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          );
        }

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                onPressed: () => _navigateToWorkoutTimer(context, gripList),
                child: const Text(
                  'Start Workout',
                )),
          ),
        );
      },
    );
  }

  /// Navigates to screen to execute timer for this workout
  void _navigateToWorkoutTimer(
      BuildContext context, List<GripWithGripType> gripList) {
    // TODO: Prevent navigation if no grips have been added (may need StreamBUilder here)
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
          builder: (context) => WorkoutTimerScreen(
              title: 'Timer - ${workout.name}', gripList: gripList)),
    );
  }
}
