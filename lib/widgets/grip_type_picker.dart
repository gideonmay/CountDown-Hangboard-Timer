import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../utils/dialog_utils.dart';
import '../utils/sound_utils.dart';

/// A picker menu that enables the user to choose a grip type
class GripTypePicker extends StatefulWidget {
  final GripDTO gripDTO;

  /// The stream of grip types to populate the dropdown with
  final Stream<List<GripType>> gripTypeStream;

  const GripTypePicker(
      {super.key, required this.gripDTO, required this.gripTypeStream});

  @override
  State<GripTypePicker> createState() => _GripTypePickerState();
}

class _GripTypePickerState extends State<GripTypePicker> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _buildGripTypePicker(context);
  }

  /// Returns a List of DropdownMenuItems for each grip type in the database
  StreamBuilder<List<GripType>> _buildGripTypePicker(BuildContext context) {
    return StreamBuilder(
      stream: widget.gripTypeStream,
      builder: (context, AsyncSnapshot<List<GripType>> snapshot) {
        final gripTypes = snapshot.data ?? List.empty();

        // Show message to user if they have not yet created any grip types
        if (gripTypes.isEmpty) {
          return const CupertinoListTile(
            title: Text('Grip Type'),
            trailing: Text(
              'No grip types added',
              style: TextStyle(color: CupertinoColors.systemGrey),
            ),
          );
        }

        _setInitalGripType(gripTypes);

        return CupertinoListTile(
          title: const Text('Grip Type'),
          trailing: Expanded(
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(gripTypes[_selectedIndex].name),
                onPressed: () {
                  showBottomDialog(
                      context,
                      CupertinoPicker(
                        itemExtent: 40.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: _selectedIndex,
                        ),
                        onSelectedItemChanged: (value) {
                          playButtonSound();
                          setState(() {
                            _selectedIndex = value;
                            widget.gripDTO.gripTypeID = gripTypes[value].id;
                          });
                        },
                        children: List<Widget>.generate(gripTypes.length,
                            (int index) {
                          return Center(child: Text(gripTypes[index].name));
                        }),
                      ));
                }),
          ),
        );
      },
    );
  }

  /// Sets the inital value of the selected grip type index based on whether
  /// or not the given GripDTO already contains a non-null grip type ID
  void _setInitalGripType(List<GripType> gripTypes) {
    if (widget.gripDTO.gripTypeID != null) {
      // Find grip type in list that matches the grip type ID from the gripDTO
      final initialGripType = gripTypes
          .firstWhere((gripType) => gripType.id == widget.gripDTO.gripTypeID);
      // Set the selected index to that of the gripDTO's grip type ID
      _selectedIndex = gripTypes.indexOf(initialGripType);
    } else {
      // Set initial grip type to first grip type in list
      widget.gripDTO.gripTypeID = gripTypes[_selectedIndex].id;
    }
  }
}
