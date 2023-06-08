import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/grip_dto.dart';
import 'app_divider.dart';
import 'app_header.dart';
import 'duration_picker.dart';
import 'number_picker.dart';
import 'number_picker_title.dart';

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
        _edgeSize(),
        _setsNumberPicker(),
        _repsNumberPicker(),
        _workNumberPicker(),
        _restNumberPicker(),
        _breakDurationPicker(),
        const AppDivider(),
        const AppHeader(title: 'Post-Grip Break'),
        const Text(
          'The break duration between this grip and the next',
          textAlign: TextAlign.center,
        ),
        _lastBreakDurationPicker(),
      ],
    );
  }

  /// A text input to enter the edge depth for this grip
  Widget _edgeSize() {
    return Row(
      children: [
        const NumberPickerTitle(
            title: 'Edge Size', subtitle: '(optional)', maxWidth: 110.0),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 24.0, 8.0),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Positioned(
                    top: 11.5,
                    right: constraints.maxWidth / 2 - 55,
                    child: const Text('mm', style: TextStyle(fontSize: 20.0))),
                TextFormField(
                  decoration:
                      const InputDecoration(filled: true, counterText: ''),
                  maxLength: 2,
                  style: const TextStyle(fontSize: 24.0, height: 1.0),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  initialValue: _initialEdgeSize(),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    /*
                     * Remove leading zeroes. Obtained from following source:
                     * https://stackoverflow.com/questions/64367743/remove-the-first-zeros-of-phone-input-textformfield-of-type-numbers-flutter
                     */
                    FilteringTextInputFormatter.deny(RegExp(r'^0+'))
                  ],
                  onFieldSubmitted: (value) {},
                  onSaved: (newValue) {
                    if (newValue != null) {
                      int? edgeSize = int.tryParse(newValue);
                      widget.gripDTO.edgeSize = edgeSize;
                    }
                  },
                  validator: (value) {
                    if (value != null) {
                      int? edgeSize = int.tryParse(value);

                      if (edgeSize != null && edgeSize <= 0) {
                        return 'Edge size must be a positive number';
                      }
                    }

                    return null;
                  },
                ),
              ],
            );
          }),
        )),
      ],
    );
  }

  /// Returns the edge size if not null. Otherwise, returns en empty string
  String _initialEdgeSize() {
    return widget.gripDTO.edgeSize != null
        ? widget.gripDTO.edgeSize.toString()
        : '';
  }

  /// NumberPicker that allows user to choose number of sets
  Widget _setsNumberPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Sets', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            initialValue: widget.gripDTO.sets.toInt(),
            minValue: 1,
            maxValue: 20,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onValueChanged: (newValue) {
              widget.gripDTO.sets = newValue;
            },
          ),
        ),
      ],
    );
  }

  /// NumberPicker that allows user to choose number of reps
  Widget _repsNumberPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Reps', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            initialValue: widget.gripDTO.reps.toInt(),
            minValue: 1,
            maxValue: 20,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onValueChanged: (newValue) {
              widget.gripDTO.reps = newValue;
            },
          ),
        ),
      ],
    );
  }

  /// NumberPicker that allows user to choose work seconds
  Widget _workNumberPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Work', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            unit: 'sec.',
            initialValue: widget.gripDTO.workSeconds.toInt(),
            minValue: 1,
            maxValue: 60,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onValueChanged: (newValue) {
              widget.gripDTO.workSeconds = newValue;
            },
          ),
        ),
      ],
    );
  }

  /// NumberPicker that allows user to choose rest seconds
  Widget _restNumberPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Rest', maxWidth: 60.0),
        Expanded(
          child: NumberPicker(
            unit: 'sec.',
            initialValue: widget.gripDTO.restSeconds.toInt(),
            minValue: 1,
            maxValue: 60,
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            onValueChanged: (newValue) {
              widget.gripDTO.restSeconds = newValue;
            },
          ),
        ),
      ],
    );
  }

  /// Spin boxes that allows user to choose break minutes and seconds
  Widget _breakDurationPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Break', maxWidth: 60.0),
        Expanded(
          child: DurationPicker(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            minutes: widget.gripDTO.breakMinutes,
            seconds: widget.gripDTO.breakSeconds,
            onDurationChanged: (newDuration) {
              widget.gripDTO.breakMinutes = newDuration.inMinutes;
              widget.gripDTO.breakSeconds = newDuration.inSeconds % 60;
            },
          ),
        ),
      ],
    );
  }

  /// Spin boxes that allow user to choose break minutes and seconds that occur
  /// after the last rep for the current grip
  Widget _lastBreakDurationPicker() {
    return Row(
      children: [
        const NumberPickerTitle(title: 'Break', maxWidth: 60.0),
        Expanded(
          child: DurationPicker(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
            minutes: widget.gripDTO.lastBreakMinutes,
            seconds: widget.gripDTO.lastBreakSeconds,
            onDurationChanged: (newDuration) {
              widget.gripDTO.lastBreakMinutes = newDuration.inMinutes;
              widget.gripDTO.lastBreakSeconds = newDuration.inSeconds % 60;
            },
          ),
        ),
      ],
    );
  }
}
