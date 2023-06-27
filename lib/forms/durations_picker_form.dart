import 'package:flutter/cupertino.dart';
import '../models/timer_durations_dto.dart';
import '../widgets/duration_picker.dart';
import '../widgets/number_picker.dart';

/// A form widget that allows the user to pick the number of sets and reps, and
/// the work, rest, and break durations for the countdown timer
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
    return Column(children: [
      CupertinoListSection.insetGrouped(
        children: [
          _setsPicker(),
          _repsPicker(),
          _workDurationPicker(),
          _restDurationPicker(),
          _breakDurationPicker(),
        ],
      ),
      const SizedBox(height: 20.0),
      _startButton(),
    ]);
  }

  Widget _setsPicker() {
    return NumberPicker(
      title: 'Sets',
      initialValue: timerDurations.sets,
      minValue: 1,
      maxValue: 20,
      onValueChanged: (newValue) {
        timerDurations.sets = newValue;
      },
    );
  }

  Widget _repsPicker() {
    return NumberPicker(
      title: 'Reps',
      initialValue: timerDurations.reps,
      minValue: 1,
      maxValue: 20,
      onValueChanged: (newValue) {
        timerDurations.reps = newValue;
      },
    );
  }

  Widget _workDurationPicker() {
    return NumberPicker(
      title: 'Work (sec.)',
      initialValue: timerDurations.workSeconds,
      minValue: 1,
      maxValue: 60,
      onValueChanged: (newValue) {
        timerDurations.workSeconds = newValue;
      },
    );
  }

  Widget _restDurationPicker() {
    return NumberPicker(
      title: 'Rest (sec.)',
      initialValue: timerDurations.restSeconds,
      minValue: 1,
      maxValue: 60,
      onValueChanged: (newValue) {
        timerDurations.restSeconds = newValue;
      },
    );
  }

  Widget _breakDurationPicker() {
    return DurationPicker(
      title: 'Break',
      minutes: timerDurations.breakMinutes,
      seconds: timerDurations.breakSeconds,
      onDurationChanged: (newDuration) {
        timerDurations.breakMinutes = newDuration.inMinutes;
        timerDurations.breakSeconds = newDuration.inSeconds % 60;
      },
    );
  }

  Widget _startButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: CupertinoButton.filled(
            onPressed: () {
              widget.onStartPressed(context, timerDurations);
            },
            child: const Text(
              'Start',
              style: TextStyle(fontSize: 20.0),
            )),
      ),
    );
  }
}
