import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../screens/edit_grip_screen.dart';

/// A ReorderableListView that enables the user to tap and drag grips to
/// reorder the list of grips for the current workout
class ReorderableGripList extends StatefulWidget {
  final List<GripWithGripType> gripList;
  final Workout workout;

  const ReorderableGripList(
      {super.key, required this.gripList, required this.workout});

  @override
  State<ReorderableGripList> createState() => _ReorderableGripListState();
}

class _ReorderableGripListState extends State<ReorderableGripList> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return ReorderableListView(
        footer: const SizedBox(height: 20),
        children: <Widget>[
          for (int index = 0; index < widget.gripList.length; index++)
            _listTileWithDivider(
                index, widget.gripList.length - 1, widget.gripList[index]),
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

  /// A CupertinoListTile with a divider
  Widget _listTileWithDivider(int index, int lastIndex, GripWithGripType grip) {
    return Column(
      key: Key('$index'),
      children: [
        CupertinoListTile(
          backgroundColor: CupertinoColors.white,
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
              index: index,
              child: const Icon(
                CupertinoIcons.line_horizontal_3,
                color: CupertinoColors.systemGrey2,
              )),
        ),
        _dividerWithBreakDuration(grip.entry, index, lastIndex),
      ],
    );
  }

  /// Navigates to the EditGripScreen widget
  void _navigateToEditGripScreen(BuildContext context, GripWithGripType grip) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              EditGripScreen(grip: grip, workout: widget.workout)),
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
    return Container(
      decoration: const BoxDecoration(color: CupertinoColors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
              child: Divider(
            thickness: 1.0,
            indent: 62.0,
            endIndent: 8.0,
            height: 3.0,
          )),
          Text(
            _dividerText(grip, gripIndex, lastIndex),
            style: const TextStyle(fontSize: 14.0),
          ),
          const Expanded(
              child: Divider(
            thickness: 1.0,
            indent: 8.0,
            endIndent: 8.0,
            height: 3.0,
          )),
        ],
      ),
    );
  }

  /// If the grip is the last in the list, then returns 'COMPLETE'. Otherwise,
  /// returns the length of the last break for the given grip.
  String _dividerText(Grip grip, int gripIndex, int lastIndex) {
    if (gripIndex == lastIndex) {
      return 'COMPLETE';
    }

    return 'Break ${grip.lastBreakMinutes}:${grip.lastBreakSeconds.toString().padLeft(2, '0')}';
  }
}
