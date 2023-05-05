import 'package:flutter/material.dart';
import '../models/workout_dto.dart';

/// Provides a form to allow users to enter workout information then submit the
/// information by tapping a button
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.workoutDTO.name,
              decoration: const InputDecoration(labelText: 'Name'),
              maxLength: 40,
              onSaved: (newValue) {
                widget.workoutDTO.name = newValue;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: widget.workoutDTO.description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLength: 100,
              onSaved: (newValue) {
                widget.workoutDTO.description = newValue;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
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

  Widget _submitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () async {
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
