import 'package:flutter/material.dart';
import 'duration_status.dart';
import 'status_value.dart';

// These colors correspond to different status values
Color workColor = Colors.green;
Color restColor = Colors.yellow.shade700;
Color breakColor = Colors.orange.shade900;
Color prepareColor = Colors.blue;

/// Represents a list of DurationStatus objects that can be 'fed' into the
/// countdown timer. This object takes the given values for reps, sets,
/// workDuration, restDuration, and breakDuration to build the list of
/// DurationStatus objects that are fed into the countdown timer.
class DurationStatusList {
  final int sets;
  final int reps;
  final Duration workDuration;
  final Duration restDuration;
  final Duration breakDuration;
  final List<DurationStatus> _durationStatusList = [];
  int _totalSeconds = 0;

  /// Whether or not to include prepare DurationStatus
  final bool includePrepare;

  DurationStatusList(
      {required this.sets,
      required this.reps,
      required this.workDuration,
      required this.restDuration,
      required this.breakDuration,
      required this.includePrepare}) {
    _buildList();
  }

  int get length => _durationStatusList.length;

  /// The total number of seconds contained in the list
  int get totalSeconds => _totalSeconds;

  /// Enable indexing of _durationStatusList
  operator [](index) => _durationStatusList[index];

  /// Builds a list of DurationStatus objects using the given number of sets and
  /// reps. Each list starts with a DurationStatus object with a StatusValue of
  /// 'prepare', which gives the user time seconds to prepare for the first rep.
  void _buildList() {
    // Add 'prepare' DurationStatus if includePrepare was specified
    if (includePrepare && sets > 0 && reps > 0) {
      _durationStatusList.add(DurationStatus(
          duration: const Duration(seconds: 15),
          statusValue: StatusValue.isPreparing(),
          statusColor: prepareColor,
          startTime: Duration(seconds: _totalSeconds)));

      _totalSeconds += 15;
    }

    int currSet = 0;
    while (currSet < sets) {
      // Add initial work duration due to fence post problem
      if (reps > 0) {
        _durationStatusList.add(DurationStatus(
            duration: workDuration,
            statusValue: StatusValue.isWorking(),
            statusColor: workColor,
            startTime: Duration(seconds: _totalSeconds)));

        _totalSeconds += workDuration.inSeconds;
      }

      int currRep = 1;
      while (currRep < reps) {
        _durationStatusList.add(DurationStatus(
            duration: restDuration,
            statusValue: StatusValue.isResting(),
            statusColor: restColor,
            startTime: Duration(seconds: _totalSeconds)));
        _totalSeconds += restDuration.inSeconds;

        _durationStatusList.add(DurationStatus(
            duration: workDuration,
            statusValue: StatusValue.isWorking(),
            statusColor: workColor,
            startTime: Duration(seconds: _totalSeconds)));

        _totalSeconds += workDuration.inSeconds;
        currRep += 1;
      }

      // Do not add break duration after last set
      if (currSet < sets - 1) {
        _durationStatusList.add(DurationStatus(
            duration: breakDuration,
            statusValue: StatusValue.isBreak(),
            statusColor: breakColor,
            startTime: Duration(seconds: _totalSeconds)));

        _totalSeconds += breakDuration.inSeconds;
      }

      currSet += 1;
    }

    // Add final zero duration to mark timer as complete
    _durationStatusList.add(DurationStatus(
        duration: Duration.zero,
        statusValue: StatusValue.isComplete(),
        statusColor: prepareColor,
        startTime: Duration(seconds: _totalSeconds)));
  }
}
