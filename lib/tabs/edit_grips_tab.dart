import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/reorderable_grip_list.dart';
import '../db/drift_database.dart';
import '../screens/add_grip_screen.dart';

/// A ListView that displays the sequence of grips for a given workout. Allows
/// the user to add, edit, remove, and re-sequence grips for their workout.
class EditGripsTab extends StatefulWidget {
  final Workout workout;

  const EditGripsTab({super.key, required this.workout});

  @override
  State<EditGripsTab> createState() => _EditGripsTabState();
}

class _EditGripsTabState extends State<EditGripsTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildGripList(context),
            Center(
                child: ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () =>
                        _navigateToAddGrip(context, widget.workout),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Grip'))),
          ],
        ),
      ),
    );
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
              padding: EdgeInsets.all(16.0),
              child: Text('Start adding grips to build your workout'),
            ),
          );
        }

        return ReorderableGripList(gripList: grips);
      },
    );
  }

  /// Navigates to the AddGripScreen widget
  static _navigateToAddGrip(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddGripScreen(workout: workout)),
    );
  }
}
