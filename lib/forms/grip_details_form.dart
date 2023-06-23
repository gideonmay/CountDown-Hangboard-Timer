import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../db/drift_database.dart';
import '../widgets/duration_picker.dart';
import '../models/grip_dto.dart';
import '../widgets/grip_type_picker.dart';
import '../widgets/number_picker.dart';

/// A form that allows user to input grip information
class GripDetailsForm extends StatefulWidget {
  final GripDTO gripDTO;
  final String buttonText;

  /// The stream of grip types to populate the dropdown with
  final Stream<List<GripTypeWithGripCount>> gripTypeStream;

  /// Function to be executed when form is saved to write grip to database
  final Function onFormSaved;

  const GripDetailsForm(
      {super.key,
      required this.gripDTO,
      required this.onFormSaved,
      required this.buttonText,
      required this.gripTypeStream});

  @override
  State<GripDetailsForm> createState() => _GripDetailsFormState();
}

class _GripDetailsFormState extends State<GripDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String? _gripTypeErrorText;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          CupertinoFormSection.insetGrouped(
            header: const Text('GRIP TYPE DETAILS'),
            children: [
              GripTypePicker(
                  errorText: _gripTypeErrorText,
                  gripDTO: widget.gripDTO,
                  gripTypeStream: widget.gripTypeStream),
              _edgeSizeInput(),
            ],
          ),
          CupertinoFormSection.insetGrouped(
              header: const Text('TIMER SETUP'),
              footer: const Text(
                  '"Last Break" occurs between this grip and the next'),
              children: [
                _setsPicker(),
                _repsPicker(),
                _workDurationPicker(),
                _restDurationPicker(),
                _breakDurationPicker(),
                _lastBreakDurationPicker(),
              ]),
          _submitButton(),
        ],
      ),
    );
  }

  Widget _edgeSizeInput() {
    return CupertinoTextFormFieldRow(
      initialValue: _initialEdgeSize(),
      maxLength: 2,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
      prefix: const Text('Edge Size (mm)'),
      placeholder: 'optional',
      textAlign: TextAlign.center,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        /*
         * Remove leading zeroes. Obtained from following source:
         * https://stackoverflow.com/questions/64367743/remove-the-first-zeros-of-phone-input-textformfield-of-type-numbers-flutter
         */
        FilteringTextInputFormatter.deny(RegExp(r'^0+'))
      ],
      validator: (value) {
        if (value != null) {
          int? edgeSize = int.tryParse(value);

          if (edgeSize != null && edgeSize <= 0) {
            return 'Edge size must be a positive number';
          }
        }

        return null;
      },
      onSaved: (newValue) {
        if (newValue != null) {
          int? edgeSize = int.tryParse(newValue);
          widget.gripDTO.edgeSize = edgeSize;
        }
      },
    );
  }

  /// Returns the edge size if not null. Otherwise, returns en empty string
  String _initialEdgeSize() {
    return widget.gripDTO.edgeSize != null
        ? widget.gripDTO.edgeSize.toString()
        : '';
  }

  Widget _setsPicker() {
    return NumberPicker(
      title: 'Sets',
      initialValue: widget.gripDTO.sets,
      minValue: 1,
      maxValue: 20,
      onValueChanged: (newValue) {
        widget.gripDTO.sets = newValue;
      },
    );
  }

  Widget _repsPicker() {
    return NumberPicker(
      title: 'Reps',
      initialValue: widget.gripDTO.reps,
      minValue: 1,
      maxValue: 20,
      onValueChanged: (newValue) {
        widget.gripDTO.reps = newValue;
      },
    );
  }

  Widget _workDurationPicker() {
    return NumberPicker(
      title: 'Work (sec.)',
      initialValue: widget.gripDTO.workSeconds,
      minValue: 1,
      maxValue: 60,
      onValueChanged: (newValue) {
        widget.gripDTO.workSeconds = newValue;
      },
    );
  }

  Widget _restDurationPicker() {
    return NumberPicker(
      title: 'Rest (sec.)',
      initialValue: widget.gripDTO.restSeconds,
      minValue: 1,
      maxValue: 60,
      onValueChanged: (newValue) {
        widget.gripDTO.restSeconds = newValue;
      },
    );
  }

  Widget _breakDurationPicker() {
    return DurationPicker(
      title: 'Break',
      minutes: widget.gripDTO.breakMinutes,
      seconds: widget.gripDTO.breakSeconds,
      onDurationChanged: (newDuration) {
        widget.gripDTO.breakMinutes = newDuration.inMinutes;
        widget.gripDTO.breakSeconds = newDuration.inSeconds % 60;
      },
    );
  }

  Widget _lastBreakDurationPicker() {
    return DurationPicker(
      title: 'Last Break',
      minutes: widget.gripDTO.lastBreakMinutes,
      seconds: widget.gripDTO.lastBreakSeconds,
      onDurationChanged: (newDuration) {
        widget.gripDTO.lastBreakMinutes = newDuration.inMinutes;
        widget.gripDTO.lastBreakSeconds = newDuration.inSeconds % 60;
      },
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: CupertinoButton.filled(
          onPressed: () {
            // Show error message if use has not chosen a grip type
            if (widget.gripDTO.gripTypeID == null) {
              setState(() {
                _gripTypeErrorText = 'Please choose a grip type';
              });
              return;
            }

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
