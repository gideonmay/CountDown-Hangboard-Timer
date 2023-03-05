import 'package:flutter/material.dart';
import '../widgets/timer_details.dart';
import '../widgets/timer_control_buttons.dart';

/// Provides a layout for the countdown timer, timer details, and timer control 
/// buttons.
class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Flexible(
              flex: 20,
              child: TimerDetails(),
            ),
            Flexible(
              flex: 55,
              child: Placeholder(child: Text('Timer Here')),
            ),
            Flexible(
              flex: 25,
              child: TimerControlButtons(),
            ),
          ],
        ),
      ),
    );
  }
}
