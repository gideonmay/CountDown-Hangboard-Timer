import 'package:flutter/material.dart';
import '../models/timer_durations_dto.dart';
import '../widgets/number_picker.dart';
import '../widgets/number_picker_title.dart';

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
        Row(
          children: [
            const NumberPickerTitle(title: 'Sets', maxWidth: 60.0),
            Expanded(
              child: NumberPicker(
                initialValue: timerDurations.sets.toInt(),
                min: 1,
                max: 20,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                onItemChanged: (newValue) {
                  timerDurations.sets = newValue.toDouble();
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const NumberPickerTitle(title: 'Reps', maxWidth: 60.0),
            Expanded(
              child: NumberPicker(
                initialValue: timerDurations.reps.toInt(),
                min: 1,
                max: 20,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                onItemChanged: (newValue) {
                  timerDurations.reps = newValue.toDouble();
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const NumberPickerTitle(title: 'Work', maxWidth: 60.0),
            Expanded(
              child: NumberPicker(
                unit: 'sec.',
                initialValue: timerDurations.workSeconds.toInt(),
                min: 1,
                max: 60,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                onItemChanged: (newValue) {
                  timerDurations.workSeconds = newValue.toDouble();
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const NumberPickerTitle(title: 'Rest', maxWidth: 60.0),
            Expanded(
              child: NumberPicker(
                unit: 'sec.',
                initialValue: timerDurations.restSeconds.toInt(),
                min: 1,
                max: 60,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
                onItemChanged: (newValue) {
                  timerDurations.restSeconds = newValue.toDouble();
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            const NumberPickerTitle(title: 'Break', maxWidth: 60.0),
            Expanded(
              child: NumberPicker(
                unit: 'min.',
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
                initialValue: timerDurations.breakMinutes.toInt(),
                min: 0,
                max: 30,
                onItemChanged: (newValue) {
                  timerDurations.breakMinutes = newValue.toDouble();
                },
              ),
            ),
            Expanded(
              child: NumberPicker(
                unit: 'sec.',
                initialValue: timerDurations.breakSeconds.toInt(),
                min: 1,
                max: 60,
                padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
                onItemChanged: (newValue) {
                  timerDurations.breakSeconds = newValue.toDouble();
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
              onPressed: () {
                widget.onStartPressed(context, timerDurations);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: const Text(
                'Start',
                style: TextStyle(fontSize: 20.0),
              )),
        ),
      ],
    );
  }
}
