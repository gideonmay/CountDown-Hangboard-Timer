import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';

/// Provides a form to allow users to create a new workout. Once created, the
/// user is navigated back to the My Workouts page.
class CreateWorkoutForm extends StatefulWidget {
  const CreateWorkoutForm({super.key});

  @override
  State<CreateWorkoutForm> createState() => _CreateWorkoutFormState();
}

class _CreateWorkoutFormState extends State<CreateWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  String? _workoutName;
  String? _workoutDescription;

  Widget submitButton(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size.fromHeight(40)),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await db.addWorkout(WorkoutsCompanion.insert(
                  name: _workoutName!, description: _workoutDescription!));

              // Navigate back to My Workouts page
              if (context.mounted) {
                Navigator.pop(context);
              }
            }
          },
          child: const Text('Submit', style: TextStyle(fontSize: 20.0))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              maxLength: 40,
              onSaved: (newValue) {
                _workoutName = newValue;
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
              decoration: const InputDecoration(labelText: 'Description'),
              maxLength: 100,
              onSaved: (newValue) {
                _workoutDescription = newValue;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
          ),
          submitButton(context),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Once created, you can add exercises and begin the workout by tapping on it from the My Workouts screen',
              style: TextStyle(color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
