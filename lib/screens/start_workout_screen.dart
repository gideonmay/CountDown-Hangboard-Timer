import 'package:flutter/material.dart';
import '../db/drift_database.dart';

class StartWorkoutScreen extends StatefulWidget {
  final Workout workout;

  const StartWorkoutScreen({super.key, required this.workout});

  @override
  State<StartWorkoutScreen> createState() => _StartWorkoutScreenState();
}

class _StartWorkoutScreenState extends State<StartWorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Start Workout'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.workout.name, style: TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(widget.workout.description, style: const TextStyle(fontSize: 16.0),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Grip Sequence', style: TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Use the below area to add and organize grips for this workout'),
          ),
        ],
      ),
    );
  }
}
