import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../extensions/string_casing_extension.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';
import '../screens/add_grip_type_screen.dart';

/// A dropdowm menu that enables the user to choose a grip type
class GripTypeDropdown extends StatefulWidget {
  final GripDTO gripDTO;

  const GripTypeDropdown({super.key, required this.gripDTO});

  @override
  State<GripTypeDropdown> createState() => _GripTypeDropdownState();
}

class _GripTypeDropdownState extends State<GripTypeDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 75,
            child: _buildDropdownFormField(context),
          ),
          Flexible(
              flex: 25,
              child: Center(
                child: ElevatedButton(
                    onPressed: () => _navigateToAddGripType(context),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        fixedSize: const Size(50, 50)),
                    child: const Icon(Icons.add)),
              )),
        ],
      ),
    );
  }

  /// Returns a List of DropdownMenuItems for each grip type in the database
  StreamBuilder<List<GripType>> _buildDropdownFormField(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: db.watchAllGripTypes(),
      builder: (context, AsyncSnapshot<List<GripType>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final gripTypes = snapshot.data ?? List.empty();

        return DropdownButtonFormField(
          value: widget.gripDTO.gripTypeID,
          hint: const Text('Choose a grip type'),
          items: gripTypes.map((GripType gripType) {
            return DropdownMenuItem(
                value: gripType.id, child: Text(gripType.name.toTitleCase()));
          }).toList(),
          validator: (value) {
            if (value == null) {
              return 'Please choose a grip type';
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              widget.gripDTO.gripTypeID = value as int;
            });
          },
          onSaved: (value) {
            setState(() {
              widget.gripDTO.gripTypeID = value as int;
            });
          },
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelStyle: TextStyle(fontSize: 24.0)),
        );
      },
    );
  }

  /// Navigates to the AddGripType widget
  static _navigateToAddGripType(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddGripTypeScreen()),
    );
  }
}
