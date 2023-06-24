import 'package:flutter/cupertino.dart';
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
      child: ListView(
        children: [
          CupertinoFormSection.insetGrouped(
              header: const Text('GRIP TYPE NAME'),
              footer: const Text(
                  'A reusable name for a grip. Example: "Half Crimp."'),
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: 'Enter name',
                  maxLength: 40,
                  onSaved: (newValue) {
                    if (newValue != null) {
                      _gripTypeName = newValue.trim();
                    } else {
                      _gripTypeName = newValue;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a grip type name';
                    }

                    // Check if grip type name already exists
                    if (_isDuplicate(value.trim())) {
                      return 'This grip type already exists';
                    }

                    return null;
                  },
                ),
              ]),
          const SizedBox(height: 20.0),
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
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CupertinoButton.filled(
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
    await db.addGripType(_gripTypeName!);

    // Navigate back to AddGripScreen
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
