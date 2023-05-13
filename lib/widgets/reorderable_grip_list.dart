import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';

/// A ReorderableListView that enables the user to tap and drag grips to
/// reorder the list of grips for the current workout
class ReorderableGripList extends StatefulWidget {
  final List<GripWithGripType> gripList;

  const ReorderableGripList({super.key, required this.gripList});

  @override
  State<ReorderableGripList> createState() => _ReorderableGripListState();
}

class _ReorderableGripListState extends State<ReorderableGripList> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return ReorderableListView(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          for (int index = 0; index < widget.gripList.length; index++)
            _listTileWithDivider(index, widget.gripList[index])
        ],
        onReorder: (oldIndex, newIndex) {
          // Remove the grip and reinsert it at the new index
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final grip = widget.gripList.removeAt(oldIndex);
            widget.gripList.insert(newIndex, grip);
          });

          // Modify sequenceNum in database for all grips that were reordered
          db.updateMultipleGripSeqNum(widget.gripList);
        });
  }

  /// Specifies details about the given grip
  Text _subitleText(GripWithGripType grip) {
    return Text(
      'Sets ${grip.entry.setCount} | Reps ${grip.entry.repCount} | W ${grip.entry.workSeconds}s | R ${grip.entry.restSeconds}s | B ${grip.entry.breakMinutes}m${grip.entry.breakSeconds}s',
      style: const TextStyle(fontSize: 12.0),
    );
  }

  /// A ListTile with a divider
  Widget _listTileWithDivider(int index, GripWithGripType grip) {
    return Column(
      key: Key('$index'),
      children: [
        ListTile(
          minLeadingWidth: 15.0,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4.0),
          leading: Text(
            (index + 1).toString(),
            style: const TextStyle(fontSize: 20.0),
          ),
          title: Text(grip.gripType.name),
          subtitle: _subitleText(grip),
          trailing: ReorderableDragStartListener(
              index: index, child: const Icon(Icons.drag_handle)),
        ),
        const Divider(
          indent: 45,
          endIndent: 5,
          thickness: 1.0,
          height: 1,
        ),
      ],
    );
  }
}
