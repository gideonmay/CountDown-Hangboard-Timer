import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';

/// A form widget that allows the user to pick the number of _sets and reps, and
/// the work, rest, and break durations for the countdown timer.
class DurationsPickerForm extends StatefulWidget {
  /// Function to be called when start button is pressed
  final Function onStartPressed;

  const DurationsPickerForm({super.key, required this.onStartPressed});

  @override
  State<DurationsPickerForm> createState() => _DurationsPickerFormState();
}

class _DurationsPickerFormState extends State<DurationsPickerForm> {
  double _sets = 1;
  double _reps = 1;
  double _workSeconds = 10;
  double _restSeconds = 5;
  double _breakMinutes = 0;
  double _breakSeconds = 30;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SpinBox(
            value: _sets,
            min: 1,
            max: 50,
            onChanged: (value) {
              setState(() {
                _sets = value;
              });
            },
            decoration: const InputDecoration(
                labelText: 'Sets', labelStyle: TextStyle(fontSize: 24.0)),
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
            decoration: const InputDecoration(
                labelText: 'Reps', labelStyle: TextStyle(fontSize: 24.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            value: _workSeconds,
            min: 1,
            max: 60,
            onChanged: (value) {
              setState(() {
                _workSeconds = value;
              });
            },
            decoration: const InputDecoration(
                labelText: 'Work (sec)', labelStyle: TextStyle(fontSize: 24.0)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SpinBox(
            value: _restSeconds,
            min: 1,
            max: 60,
            onChanged: (value) {
              setState(() {
                _restSeconds = value;
              });
            },
            decoration: const InputDecoration(
                labelText: 'Rest (sec)', labelStyle: TextStyle(fontSize: 24.0)),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
                child: SpinBox(
                  value: _breakMinutes,
                  min: 0,
                  max: 30,
                  onChanged: (value) {
                    setState(() {
                      _breakMinutes = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Break (min)',
                      labelStyle: TextStyle(fontSize: 24.0)),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 16.0, 16.0, 16.0),
                child: SpinBox(
                  value: _breakSeconds,
                  min: 0,
                  max: 60,
                  onChanged: (value) {
                    setState(() {
                      _breakSeconds = value;
                    });
                  },
                  decoration: const InputDecoration(
                      labelText: 'Break (sec)',
                      labelStyle: TextStyle(fontSize: 24.0)),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () {
                widget.onStartPressed(
                  context,
                  _workSeconds.toInt(),
                  _restSeconds.toInt(),
                  _breakSeconds.toInt()
                );
              },
              child: const Text(
                'Start',
                style: TextStyle(fontSize: 20.0),
              )),
        ),
      ],
    );
  }
}
