import 'package:flutter/cupertino.dart';
import 'duration_status.dart';
import 'status_value.dart';
import 'timer_details_dto.dart';
import '../db/drift_database.dart';
import '../styles/color_theme.dart';

// Colors corresponding to different status values
Color workColor = AppColorTheme.green;
Color restColor = AppColorTheme.yellow;
Color breakColor = AppColorTheme.red;
Color prepareColor = AppColorTheme.blue;

/// A class that serves as an object to store the parameters needed to create
/// a DurationStatusList
class DurationStatusListDTO {
  // final int sets;
  // final int reps;
  // final Duration workDuration;
  // final Duration restDuration;
  // final Duration breakDuration;
  final TimerDetailsDTO timerDetails;

  /// Whether to include a final break or mark the workout as complete instead
  final bool includeLastBreak;

  /// The break duration between this list and the next. Only takes effect if
  /// the includeLastBreak variable is set to true.
  final Duration? lastBreakDuration;

  /// Whether or not to include prepare DurationStatus
  final bool includePrepare;

  /// Optional name of the grip that this list of durations is for
  final String? gripName;

  /// Optional name of the next grip succeeding this one
  final String? nextGripName;

  // /// The number of sets in the next grip
  // final int? nextGripSets;

  // /// The number of reps in the next grip
  // final int? nextGripReps;

  /// The current grip number in the workout
  final int? currGrip;

  /// Timer details regarding the next grip in the workout, if that grip exists
  final TimerDetailsDTO? nextGripDetails;

  DurationStatusListDTO(
      {
      // required this.sets,
      // required this.reps,
      // required this.workDuration,
      // required this.restDuration,
      // required this.breakDuration,
      required this.timerDetails,
      required this.includePrepare,
      required this.includeLastBreak,
      this.lastBreakDuration,
      this.gripName,
      this.nextGripName,
      // this.nextGripSets,
      // this.nextGripReps,
      this.currGrip,
      this.nextGripDetails}) {
    _assertLastBreakDuration();
  }

  /// Shows error if lastBreakDuration was not included when includeLastBreak ==
  /// true
  void _assertLastBreakDuration() {
    if (includeLastBreak && lastBreakDuration == null) {
      throw AssertionError(
          "Last break duration is required when includeLastBreak is true");
    }
  }
}

/// An abstract class that defines an object containing a list of DurationStatus
/// objects as one of the class members
abstract class DurationStatusList {
  final List<DurationStatus> _durationStatusList = [];

  /// The total number of seconds that have passed for current countdown timer
  int _totalSeconds = 0;

  /// Returns the length of this list
  int get length => _durationStatusList.length;

  /// Returns the underlying list of DurationStatus objects
  List<DurationStatus> toList() => _durationStatusList;

  /// Indexing operater
  DurationStatus operator [](index) => _durationStatusList[index];

  /// The total number of seconds contained in the list
  int get totalSeconds => _totalSeconds;

  /// Builds a list of DurationStatus objects using the given parameters
  void _buildDurationStatusList(DurationStatusListDTO params) {
    // Add 'prepare' DurationStatus if includePrepare was specified
    if (params.includePrepare &&
        params.timerDetails.totalSets > 0 &&
        params.timerDetails.totalReps > 0) {
      _durationStatusList.add(DurationStatus(
          duration: const Duration(seconds: 15),
          statusValue: StatusValue.isPreparing(),
          statusColor: prepareColor,
          startTime: Duration(seconds: _totalSeconds),
          timerDetails: params.timerDetails,
          currSet: 1,
          currRep: 1,
          currGrip: 1,
          gripName: params.gripName,
          nextGripName: null));

      _totalSeconds += 15;
    }

    int currSet = 1;
    while (currSet <= params.timerDetails.totalSets) {
      // Add initial work duration due to fence post problem
      int currRep = 1;
      if (params.timerDetails.totalReps > 0) {
        _durationStatusList.add(DurationStatus(
            duration: params.timerDetails.workDuration,
            statusValue: StatusValue.isWorking(),
            statusColor: workColor,
            startTime: Duration(seconds: _totalSeconds),
            timerDetails: params.timerDetails,
            currSet: currSet,
            currRep: currRep,
            currGrip: params.currGrip,
            gripName: params.gripName,
            nextGripName: params.nextGripName));

        _totalSeconds += params.timerDetails.workDuration.inSeconds;
        currRep += 1;
      }

      while (currRep <= params.timerDetails.totalReps) {
        _durationStatusList.add(DurationStatus(
            duration: params.timerDetails.restDuration,
            statusValue: StatusValue.isResting(),
            statusColor: restColor,
            startTime: Duration(seconds: _totalSeconds),
            timerDetails: params.timerDetails,
            currSet: currSet,
            currRep: currRep,
            currGrip: params.currGrip,
            gripName: params.gripName,
            nextGripName: params.nextGripName));
        _totalSeconds += params.timerDetails.restDuration.inSeconds;

        _durationStatusList.add(DurationStatus(
            duration: params.timerDetails.workDuration,
            statusValue: StatusValue.isWorking(),
            statusColor: workColor,
            startTime: Duration(seconds: _totalSeconds),
            timerDetails: params.timerDetails,
            currSet: currSet,
            currRep: currRep,
            currGrip: params.currGrip,
            gripName: params.gripName,
            nextGripName: params.nextGripName));

        _totalSeconds += params.timerDetails.workDuration.inSeconds;
        currRep += 1;
      }

      currSet += 1;

      // Add break duration after all but last set
      if (currSet <= params.timerDetails.totalSets) {
        _durationStatusList.add(DurationStatus(
            duration: params.timerDetails.breakDuration,
            statusValue: StatusValue.isBreak(),
            statusColor: breakColor,
            startTime: Duration(seconds: _totalSeconds),
            timerDetails: params.timerDetails,
            currSet: currSet,
            currRep: 1,
            currGrip: params.currGrip,
            gripName: params.gripName,
            nextGripName: params.nextGripName));

        _totalSeconds += params.timerDetails.breakDuration.inSeconds;
      }
    }

    /*
     * Add lastBreakDuration if includeLastBreak == true. Otherwise, add a 
     * duration to mark the workout as complete
     */
    if (params.includeLastBreak) {
      _durationStatusList.add(DurationStatus(
          duration: params.lastBreakDuration!,
          statusValue: StatusValue.isBreak(),
          statusColor: breakColor,
          startTime: Duration(seconds: _totalSeconds),
          // Pass the timer details for next grip if that grip exists
          timerDetails: params.nextGripDetails ?? params.timerDetails,
          currSet: 1,
          currRep: 1,
          // Set currGrip to zero if it was not given and is null
          currGrip: params.currGrip == null ? 0 : params.currGrip! + 1,
          gripName: params.nextGripName,
          nextGripName: null));

      _totalSeconds += params.lastBreakDuration!.inSeconds;
    } else {
      _durationStatusList.add(DurationStatus(
          duration: Duration.zero,
          statusValue: StatusValue.isComplete(),
          statusColor: prepareColor,
          startTime: Duration(seconds: _totalSeconds),
          timerDetails: params.timerDetails,
          currSet: params.timerDetails.totalSets + 1,
          currRep: params.timerDetails.totalReps + 1,
          currGrip: params.currGrip == null ? null : params.currGrip! + 1));
    }
  }
}

