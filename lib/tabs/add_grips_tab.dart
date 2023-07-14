import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../widgets/reorderable_grip_list.dart';
import '../db/drift_database.dart';

/// A ListView that displays the sequence of grips for a given workout. Allows
/// the user to add, edit, remove, and re-sequence grips for their workout.
class AddGripsTab extends StatefulWidget {
  final Workout workout;

  const AddGripsTab({super.key, required this.workout});

  @override
  State<AddGripsTab> createState() => _AddGripsTabState();
}

class _AddGripsTabState extends State<AddGripsTab> {
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
          return Container();
        }

        final List<GripWithGripType> grips = snapshot.data ?? List.empty();

        if (grips.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Add grips to build your workout',
                style: TextStyle(
                    fontSize: 24.0, color: CupertinoColors.systemGrey2),
              ),
            ),
          );
        }

        return SafeArea(
            child: ReorderableGripList(
          gripList: grips,
          workout: widget.workout,
        ));
      },
    );
  }
}
