import 'package:flutter/material.dart';
import '../models/timer_durations_dto.dart';
import '../widgets/number_picker.dart';

/// A form widget that allows the user to pick the number of sets and reps, and
/// the work, rest, and break durations for the countdown timer.
class DurationsPickerForm extends StatefulWidget {
  /// Function to be called when start button is pressed
  final Function(BuildContext, TimerDurationsDTO) onStartPressed;

  const DurationsPickerForm({super.key, required this.onStartPressed});

  @override
  State<DurationsPickerForm> createState() => _DurationsPickerFormState();
}

class _DurationsPickerFormState extends State<DurationsPickerForm> {
  final timerDurations = TimerDurationsDTO.standard();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        NumberPicker(
          title: 'Sets',
          titleWidth: 60.0,
          initialValue: timerDurations.sets.toInt(),
          min: 1,
          max: 20,
          onItemChanged: (newValue) {
            timerDurations.sets = newValue.toDouble();
          },
        ),
        NumberPicker(
          title: 'Reps',
          titleWidth: 60.0,
          initialValue: timerDurations.reps.toInt(),
          min: 1,
          max: 20,
          onItemChanged: (newValue) {
            timerDurations.reps = newValue.toDouble();
          },
        ),
        NumberPicker(
          title: 'Work',
          unit: 'sec.',
          titleWidth: 60.0,
          initialValue: timerDurations.workSeconds.toInt(),
          min: 1,
          max: 60,
          onItemChanged: (newValue) {
            timerDurations.workSeconds = newValue.toDouble();
          },
        ),
        NumberPicker(
          title: 'Rest',
          unit: 'sec.',
          titleWidth: 60.0,
          initialValue: timerDurations.restSeconds.toInt(),
          min: 1,
          max: 60,
          onItemChanged: (newValue) {
            timerDurations.restSeconds = newValue.toDouble();
          },
        ),
        NumberPicker(
          title: 'Break',
          unit: 'min.',
          titleWidth: 60.0,
          initialValue: timerDurations.breakMinutes.toInt(),
          min: 0,
          max: 30,
          onItemChanged: (newValue) {
            timerDurations.breakMinutes = newValue.toDouble();
          },
        ),
        NumberPicker(
          title: 'Break',
          unit: 'sec.',
          titleWidth: 60.0,
          initialValue: timerDurations.breakSeconds.toInt(),
          min: 1,
          max: 60,
          onItemChanged: (newValue) {
            timerDurations.breakSeconds = newValue.toDouble();
          },
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () {
                widget.onStartPressed(context, timerDurations);
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