/// Represents a list of DurationStatus objects that can be 'fed' into the
/// countdown timer. This object takes the given values for reps, sets,
/// workDuration, restDuration, and breakDuration to build the list of
/// DurationStatus objects that are fed into the countdown timer.
class TimerDurationStatusList extends DurationStatusList {
  final DurationStatusListDTO durationStatusListDTO;

  TimerDurationStatusList({required this.durationStatusListDTO}) {
    _buildDurationStatusList(durationStatusListDTO);
  }
}

/// Represents a List of DurationStatus objects that is built from the Grips
/// within an individual Workout. This class is very similar to the
/// TimerDurationStatusList class in that it contains a List of DurationStatus
/// objects. However, this class contructs the List from a given List of Grips
/// as opposed to the number of sets, reps, work duration, etc.
class WorkoutDurationStatusList extends DurationStatusList {
  /// The list of Grip objects to build the DurationStatusList from
  final List<GripWithGripType> gripList;

  WorkoutDurationStatusList({required this.gripList}) {
    _buildList();
  }

  /// The number of Grips in the given list of Grips
  int get gripCount => gripList.length;

  /// Iterates over each Grip in the given gripList and adds the
  void _buildList() {
    for (int index = 0; index < gripList.length; index++) {
      Grip grip = gripList[index].entry;
      GripType gripType = gripList[index].gripType;

      final currGripDetails = TimerDetailsDTO(
          totalSets: grip.setCount,
          totalReps: grip.repCount,
          totalGrips: gripList.length,
          workDuration: Duration(seconds: grip.workSeconds),
          restDuration: Duration(seconds: grip.restSeconds),
          breakDuration:
              Duration(minutes: grip.breakMinutes, seconds: grip.breakSeconds));

      // Obtain details for the next grip in the workout, if that grip exists
      Grip? nextGrip;
      TimerDetailsDTO? nextGripDetails;

      if (index < gripList.length - 1) {
        nextGrip = gripList[index + 1].entry;
        nextGripDetails = TimerDetailsDTO(
            totalSets: nextGrip.setCount,
            totalReps: nextGrip.repCount,
            totalGrips: gripList.length,
            workDuration: Duration(seconds: nextGrip.workSeconds),
            restDuration: Duration(seconds: nextGrip.restSeconds),
            breakDuration: Duration(
                minutes: nextGrip.breakMinutes,
                seconds: nextGrip.breakSeconds));
      }

      _buildDurationStatusList(DurationStatusListDTO(
          timerDetails: currGripDetails,
          includePrepare: index == 0, // Only include preapre for first grip
          includeLastBreak: _isLastGrip(index),
          lastBreakDuration: Duration(
              minutes: grip.lastBreakMinutes, seconds: grip.lastBreakSeconds),
          gripName: _gripNameWithEdgeSize(gripType.name, grip.edgeSize),
          nextGripName: _getNextGripName(index),
          currGrip: index + 1,
          nextGripDetails: nextGripDetails));
    }
  }

  /// Appends the edge size to the end of the grip name if an edge size exists
  String _gripNameWithEdgeSize(String gripName, int? edgeSize) {
    if (edgeSize != null) {
      return '$gripName - ${edgeSize}mm';
    }

    return gripName;
  }

  /// Returns true if the given index is not the last index in the grip list
  bool _isLastGrip(int index) {
    return index < gripList.length - 1;
  }

  /// Returns the name of the grip succeeding the given index, or null if the
  /// index is at the end of the list
  String? _getNextGripName(int index) {
    if (index >= gripList.length - 1) {
      return null;
    }

    final nextGrip = gripList[index + 1];
    return _gripNameWithEdgeSize(
        nextGrip.gripType.name, nextGrip.entry.edgeSize);
  }
}
