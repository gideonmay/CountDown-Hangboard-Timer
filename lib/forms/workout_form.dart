import 'package:flutter/cupertino.dart';
import '../models/workout_dto.dart';

/// A form that enables the user to enter a name and description for a workout
class WorkoutForm extends StatefulWidget {
  final WorkoutDTO workoutDTO;

  /// Function to be executed when form is saved. Should write to the database.
  final Function onFormSaved;

  /// The text to display in the submission button
  final String buttonText;
  const WorkoutForm(
      {super.key,
      required this.workoutDTO,
      required this.onFormSaved,
      required this.buttonText});

  @override
  State<WorkoutForm> createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Form(
      key: _formKey,
      child: ListView(
        children: [
          CupertinoFormSection.insetGrouped(
            header: const Text('WORKOUT DETAILS'),
            children: _formFieldRows(),
          ),
          const SizedBox(height: 20),
          _submitButton(context),
        ],
      ),
    ));
  }

  /// The text fields for this form
  List<Widget> _formFieldRows() {
    return [
      CupertinoTextFormFieldRow(
        initialValue: widget.workoutDTO.name,
        maxLength: 40,
        textInputAction: TextInputAction.next,
        prefix: const Text('Name'),
        placeholder: 'Enter name',
        onSaved: (newValue) {
          if (newValue != null) {
            // Trim blank spaces off front and end of string
            widget.workoutDTO.name = newValue.trim();
          } else {
            widget.workoutDTO.name = newValue;
          }
        },
        validator: (String? value) {
          // Check if string is blank, empty, or only spaces
          if (value == null || value.isEmpty || value.trim().isEmpty) {
            return 'Please enter a name';
          }
          return null;
        },
      ),
      CupertinoTextFormFieldRow(
        initialValue: widget.workoutDTO.description,
        maxLength: 100,
        textInputAction: TextInputAction.next,
        prefix: const Text('Description'),
        placeholder: 'Enter description',
        onSaved: (newValue) {
          if (newValue != null) {
            // Trim blank spaces off front and end of string
            widget.workoutDTO.description = newValue.trim();
          } else {
            widget.workoutDTO.description = newValue;
          }
        },
        validator: (String? value) {
          if (value == null || value.isEmpty || value.trim().isEmpty) {
            return 'Please enter a description';
          }
          return null;
        },
      ),
    ];
  }

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CupertinoButton.filled(
          child: Text(widget.buttonText),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              widget.onFormSaved();
            }
          }),
    );
  }
}
