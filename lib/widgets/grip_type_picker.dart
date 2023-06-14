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
  late int _selectedGripType;

  @override
  void initState() {
    super.initState();
    // Set selected grip type to zero if the gripTypeID is currently null
    _selectedGripType = widget.gripDTO.gripTypeID ?? 0;
  }

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

        // Set initial grip type to first grip type in list
        widget.gripDTO.gripTypeID = gripTypes[_selectedGripType].id;

        return CupertinoListTile(
          title: const Text('Grip Type'),
          trailing: Expanded(
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: Text(gripTypes[_selectedGripType].name),
                onPressed: () {
                  showBottomDialog(
                      context,
                      CupertinoPicker(
                        itemExtent: 40.0,
                        scrollController: FixedExtentScrollController(
                          initialItem: _selectedGripType,
                        ),
                        onSelectedItemChanged: (value) {
                          playButtonSound();
                          setState(() {
                            _selectedGripType = value;
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
}
