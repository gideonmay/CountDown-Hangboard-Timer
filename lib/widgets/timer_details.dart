import 'package:flutter/material.dart';
import '../widgets/timer_details_tile.dart';
import '../models/timer_durations_dto.dart';

/// Displays details about the timer's current work, rest, and break durations,
/// and the number of sets and reps left
class TimerDetails extends StatefulWidget {
  final TimerDurationsDTO timerDurations;
  final int currentSet;
  final int currentRep;

  const TimerDetails(
      {super.key,
      required this.timerDurations,
      required this.currentSet,
      required this.currentRep});

  @override
  State<TimerDetails> createState() => _TimerDetailsState();
}

class _TimerDetailsState extends State<TimerDetails> {
  /// Converts the given duration into a string with format 'M:SS'
  String durationString(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '$minutes:${(seconds).toString().padLeft(2, '0')}';
  }

  /// A widget containing the current rep and set status info
  Widget _setRepStatus() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
            'Set ${widget.currentSet}/${widget.timerDurations.sets.toInt()}',
            style: const TextStyle(fontSize: 20.0)),
        Text(
            'Rep ${widget.currentRep}/${widget.timerDurations.reps.toInt()}',
            style: const TextStyle(fontSize: 20.0)),
      ],
    );
  }

  /// A widget containing information about the work, rest, and break durations
  Widget _timerDurationInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
            'Work ${durationString(widget.timerDurations.workDuration)}',
            style: const TextStyle(fontSize: 16.0)),
        Text(
            'Rest ${durationString(widget.timerDurations.restDuration)}',
            style: const TextStyle(fontSize: 16.0)),
        Text(
            'Break ${durationString(widget.timerDurations.breakDuration)}',
            style: const TextStyle(fontSize: 16.0)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TimerDetailsTile(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 24.0,
              child: _setRepStatus(),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TimerDetailsTile(
              color: Colors.grey,
              fontSize: 16.0,
              child: _timerDurationInfo(),
            ),
          ),
        ),
      ],
    );
  }
}