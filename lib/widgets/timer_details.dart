import 'package:flutter/material.dart';
import '../models/timer_durations_dto.dart';
import '../widgets/progress_counter.dart';
import '../widgets/timer_details_tile.dart';
import '../widgets/time_text_row.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProgressCounter(
            completed: widget.currentSet - 1,
            total: widget.timerDurations.sets.toInt(),
            title: 'Sets ',
            fontSize: 20.0),
        ProgressCounter(
            completed: widget.currentRep - 1,
            total: widget.timerDurations.reps.toInt(),
            title: 'Reps ',
            fontSize: 20.0),
      ],
    );
  }

  /// A widget containing information about the work, rest, and break durations
  Widget _timerDurationInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TimeTextRow(
          title: 'Work ',
          durationString: durationString(widget.timerDurations.workDuration),
          fontSize: 16.0,
          titleWidth: 50.0
        ),
        TimeTextRow(
          title: 'Rest ',
          durationString: durationString(widget.timerDurations.restDuration),
          fontSize: 16.0,
          titleWidth: 50.0
        ),
        TimeTextRow(
          title: 'Break ',
          durationString: durationString(widget.timerDurations.breakDuration),
          fontSize: 16.0,
          titleWidth: 50.0
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TimerDetailsTile(
            fontSize: 16.0,
            child: _timerDurationInfo(),
          ),
        ),
        const VerticalDivider(
          thickness: 1.5,
          indent: 5.0,
          endIndent: 5.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TimerDetailsTile(
              color: null,
              fontSize: 24.0,
              child: _setRepStatus(),
            ),
          ),
        ),
      ],
    );
  }
}
