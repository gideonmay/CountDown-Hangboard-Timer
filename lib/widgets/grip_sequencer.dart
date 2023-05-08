import 'package:countdown_app/extensions/string_casing_extension.dart';
import 'package:flutter/material.dart';
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

        return ReorderableListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              for (int index = 0; index < grips.length; index++)
                _listTileWithDivider(index, grips[index])
            ],
            onReorder: (oldIndex, newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = grips.removeAt(oldIndex);
              grips.insert(newIndex, item);

              // Modify sequenceNum for all grips that were reordered
              db.updateMultipleGripSeqNum(grips);
            });
      },
    );
  }

  /// Specifies details about the given grip
  Text _subitleText(GripWithGripType grip) {
    return Text(
        'Work: ${grip.entry.workSeconds}s, Rest: ${grip.entry.restSeconds}s, Break: ${grip.entry.breakMinutes}m${grip.entry.breakSeconds}s');
  }

  /// A ListTile with a divider
  Widget _listTileWithDivider(int index, GripWithGripType grip) {
    return Column(
      key: Key('$index'),
      children: [
        ListTile(
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4.0),
          leading: Text(
            (grip.entry.sequenceNum + 1).toString(),
            style: const TextStyle(fontSize: 20.0),
          ),
          title: Text(grip.gripType.name.toTitleCase(),
              overflow: TextOverflow.ellipsis),
          subtitle: _subitleText(grip),
          trailing: ReorderableDragStartListener(
              index: index, child: const Icon(Icons.drag_handle)),
        ),
        const Divider(
          indent: 70,
          endIndent: 5,
          thickness: 1.0,
          height: 1,
        ),
      ],
    );
  }
}
