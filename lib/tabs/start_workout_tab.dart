import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';

/// A tab that enables the user to view workout details and begin their workout
class StartWorkoutTab extends StatelessWidget {
  final Workout workout;

  const StartWorkoutTab({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      _workoutDetailRows(),
      const SizedBox(height: 20.0),
      _startWorkoutButton(),
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
