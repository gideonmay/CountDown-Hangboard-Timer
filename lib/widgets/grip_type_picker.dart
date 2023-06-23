import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../screens/choose_grip_type_screen.dart';
import '../utils/navigation_utils.dart';

/// A picker menu that enables the user to choose a grip type
class GripTypePicker extends StatefulWidget {
  final GripDTO gripDTO;
  final String? errorText;

  /// The stream of grip types to populate the dropdown with
  final Stream<List<GripTypeWithGripCount>> gripTypeStream;

  const GripTypePicker(
      {super.key,
      required this.gripDTO,
      required this.gripTypeStream,
      this.errorText});

  @override
  State<GripTypePicker> createState() => _GripTypePickerState();
}

class _GripTypePickerState extends State<GripTypePicker> {
  @override
  Widget build(BuildContext context) {
    return CupertinoFormRow(
        padding: EdgeInsets.zero,
        // Show error message if error text is not null
        error: widget.errorText == null
            ? null
            : Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 0.0, 16.0, 8.0),
                child: Text(widget.errorText!),
              ),
        child: _buildGripTypePicker(context));
  }

  /// Returns a List of DropdownMenuItems for each grip type in the database
  StreamBuilder<List<GripTypeWithGripCount>> _buildGripTypePicker(
      BuildContext context) {
    return StreamBuilder(
      stream: widget.gripTypeStream,
      builder: (context, AsyncSnapshot<List<GripTypeWithGripCount>> snapshot) {
        final gripTypes = snapshot.data ?? List.empty();

        // Show message to user if they have not yet created any grip types
        if (gripTypes.isEmpty) {
          return CupertinoListTile(
              title: const Text('Grip Type'),
              additionalInfo: const Text('No grip types added'),
              trailing: const CupertinoListTileChevron(),
              onTap: () => navigateToAddGripTypeScreen(context));
        }

        _setInitalGripType(gripTypes);

        return CupertinoListTile(
          title: const Text('Grip Type'),
          additionalInfo: _gripTypeName(gripTypes),
          trailing: const CupertinoListTileChevron(),
          onTap: () => _navigateToChooseGripType(context, gripTypes),
        );
      },
    );
  }

  Widget _gripTypeName(List<GripTypeWithGripCount> gripTypes) {
    GripType selectedGripType = gripTypes
        .firstWhere(
            (gripType) => gripType.entry.id == widget.gripDTO.gripTypeID)
        .entry;
    return Text(selectedGripType.name);
  }

  /// Sets the initial grip type to the first grip type in the given list
  void _setInitalGripType(List<GripTypeWithGripCount> gripTypes) {
    widget.gripDTO.gripTypeID = gripTypes[0].entry.id;
  }

  /// Navigates to the ChooseGripType widget
  void _navigateToChooseGripType(
      BuildContext context, List<GripTypeWithGripCount> gripTypes) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) => ChooseGripTypeScreen(
                gripTypes: gripTypes,
                gripDTO: widget.gripDTO,
                onGripTypeChange: (int newGripTypeID) =>
                    _setNewGripTypeID(newGripTypeID),
              )),
    );
  }

  /// Sets the grip type ID to the given new grip type ID
  void _setNewGripTypeID(int newGripTypeID) {
    setState(() {
      widget.gripDTO.gripTypeID = newGripTypeID;
    });
  }
}
