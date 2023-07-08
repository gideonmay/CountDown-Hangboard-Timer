import 'package:flutter/material.dart';
import '../models/timer_details_dto.dart';
import '../styles/color_theme.dart';
import '../widgets/progress_counter.dart';
import '../widgets/time_text_row.dart';

/// Displays details about the timer's current work, rest, and break durations,
/// and the number of sets and reps left
class TimerDetails extends StatefulWidget {
  final int currSet;
  final int currRep;
  final TimerDetailsDTO timerDetails;
  final int? currGrip;

  const TimerDetails(
      {super.key,
      required this.currSet,
      required this.currRep,
      required this.timerDetails,
      this.currGrip});

  @override
  State<TimerDetails> createState() => _TimerDetailsState();
}

class _TimerDetailsState extends State<TimerDetails> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _timerDurationInfo(),
        ),
        const VerticalDivider(
          thickness: 1.5,
          indent: 5.0,
          endIndent: 5.0,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _setRepStatus(),
          ),
        ),
      ],
    );
  }

  /// A widget containing the current rep and set status info
  Widget _setRepStatus() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _gripProgressCounter(constraints.maxHeight / 5),
          ProgressCounter(
              completed: widget.currSet - 1,
              total: widget.timerDetails.totalSets,
              title: 'Sets ',
              fontSize: constraints.maxHeight / 5,
              fillColor: AppColorTheme.blue),
          ProgressCounter(
              completed: widget.currRep - 1,
              total: widget.timerDetails.totalReps,
              title: 'Reps ',
              fontSize: constraints.maxHeight / 5,
              fillColor: AppColorTheme.blue),
        ],
      );
    });
  }

  /// Returns a ProgressCounter for the grips in the workout if the timer
  /// details contains a totalGrips variable
  Widget _gripProgressCounter(double fontSize) {
    if (widget.timerDetails.totalGrips != null) {
      return ProgressCounter(
          completed: widget.currGrip! - 1,
          total: widget.timerDetails.totalGrips!,
          title: 'Grips',
          fontSize: fontSize,
          fillColor: AppColorTheme.green);
    }

    return Container();
  }

  /// A widget containing information about the work, rest, and break durations
  Widget _timerDurationInfo() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TimeTextRow(
              title: 'Work ',
              durationString: durationString(widget.timerDetails.workDuration),
              fontSize: constraints.maxHeight / 6,
              titleWidth: 50.0),
          TimeTextRow(
              title: 'Rest ',
              durationString: durationString(widget.timerDetails.restDuration),
              fontSize: constraints.maxHeight / 6,
              titleWidth: 50.0),
          TimeTextRow(
              title: 'Break ',
              durationString: durationString(widget.timerDetails.breakDuration),
              fontSize: constraints.maxHeight / 6,
              titleWidth: 50.0),
        ],
      );
    });
  }

  /// Converts the given duration into a string with format 'M:SS'
  String durationString(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return '$minutes:${(seconds).toString().padLeft(2, '0')}';
  }
}
