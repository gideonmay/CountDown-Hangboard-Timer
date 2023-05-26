import 'package:countdown_app/models/grip_dto.dart';
import 'package:flutter/material.dart';
import '../widgets/grip_details_pickers.dart';
import '../widgets/grip_type_dropdown.dart';

/// A form that allows user to input grip information
class GripDetailsForm extends StatefulWidget {
  final GripDTO gripDTO;

  final String buttonText;

  /// Function to be executed when form is saved to write grip to database
  final Function onFormSaved;

  const GripDetailsForm(
      {super.key,
      required this.gripDTO,
      required this.onFormSaved,
      required this.buttonText});

  @override
  State<GripDetailsForm> createState() => _GripDetailsFormState();
}

class _GripDetailsFormState extends State<GripDetailsForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            GripTypeDropdown(gripDTO: widget.gripDTO),
            GripDetailsPickers(gripDTO: widget.gripDTO),
            _submitButton(),
          ],
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onFormSaved();
            }
          },
          child:
              Text(widget.buttonText, style: const TextStyle(fontSize: 20.0))),
    );
  }
}
