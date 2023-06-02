import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../screens/edit_grip_screen.dart';
import '../widgets/app_divider.dart';

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
            _listTileWithDivider(
                index, widget.gripList.length - 1, widget.gripList[index])
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

  /// A ListTile with a divider
  Widget _listTileWithDivider(int index, int lastIndex, GripWithGripType grip) {
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
          onTap: () {
            _navigateToEditGripScreen(context, grip);
          },
          title: _titleText(grip),
          subtitle: _subitleText(grip.entry),
          trailing: ReorderableDragStartListener(
              index: index, child: const Icon(Icons.drag_handle)),
        ),
        _dividerWithBreakDuration(grip.entry, index, lastIndex),
      ],
    );
  }

  /// Navigates to the EditGripScreen widget
  static _navigateToEditGripScreen(
      BuildContext context, GripWithGripType grip) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditGripScreen(grip: grip)),
    );
  }

  /// Returns a Text widget that omits the edge size if it is null
  Widget _titleText(GripWithGripType grip) {
    if (grip.entry.edgeSize == null) {
      return Text(grip.gripType.name);
    }

    return Text('${grip.gripType.name} - ${grip.entry.edgeSize}mm');
  }

  /// Specifies details about the given grip
  Text _subitleText(Grip grip) {
    return Text(
      'Sets ${grip.setCount} | Reps ${grip.repCount} | W ${grip.workSeconds}s | R ${grip.restSeconds}s | B ${grip.breakMinutes}:${grip.breakSeconds.toString().padLeft(2, '0')}',
      style: const TextStyle(fontSize: 12.0),
    );
  }

  /// A set of dividers with the Post-Break duration in between them
  Widget _dividerWithBreakDuration(Grip grip, int gripIndex, int lastIndex) {
    if (gripIndex == lastIndex) {
      return const AppDivider(indent: 45, height: 1.0);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(child: AppDivider(indent: 45, height: 3.0)),
        Text(
            'Break ${grip.lastBreakMinutes}:${grip.lastBreakSeconds.toString().padLeft(2, '0')}'),
        const Expanded(child: AppDivider(indent: 8.0, height: 3.0)),
      ],
    );
  }
}
