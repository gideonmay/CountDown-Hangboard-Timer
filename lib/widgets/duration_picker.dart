import 'package:flutter/cupertino.dart';
import '../utils/dialog_utils.dart';

/// A widget containing minutes and seconds text that allows the user to choose
/// a duration using a Cupertino time picker widget
class DurationPicker extends StatefulWidget {
  final int minutes;
  final int seconds;
  final String title;
  final void Function(Duration newDuration) onDurationChanged;

  const DurationPicker(
      {super.key,
      required this.minutes,
      required this.seconds,
      required this.onDurationChanged,
      required this.title});

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
    return CupertinoListTile(
        title: Text(widget.title),
        trailing: Expanded(
            child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: _durationText(),
                onPressed: () => showBottomDialog(
                      context,
                      CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.ms,
                        initialTimerDuration: _duration,
                        onTimerDurationChanged: (Duration newDuration) {
                          setState(() => _duration = newDuration);
                          widget.onDurationChanged(newDuration);
                        },
                      ),
                    ))));
  }

  /// A text widget containing the minutes and seconds for the duration
  Widget _durationText() {
    return Text(
      '${_duration.inMinutes}min. ${_duration.inSeconds % 60}sec.',
      style: const TextStyle(fontSize: 20.0),
    );
  }
}
