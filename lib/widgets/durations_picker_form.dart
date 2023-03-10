import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

/// A form widget that allows the user to pick the number of _sets and reps, and
/// the work, rest, and break durations for the countdown timer.
class DurationsPickerForm extends StatefulWidget {
  const DurationsPickerForm({super.key});

  @override
  State<DurationsPickerForm> createState() => _DurationsPickerFormState();
}

class _DurationsPickerFormState extends State<DurationsPickerForm> {
  double _sets = 1;
  double _reps = 1;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            value: _sets,
            min: 1,
            max: 50,
            onChanged: (value) {
              setState(() {
                _sets = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Sets'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            value: _reps,
            min: 1,
            max: 50,
            onChanged: (value) {
              setState(() {
                _reps = value;
              });
            },
            decoration: const InputDecoration(labelText: 'Reps'),
          ),
        )
      ],
    );
  }
}
