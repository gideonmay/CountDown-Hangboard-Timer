import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_type_dto.dart';

/// A screen showing a list of all available grip types to choose for the
/// current grip
class GripTypesList extends StatefulWidget {
  /// The initial currently selected grip type
  final GripTypeDTO initialGripType;
  final String previousPageTitle;

  /// The grip types to show in the list
  final List<GripTypeWithGripCount> gripTypes;

  /// To be executed when the grip type is changed
  final Function(GripTypeDTO newGripType) onGripTypeChanged;

  const GripTypesList({
    super.key,
    required this.previousPageTitle,
    required this.gripTypes,
    required this.onGripTypeChanged,
    required this.initialGripType,
  });

  @override
  State<GripTypesList> createState() => _GripTypesListState();
}

class _GripTypesListState extends State<GripTypesList> {
  late GripTypeDTO _selectedGripType;

  @override
  void initState() {
    super.initState();
    _selectedGripType = widget.initialGripType;
  }

  @override
  Widget build(BuildContext context) {
    return _gripTypeList(context);
  }

  /// Returns a list of CupertinoListTiles for each grip type in the stream
  Widget _gripTypeList(BuildContext context) {
    return SlidableAutoCloseBehavior(
      closeWhenOpened: true,
      child: CupertinoListSection.insetGrouped(children: <Widget>[
        for (int index = 0; index < widget.gripTypes.length; index++)
          Slidable(
            endActionPane: ActionPane(
                motion: const ScrollMotion(),
                extentRatio: 0.25,
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      final currGripType = widget.gripTypes[index];
                      if (_isCurrentlySelected(currGripType.entry)) {
                        // Show error to prevent deletion of selected grip type
                        _showErrorDialog(context, currGripType);
                      } else {
                        // Show action sheet to delete the grip type
                        _showActionSheet(context, currGripType);
                      }
                    },
                    backgroundColor: CupertinoColors.systemRed,
                    foregroundColor: CupertinoColors.white,
                    label: 'Delete',
                  ),
                ]),
            child: CupertinoListTile(
              leading: _checkmarkIcon(widget.gripTypes[index].entry),
              title: Text(widget.gripTypes[index].entry.name),
              subtitle:
                  Text('Used with ${widget.gripTypes[index].gripCount} grips'),
              onTap: () {
                int newGripTypeID = widget.gripTypes[index].entry.id;
                String newGripTypeName = widget.gripTypes[index].entry.name;

                setState(() {
                  // Set grip type to new grip type chosen by user
                  widget.onGripTypeChanged(
                      GripTypeDTO(id: newGripTypeID, name: newGripTypeName));
                  _selectedGripType =
                      GripTypeDTO(id: newGripTypeID, name: newGripTypeName);
                });
              },
            ),
          ),
      ]),
    );
  }

  /// Returns a checkmark icon for the grip type that is currently selected by
  /// the parent form field
  Widget _checkmarkIcon(GripType currGripType) {
    if (_isCurrentlySelected(currGripType)) {
      return const Icon(CupertinoIcons.check_mark);
    }

    return Container();
  }

  /// Returns true if the given grip type is currently selected by the form
  bool _isCurrentlySelected(GripType currGripType) {
    return currGripType.id == _selectedGripType.id;
  }

  // Shows a dialog box to inform user that the grip type cannot be deleted
  Future<void> _showErrorDialog(
      BuildContext context, GripTypeWithGripCount gripType) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Grip Type cannot be deleted'),
        content: const Text(
            'Cannot delete the currently selected grip type. To delete, select a different grip type then try again.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  /// Shows an action sheet allowing user to delete a grip type
  void _showActionSheet(BuildContext context, GripTypeWithGripCount gripType) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        message: Text(_dialogText(gripType)),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              _deleteGripType(context, gripType.entry);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  /// Returns dialog text with the correct pluralization
  String _dialogText(GripTypeWithGripCount gripType) {
    String text =
        'The grip type \'${gripType.entry.name}\' will be permanently deleted';
    int? gripCount = gripType.gripCount;

    if (gripCount != null && gripCount != 0) {
      if (gripType.gripCount == 1) {
        text += ' along with the $gripCount grip that it is used on';
      } else {
        text += ' along with the $gripCount grips that it is used on';
      }
    }

    return text;
  }

  /// Deletes the given grip type from the database
  void _deleteGripType(BuildContext context, GripType gripType) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.deleteGripType(gripType);
  }
}
