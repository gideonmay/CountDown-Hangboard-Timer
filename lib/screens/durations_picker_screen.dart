import 'package:flutter/material.dart';
import 'countdown_timer_screen.dart';
import '../forms/durations_picker_form.dart';
import '../models/timer_durations_dto.dart';

/// A screen with a form that allows the user to choose the work, rest, and
/// break durations in addition to the number or reps and sets.
class DurationsPickerScreen extends StatefulWidget {
  const DurationsPickerScreen({super.key});

  @override
  State<DurationsPickerScreen> createState() => _DurationsPickerScreenState();
}

class _DurationsPickerScreenState extends State<DurationsPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configure Timer'),
        ),
        body: const DurationsPickerForm(onStartPressed: navigateToTimer));
  }

  /// Navigates to the countdown timer screen
  static navigateToTimer(
      BuildContext context, TimerDurationsDTO timerDurations) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              CountdownTimerScreen(timerDurations: timerDurations)),
    );
  }
}
