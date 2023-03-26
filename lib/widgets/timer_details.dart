import 'package:flutter/material.dart';
import '../widgets/timer_details_tile.dart';
import '../models/timer_durations.dart';

/// Displays details about the timer's current work, rest, and break durations,
/// and the number of sets and reps left
class TimerDetails extends StatefulWidget {
  final TimerDurations timerDurations;

  const TimerDetails({super.key, required this.timerDurations});

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Colors.grey,
                    text: 'Work ${durationString(
                      widget.timerDurations.workDuration)}',
                    fontSize: 16.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Colors.grey,
                    text: 'Rest ${durationString(
                      widget.timerDurations.restDuration)}',
                    fontSize: 16.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Colors.grey,
                    text: 'Break ${durationString(
                      widget.timerDurations.breakDuration)}',
                    fontSize: 16.0,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Set 1/${widget.timerDurations.sets.toInt()}',
                    fontSize: 20.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Rep 2/${widget.timerDurations.reps.toInt()}',
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
