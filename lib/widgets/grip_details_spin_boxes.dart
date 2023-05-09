import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import '../models/grip_dto.dart';

/// A series of spin boxes allowing the user to choose sets and reps, and the
/// work, rest, and break durations for a particular grip
class GripDetailsSpinBoxes extends StatefulWidget {
  final GripDTO gripDTO;

  const GripDetailsSpinBoxes({super.key, required this.gripDTO});

  @override
  State<GripDetailsSpinBoxes> createState() => _GripDetailsSpinBoxesState();
}

class _GripDetailsSpinBoxesState extends State<GripDetailsSpinBoxes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _setsSpinBox(),
        _repsSpinBox(),
        _workSpinBox(),
        _restSpinBox(),
        _breakSpinBoxes(),
        const Divider(thickness: 1.0, indent: 5.0, endIndent: 5.0),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: Text('Post-Grip Break',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child:
              Text('Specify the break duration between this grip and the next'),
        ),
        _lastBreakSpinBoxes(),
      ],
    );
  }

  /// Spin box that allows user to choose number of sets
  Widget _setsSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.sets,
        min: 1,
        max: 20,
        onChanged: (value) {
          setState(() {
            // Do not allow value of zero or lower
            if (value <= 0) {
              widget.gripDTO.sets = 1;
            } else {
              widget.gripDTO.sets = value;
            }
          });
        },
        decoration: const InputDecoration(
            labelText: 'Sets', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin box that allows user to choose number of sets
  Widget _repsSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.reps,
        min: 1,
        max: 20,
        onChanged: (value) {
          setState(() {
            // Do not allow value of zero or lower
            if (value <= 0) {
              widget.gripDTO.reps = 1;
            } else {
              widget.gripDTO.reps = value;
            }
          });
        },
        decoration: const InputDecoration(
            labelText: 'Reps', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin box that allow user to choose work seconds
  Widget _workSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.workSeconds,
        min: 1,
        max: 60,
        onChanged: (value) {
          setState(() {
            widget.gripDTO.workSeconds = value;
          });
        },
        decoration: const InputDecoration(
            labelText: 'Work (sec)', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin box that allow user to choose rest seconds
  Widget _restSpinBox() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SpinBox(
        value: widget.gripDTO.restSeconds,
        min: 1,
        max: 60,
        onChanged: (value) {
          setState(() {
            widget.gripDTO.restSeconds = value;
          });
        },
        decoration: const InputDecoration(
            labelText: 'Rest (sec)', labelStyle: TextStyle(fontSize: 24.0)),
      ),
    );
  }

  /// Spin boxes that allows user to choose break minutes and seconds
  Widget _breakSpinBoxes() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: SpinBox(
              value: widget.gripDTO.breakMinutes,
              min: 0,
              max: 30,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.breakMinutes = value;
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
              value: widget.gripDTO.breakSeconds,
              min: 0,
              max: 60,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.breakSeconds = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Break (sec)',
                  labelStyle: TextStyle(fontSize: 24.0)),
            ),
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 16.0),
            child: SpinBox(
              value: widget.gripDTO.lastBreakMinutes,
              min: 0,
              max: 30,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.lastBreakMinutes = value;
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
              value: widget.gripDTO.lastBreakSeconds,
              min: 0,
              max: 60,
              onChanged: (value) {
                setState(() {
                  widget.gripDTO.lastBreakSeconds = value;
                });
              },
              decoration: const InputDecoration(
                  labelText: 'Break (sec)',
                  labelStyle: TextStyle(fontSize: 24.0)),
            ),
          ),
        ),
      ],
    );
  }
}
