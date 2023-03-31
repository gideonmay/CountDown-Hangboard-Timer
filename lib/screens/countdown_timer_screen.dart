import 'package:flutter/material.dart';
import '../widgets/timer_details.dart';
import '../models/duration_status_list.dart';
import '../models/timer_durations_dto.dart';
import '../widgets/countdown_timer.dart';

/// Provides a layout for the countdown timer, timer details, and timer control
/// buttons. Contains the state variable necessary to start a countdown timer.
class CountdownTimerScreen extends StatefulWidget {
  final TimerDurationsDTO timerDurations;

  const CountdownTimerScreen({super.key, required this.timerDurations});

  @override
  State<CountdownTimerScreen> createState() => _CountdownTimerScreenState();
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  int _currentSet = 1;
  int _currentRep = 1;
  late DurationStatusList _durationStatusList;

  void incrementSet(int newValue) {
    setState(() {
      _currentSet++;
    });
  }

  void incrementRep(int newValue) {
    setState(() {
      _currentRep++;
    });
  }

  @override
  void initState() {
    super.initState();
    _durationStatusList = DurationStatusList(
        sets: widget.timerDurations.sets.toInt(),
        reps: widget.timerDurations.reps.toInt(),
        workDuration: widget.timerDurations.workDuration,
        restDuration: widget.timerDurations.restDuration,
        breakDuration: widget.timerDurations.breakDuration,
        includePrepare: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 18,
              child: TimerDetails(
                  timerDurations: widget.timerDurations,
                  currentSet: _currentSet,
                  currentRep: _currentRep),
            ),
            Flexible(
              flex: 88,
              child: CountdownTimer(durationStatusList: _durationStatusList),
            ),
          ],
        ),
      ),
    );
  }
}
