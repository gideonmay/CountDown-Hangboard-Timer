import 'package:flutter/material.dart';
import '../models/grip_dto.dart';
import '../widgets/app_divider.dart';
import '../widgets/app_header.dart';
import '../widgets/number_picker.dart';
import '../widgets/number_picker_title.dart';

/// A series of NumberPickers allowing the user to choose sets and reps, and the
/// work, rest, and break durations for a particular grip
class GripDetailsPickers extends StatefulWidget {
  final GripDTO gripDTO;

  const GripDetailsPickers({super.key, required this.gripDTO});

  @override
  State<GripDetailsPickers> createState() => _GripDetailsPickersState();
}

class _GripDetailsPickersState extends State<GripDetailsPickers> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _setsPicker(),
        _repsSpinBox(),
        _workSpinBox(),
        _restSpinBox(),
        _breakSpinBoxes(),
        const AppDivider(),
        const AppHeader(title: 'Post-Grip Break'),
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child:
              Text('The break duration between this grip and the next'),
        ),
        _lastBreakSpinBoxes(),
      ],
    );
  }

  /// NumberPicker that allows user to choose number of sets
  Widget _setsPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Sets', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            initialValue: widget.gripDTO.sets.toInt(),
            min: 1,
            max: 20,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onItemChanged: (newValue) {
              widget.gripDTO.sets = newValue.toDouble();
            },
          ),
        ),
      ],
    );
  }

  /// NumberPicker that allows user to choose number of reps
  Widget _repsSpinBox() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Reps', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            initialValue: widget.gripDTO.reps.toInt(),
            min: 1,
            max: 20,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onItemChanged: (newValue) {
              widget.gripDTO.reps = newValue.toDouble();
            },
          ),
        ),
      ],
    );
  }

  /// NumberPicker that allows user to choose work seconds
  Widget _workSpinBox() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Work', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            unit: 'sec.',
            initialValue: widget.gripDTO.workSeconds.toInt(),
            min: 1,
            max: 60,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onItemChanged: (newValue) {
              widget.gripDTO.workSeconds = newValue.toDouble();
            },
          ),
        ),
      ],
    );
  }

  /// NumberPicker that allows user to choose rest seconds
  Widget _restSpinBox() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Rest', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            unit: 'sec.',
            initialValue: widget.gripDTO.restSeconds.toInt(),
            min: 1,
            max: 60,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onItemChanged: (newValue) {
              widget.gripDTO.restSeconds = newValue.toDouble();
            },
          ),
        ),
      ],
    );
  }

  /// Spin boxes that allows user to choose break minutes and seconds
  Widget _breakSpinBoxes() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Break', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            unit: 'min.',
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
            initialValue: widget.gripDTO.breakMinutes.toInt(),
            min: 0,
            max: 30,
            onItemChanged: (newValue) {
              widget.gripDTO.breakMinutes = newValue.toDouble();
            },
          ),
        ),
        Expanded(
          child: NumberPicker(
            unit: 'sec.',
            initialValue: widget.gripDTO.breakSeconds.toInt(),
            min: 1,
            max: 60,
            padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
            onItemChanged: (newValue) {
              widget.gripDTO.breakSeconds = newValue.toDouble();
            },
          ),
        ),
      ],
    );
  }

  /// Spin boxes that allow user to choose break minutes and seconds that occur
  /// after the last rep for the current grip
  Widget _lastBreakSpinBoxes() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Break', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            unit: 'min.',
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0, 8.0),
            initialValue: widget.gripDTO.lastBreakMinutes.toInt(),
            min: 0,
            max: 30,
            onItemChanged: (newValue) {
              widget.gripDTO.lastBreakMinutes = newValue.toDouble();
            },
          ),
        ),
        Expanded(
          child: NumberPicker(
            unit: 'sec.',
            initialValue: widget.gripDTO.lastBreakSeconds.toInt(),
            min: 1,
            max: 60,
            padding: const EdgeInsets.fromLTRB(0, 8.0, 16.0, 8.0),
            onItemChanged: (newValue) {
              widget.gripDTO.lastBreakSeconds = newValue.toDouble();
            },
          ),
        ),
      ],
    );
  }
}
