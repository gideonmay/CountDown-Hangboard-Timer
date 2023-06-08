import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../utils/sound_utils.dart';

/// A widget containing minutes and seconds text that allows the user to choose
/// a duration using a Cupertino time picker widget
class DurationPicker extends StatefulWidget {
  final int minutes;
  final int seconds;
  final EdgeInsets padding;
  final void Function(Duration newDuration) onDurationChanged;

  const DurationPicker(
      {super.key,
      required this.padding,
      required this.minutes,
      required this.seconds,
      required this.onDurationChanged});

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _duration = Duration(minutes: widget.minutes, seconds: widget.seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            color: Color.fromRGBO(234, 234, 236, 1.0)),
        height: 40,
        child: Row(children: [
          _durationText(),
          _editDurationButtons(),
        ]),
      ),
    );
  }

  /// A text widget containing the minutes and seconds for the duration
  Widget _durationText() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          _minuteText(constraints),
          _minuteUnitText(constraints),
          _secondText(constraints),
          _secondUnitText(constraints),
        ],
      );
    }));
  }

  /// Text containing the minute portion of the duration
  Widget _minuteText(BoxConstraints constraints) {
    return Positioned(
      top: 4.75,
      right: constraints.maxWidth / 2 + 50,
      child: Text(
        '${_duration.inMinutes}',
        style: const TextStyle(fontSize: 26.0),
      ),
    );
  }

  /// Returns position text displaying the 'min.' unit
  Widget _minuteUnitText(BoxConstraints constraints) {
    return Positioned(
        top: 13,
        left: constraints.maxWidth / 2 - 48,
        child: const Text(
          'min.',
          style: TextStyle(fontSize: 18.0),
        ));
  }

  /// Text containing the second portion of the duration
  Widget _secondText(BoxConstraints constraints) {
    return Positioned(
      top: 4.75,
      right: constraints.maxWidth / 2 - 25,
      child: Text(
        // Pad seconds with a zero if necessary
        (_duration.inSeconds % 60).toString().padLeft(2, '0'),
        style: const TextStyle(fontSize: 26.0),
      ),
    );
  }

  /// Returns position text displaying the 'sec.' unit
  Widget _secondUnitText(BoxConstraints constraints) {
    return Positioned(
        top: 13,
        left: constraints.maxWidth / 2 + 28,
        child: const Text(
          'sec.',
          style: TextStyle(fontSize: 18.0),
        ));
  }

  /// A plus and a minus button in a single row
  Widget _editDurationButtons() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          color: Color.fromRGBO(214, 214, 215, 1.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _editDurationButton(),
        ],
      ),
    );
  }

  /// A button to decrease the value
  Widget _editDurationButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        borderRadius: const BorderRadius.all(Radius.circular(7.0)),
        onTap: () => _showDialog(
          CupertinoTimerPicker(
            mode: CupertinoTimerPickerMode.ms,
            initialTimerDuration: _duration,
            onTimerDurationChanged: (Duration newDuration) {
              playButtonSound();
              setState(() => _duration = newDuration);
              widget.onDurationChanged(newDuration);
            },
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Icon(Icons.schedule),
          ),
        ),
      ),
    );
  }

  /// Shows a CupertinoModalPopup with a fixed height which hosts a
  /// CupertinoTimerPicker. Copied from Flutter documentation:
  /// https://api.flutter.dev/flutter/cupertino/CupertinoTimerPicker-class.html
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
