import 'package:flutter/cupertino.dart';
import '../styles/color_theme.dart';

/// A widget that contains the Start, Reset, and Skip buttons that can change
/// depending on the state of the timer
class TimerControlButtons extends StatefulWidget {
  final bool hasStarted;
  final bool isPaused;
  final Function startTimer;
  final Function pauseTimer;
  final Function resumeTimer;
  final Function resetTimer;
  final Function skipDuration;

  const TimerControlButtons(
      {super.key,
      required this.hasStarted,
      required this.isPaused,
      required this.startTimer,
      required this.pauseTimer,
      required this.resumeTimer,
      required this.resetTimer,
      required this.skipDuration});

  @override
  State<TimerControlButtons> createState() => _TimerControlButtonsState();
}

class _TimerControlButtonsState extends State<TimerControlButtons> {
  final double _buttonHeight = 45.0;

  @override
  Widget build(BuildContext context) {
    // Only show Start button if timer has not started yet
    if (widget.hasStarted) {
      if (widget.isPaused) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: double.infinity,
              height: _buttonHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: AppColorTheme.green,
                    onPressed: () {
                      widget.resumeTimer();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Resume ', style: TextStyle(fontSize: 20.0)),
                        Icon(
                          CupertinoIcons.play_arrow_solid,
                          size: 30.0,
                        ),
                      ],
                    )),
              ),
            ),
            resetAndSkipButtons(),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: double.infinity,
              height: _buttonHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    color: AppColorTheme.yellow,
                    onPressed: () {
                      widget.pauseTimer();
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pause ', style: TextStyle(fontSize: 20.0)),
                        Icon(CupertinoIcons.pause_fill)
                      ],
                    )),
              ),
            ),
            resetAndSkipButtons(),
          ],
        );
      }
    } else {
      return Center(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CupertinoButton(
                color: AppColorTheme.blue,
                onPressed: () {
                  widget.startTimer();
                },
                child: const Text('START', style: TextStyle(fontSize: 20.0))),
          ),
        ),
      );
    }
  }

  /// Defines a Widget containing the Reset and Skip buttons
  Widget resetAndSkipButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: _buttonHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppColorTheme.red,
                  onPressed: () {
                    widget.resetTimer();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Reset ', style: TextStyle(fontSize: 20.0)),
                      Icon(
                        CupertinoIcons.arrow_counterclockwise,
                        size: 30.0,
                      )
                    ],
                  )),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: _buttonHeight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  color: AppColorTheme.blue,
                  onPressed: () {
                    widget.skipDuration();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Skip ', style: TextStyle(fontSize: 20.0)),
                      Icon(CupertinoIcons.arrow_right, size: 30.0),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
