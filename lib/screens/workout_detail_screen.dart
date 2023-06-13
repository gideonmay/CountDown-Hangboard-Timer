import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../tabs/edit_grips_tab.dart';
import '../tabs/start_workout_tab.dart';
import 'add_grip_screen.dart';

/// A screen that displays the details of a workout and allows the user to
/// add, edit, and organize grips for their workout
class WorkoutDetailScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  State<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();

  /// Navigates to the AddGripScreen widget
  static _navigateToAddGrip(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AddGripScreen(workout: workout)),
    );
  }
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  int _sliderOption = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.white,
        navigationBar: _navBar(context),
        child: SafeArea(
          child: Column(
            children: [
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _slidingSegmentedControl(),
              )),
              Expanded(child: _screenOption()),
            ],
          ),
        ));
  }

  /// A segmented control to switch between 'Start Workout' and 'Edit Grips'
  /// screens
  Widget _slidingSegmentedControl() {
    return CupertinoSlidingSegmentedControl(
      backgroundColor: CupertinoColors.systemGrey4,
      groupValue: _sliderOption,
      children: const <int, Widget>{
        0: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Start Workout',
            style: TextStyle(color: CupertinoColors.black, fontSize: 14.0),
          ),
        ),
        1: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            'Edit Grips',
            style: TextStyle(color: CupertinoColors.black, fontSize: 14.0),
          ),
        ),
      },
      onValueChanged: (int? value) {
        if (value != null) {
          setState(() {
            _sliderOption = value;
          });
        }
      },
    );
  }

  /// Displays the screen corresponding to the chosen slider option
  Widget _screenOption() {
    if (_sliderOption == 0) {
      return StartWorkoutTab(workout: widget.workout);
    }

    return EditGripsTab(workout: widget.workout);
  }

  /// Returns a navigation bar that optionally shows a button to add a grip
  CupertinoNavigationBar _navBar(BuildContext context) {
    if (_sliderOption == 1) {
      return CupertinoNavigationBar(
        previousPageTitle: 'Workouts',
        middle: Text(widget.workout.name),
        trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () =>
                WorkoutDetailScreen._navigateToAddGrip(context, widget.workout),
            child: const Icon(CupertinoIcons.add)),
      );
    }

    return CupertinoNavigationBar(
      previousPageTitle: 'Workouts',
      middle: Text(widget.workout.name),
    );
  }

  // TODO: Only show when user first visits this screen
  // Future<String?> _showHelperDialog(BuildContext context) {
  //   return showDialog<String>(
  //       context: context,
  //       builder: (BuildContext context) => HelperDialog(
  //           title: 'Editing Grips',
  //           body:
  //               'To edit the order of a grip, tap and hold the grip then drag it to the desired position. Alternatively, move the grip using the drag handle on the right.',
  //           image: Image.asset('assets/gifs/grip_sequence_demo.gif')));
  // }
}
