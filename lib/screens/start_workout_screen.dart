import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../widgets/edit_grips_tab.dart';
import '../widgets/start_workout_tab.dart';

/// A screen that displays the details of a workout and allows the user to
/// add, edit, and organize grips for their workout
class StartWorkoutScreen extends StatelessWidget {
  final Workout workout;

  const StartWorkoutScreen({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(workout.name),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(3.0),
                      child: Icon(Icons.play_arrow),
                    ),
                    Text('Start')
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
}
