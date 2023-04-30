import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
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
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400, width: 1.0),
          borderRadius: const BorderRadius.all(Radius.circular(10.0))),
      child: _buildGripList(context),
    );
  }

  /// Returns a ListView widget that lists every grip for the current workout.
  /// The grips are sorted by their sequence number.
  StreamBuilder<List<Grip>> _buildGripList(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: db.watchGripsForWorkout(widget.workout.id),
      builder: (context, AsyncSnapshot<List<Grip>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final grips = snapshot.data ?? List.empty();

        if (grips.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Start adding grips to build your workout'),
            ),
          );
        }

        return ListView.builder(
          itemCount: grips.length,
          itemBuilder: (context, index) {
            final grip = grips[index];
            return _slideableListTile(grip);
          },
        );
      },
    );
  }

  /// Returns a ListTile that can be slid left to reveal Edit and Delete buttons
  Widget _slideableListTile(Grip grip) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {},//(context) => _navigateToEditWorkout(context, workout),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          icon: Icons.edit_outlined,
          label: 'Edit',
        ),
        SlidableAction(
          onPressed: (context) {},//(context) => _dialogBuilder(context, workout),
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: ListTile(
        title: Text('grip name here', overflow: TextOverflow.ellipsis),
        // subtitle: Text(workout.description,
        //     maxLines: 1, overflow: TextOverflow.ellipsis),
        // trailing: Text('Last Used: ${_getFormattedDate(workout.lastUsedDate)}'),
        // onTap: () => _navigateToStartWorkout(context, workout),
      ),
    );
  }
}
