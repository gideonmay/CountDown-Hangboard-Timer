import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';

/// A form that allows the user to enter a grip type name and save it to the
/// database
class AddGripTypeForm extends StatefulWidget {
  final List<GripTypeWithGripCount> gripTypes;

  const AddGripTypeForm({super.key, required this.gripTypes});

  @override
  State<AddGripTypeForm> createState() => _AddGripTypeFormState();
}

class _AddGripTypeFormState extends State<AddGripTypeForm> {
  final _formKey = GlobalKey<FormState>();
  String? _gripTypeName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Grip Name'),
              maxLength: 40,
              onSaved: (newValue) {
                if (newValue != null) {
                  _gripTypeName = newValue.trim();
                } else {
                  _gripTypeName = newValue;
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a grip name';
                }

                // Check if grip type name already exists
                if (_isDuplicate(value.trim())) {
                  return 'This grip type already exists';
                }

                return null;
              },
            ),
          ),
          _submitButton(context),
        ],
      ),
    );
  }

  /// Returns true if the grip type name does already exists in the database and
  /// false otherwise
  bool _isDuplicate(String gripTypeName) {
    for (var gripType in widget.gripTypes) {
      if (gripType.entry.name == gripTypeName) {
        return true;
      }
    }

    return false;
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              _createGripType();
            }
          },
          child: const Text('Submit', style: TextStyle(fontSize: 20.0))),
    );
  }

  /// Adds the grip type to the database
  void _createGripType() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.addGripType(GripTypesCompanion.insert(name: _gripTypeName!));

    // Navigate back to AddGripScreen
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
