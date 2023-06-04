import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../tabs/edit_grips_tab.dart';
import '../tabs/start_workout_tab.dart';
import '../widgets/helper_dialog.dart';

/// A screen that displays the details of a workout and allows the user to
/// add, edit, and organize grips for their workout
class WorkoutDetailScreen extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(workout.name),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.info),
                    ),
                    Text('Details')
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.edit_outlined),
                    ),
                    Text('Edit Grips')
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          StartWorkoutTab(workout: workout),
          EditGripsTab(workout: workout),
        ]),
      ),
    );
  }

  // TODO: Only show when user first visits this screen
  Future<String?> _showHelperDialog(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => HelperDialog(
            title: 'Editing Grips',
            body:
                'To edit the order of a grip, tap and hold the grip then drag it to the desired position. Alternatively, move the grip using the drag handle on the right.',
            image: Image.asset('assets/gifs/grip_sequence_demo.gif')));
  }
}
