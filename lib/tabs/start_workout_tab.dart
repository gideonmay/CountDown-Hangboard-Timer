import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/duration_status_list.dart';
import '../screens/workout_timer_screen.dart';
import '../utils/date_utils.dart';

/// A tab that enables the user to view workout details and begin their workout
class StartWorkoutTab extends StatefulWidget {
  final Workout workout;

  const StartWorkoutTab({super.key, required this.workout});

  @override
  State<StartWorkoutTab> createState() => _StartWorkoutTabState();
}

class _StartWorkoutTabState extends State<StartWorkoutTab> {
  DurationStatusList? _durationStatusList;
  int _numberOfGrips = 0;

  @override
  Widget build(BuildContext context) {
    return _builWorkoutDetailsList(context);
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
              widget.workout.name,
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
              widget.workout.description,
              textAlign: TextAlign.right,
              style: const TextStyle(color: CupertinoColors.systemGrey),
            ),
          ),
        ),
      ),
      CupertinoListTile(
        title: const Text('Last Used'),
        trailing: Text(
          _getLastUsedDate(),
          style: const TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
      CupertinoListTile(
        title: const Text('Workout Time'),
        trailing: Text(
          _getTotalTime(),
          style: const TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
      CupertinoListTile(
        title: const Text('Number of Grips'),
        trailing: Text(
          _numberOfGrips.toString(),
          style: const TextStyle(color: CupertinoColors.systemGrey),
        ),
      ),
    ]);
  }

  /// Returns a list of details about the workout with a button beneath that
  /// allows the user to start the workout
  StreamBuilder<List<GripWithGripType>> _builWorkoutDetailsList(
      BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    return StreamBuilder(
      stream: db.watchAllGripsWithType(widget.workout.id),
      builder: (context, AsyncSnapshot<List<GripWithGripType>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final gripList = snapshot.data ?? List.empty();

        // Show message to user if they have not yet added any grips
        if (gripList.isEmpty) {
          return ListView(children: [
            _workoutDetailRows(),
            const SizedBox(height: 20.0),
            _startWorkoutButtonDisabled(),
          ]);
        }

        _durationStatusList = WorkoutDurationStatusList(gripList: gripList);
        _numberOfGrips = gripList.length;

        return ListView(children: [
          _workoutDetailRows(),
          const SizedBox(height: 20.0),
          _startWorkoutButton(gripList),
        ]);
      },
    );
  }

  /// A disabled start button with a message indicating why button is disabled
  Widget _startWorkoutButtonDisabled() {
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

  /// The button that allows the user to navigate to the timer screen
  Widget _startWorkoutButton(List<GripWithGripType> gripList) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CupertinoButton.filled(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            onPressed: () {
              _updateLastUsedDate();
              _navigateToWorkoutTimer(context);
            },
            child: const Text(
              'Start Workout',
            )),
      ),
    );
  }

  /// Returns a string representation of the last date this workout was used
  String _getLastUsedDate() {
    if (widget.workout.lastUsedDate != null) {
      return formattedDate(widget.workout.lastUsedDate);
    }

    return '-';
  }

  /// Returns a string representation of the total length of the workout
  String _getTotalTime() {
    if (_durationStatusList != null) {
      final duration = Duration(seconds: _durationStatusList!.totalSeconds);
      int minutes = duration.inMinutes;
      int seconds = duration.inSeconds % 60;
      return '$minutes:${(seconds).toString().padLeft(2, '0')}';
    }

    return '-';
  }

  /// Updates the laste used date for the current workout
  void _updateLastUsedDate() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.updateWorkoutLastUsed(widget.workout.id, DateTime.now());
  }

  /// Navigates to screen to execute timer for this workout
  void _navigateToWorkoutTimer(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => WorkoutTimerScreen(
              title: 'Timer - ${widget.workout.name}',
              durationStatusList: _durationStatusList!)),
    );
  }
}
