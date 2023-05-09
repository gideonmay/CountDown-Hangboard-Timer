import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reorderable_grip_list.dart';
import '../db/drift_database.dart';

/// A ListView that displays the sequence of grips for a given workout. Allows
/// the user to add, edit, remove, and re-sequence grips for their workout.
class GripSequencer extends StatefulWidget {
  final Workout workout;

  const GripSequencer({super.key, required this.workout});

  @override
  State<GripSequencer> createState() => _GripSequencerState();
}

class _GripSequencerState extends State<GripSequencer> {
  @override
  Widget build(BuildContext context) {
    return _buildGripList(context);
  }

  /// Returns a ListView widget that lists every grip for the current workout.
  /// The grips are sorted by their sequence number.
  StreamBuilder<List<GripWithGripType>> _buildGripList(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: db.watchAllGripsWithType(widget.workout.id),
      builder: (context, AsyncSnapshot<List<GripWithGripType>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final List<GripWithGripType> grips = snapshot.data ?? List.empty();

        if (grips.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Start adding grips to build your workout'),
            ),
          );
        }

        return ReorderableGripList(gripList: grips);
      },
    );
  }
}