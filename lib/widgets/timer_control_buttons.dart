import 'package:flutter/material.dart';

class TimerControlButtons extends StatefulWidget {
  final bool hasStarted;
  final bool isPaused;
  final Function startTimer;
  final Function pauseTimer;
  final Function resumeTimer;
  final Function resetTimer;

  const TimerControlButtons(
      {super.key,
      required this.hasStarted,
      required this.isPaused,
      required this.startTimer,
      required this.pauseTimer,
      required this.resumeTimer,
      required this.resetTimer});

  @override
  State<TimerControlButtons> createState() => _TimerControlButtonsState();
}

class _TimerControlButtonsState extends State<TimerControlButtons> {
  @override
  Widget build(BuildContext context) {
    // Only show Start button if timer has not started yet
    if (widget.hasStarted) {
      if (widget.isPaused) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                      widget.resumeTimer();
                  },
                  child:
                      const Text('Resume', style: TextStyle(fontSize: 20.0))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                      widget.resetTimer();
                  },
                  child: const Text('Reset', style: TextStyle(fontSize: 20.0))),
            ),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade700,
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                    widget.pauseTimer();
                  },
                  child: const Text('Pause', style: TextStyle(fontSize: 20.0))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size.fromHeight(40)),
                  onPressed: () {
                      widget.resetTimer();
                  },
                  child: const Text('Reset', style: TextStyle(fontSize: 20.0))),
            ),
          ],
        );
      }
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40)),
              onPressed: () {
                widget.startTimer();
              },
              child: const Text('Start', style: TextStyle(fontSize: 20.0))),
        ),
      );
    }
  }
}
