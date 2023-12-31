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
  final double width;

  const TimerDetails(
      {super.key,
      required this.currSet,
      required this.currRep,
      required this.timerDetails,
      this.currGrip,
      required this.width});

  @override
  State<TimerDetails> createState() => _TimerDetailsState();
}

class _TimerDetailsState extends State<TimerDetails> {
  /// The factor used to determine the font size
  final double _fontHeightFactor = 0.17;

  /// The width of the title in the TimeTextRow widget
  final double _titleWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
            child: _timerProgressCounters(),
          ),
        ),
      ],
    );
  }

  /// A widget containing the progress counters for sets, reps, and grips
  Widget _timerProgressCounters() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return _progressCounters(constraints.maxHeight * _fontHeightFactor);
    });
  }

  /// Displays a column of progress counters for sets, reps, and grips. Only
  /// includes the grips progress counter if totalGrips is not null.
  Widget _progressCounters(double fontSize) {
    if (widget.timerDetails.totalGrips != null) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _gripProgressCounter(fontSize),
            _setsProgressCounter(fontSize),
            _repsProgressCounter(fontSize),
          ]);
    }

    return Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _setsProgressCounter(fontSize),
      _repsProgressCounter(fontSize),
    ]);
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

  /// Displays the current vs total sets
  Widget _setsProgressCounter(double fontSize) {
    return ProgressCounter(
        completed: widget.currSet - 1,
        total: widget.timerDetails.totalSets,
        title: 'Sets ',
        fontSize: fontSize,
        fillColor: AppColorTheme.blue);
  }

  /// Displays the current vs total reps
  Widget _repsProgressCounter(double fontSize) {
    return ProgressCounter(
        completed: widget.currRep - 1,
        total: widget.timerDetails.totalReps,
        title: 'Reps ',
        fontSize: fontSize,
        fillColor: AppColorTheme.blue);
  }

  /// A widget containing information about the work, rest, and break durations
  Widget _timerDurationInfo() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TimeTextRow(
              title: 'Work ',
              durationString: durationString(widget.timerDetails.workDuration),
              fontSize: constraints.maxHeight * _fontHeightFactor,
              titleWidth: _titleWidth),
          TimeTextRow(
              title: 'Rest ',
              durationString: durationString(widget.timerDetails.restDuration),
              fontSize: constraints.maxHeight * _fontHeightFactor,
              titleWidth: _titleWidth),
          TimeTextRow(
              title: 'Break ',
              durationString: durationString(widget.timerDetails.breakDuration),
              fontSize: constraints.maxHeight * _fontHeightFactor,
              titleWidth: _titleWidth),
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
