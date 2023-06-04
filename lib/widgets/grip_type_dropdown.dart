import 'package:flutter/material.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import 'number_picker_title.dart';

/// A dropdowm menu that enables the user to choose a grip type
class GripTypeDropdown extends StatefulWidget {
  final GripDTO gripDTO;

  /// The stream of grip types to populate the dropdown with
  final Stream<List<GripType>> gripTypeStream;

  const GripTypeDropdown(
      {super.key, required this.gripDTO, required this.gripTypeStream});

  @override
  State<GripTypeDropdown> createState() => _GripTypeDropdownState();
}

class _GripTypeDropdownState extends State<GripTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const NumberPickerTitle(title: 'Grip Type', maxWidth: 110.0),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 16.0, 24.0, 8.0),
          child: _buildDropdownFormField(context),
        )),
      ],
    );
  }

  /// Returns a List of DropdownMenuItems for each grip type in the database
  StreamBuilder<List<GripType>> _buildDropdownFormField(BuildContext context) {
    return StreamBuilder(
      stream: widget.gripTypeStream,
      builder: (context, AsyncSnapshot<List<GripType>> snapshot) {
        final gripTypes = snapshot.data ?? List.empty();

        return DropdownButtonFormField(
          value: widget.gripDTO.gripTypeID,
          hint: Text(getHintText(gripTypes)),
          isDense: true,
          isExpanded: true,
          items: gripTypes.map((GripType gripType) {
            return DropdownMenuItem(
                value: gripType.id,
                child: Text(
                  gripType.name,
                ));
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please choose a grip type';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              widget.gripDTO.gripTypeID = value;
            });
          },
          onSaved: (value) {
            setState(() {
              widget.gripDTO.gripTypeID = value;
            });
          },
          decoration: const InputDecoration(filled: true),
        );
      },
    );
  }

  /// Returns a hint String based on the length of the gripTypes list
  String getHintText(List<GripType> gripTypes) {
    return gripTypes.isEmpty ? 'No grip types added' : 'Choose a grip type';
  }
}
