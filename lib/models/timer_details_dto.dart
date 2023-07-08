/// A data transfer object for storing and retrieving info that is displayed
/// above the countdown timer in the TimerDetails widget
class TimerDetailsDTO {
  final int totalSets;
  final int totalReps;
  final int? totalGrips;
  final Duration workDuration;
  final Duration restDuration;
  final Duration breakDuration;

  TimerDetailsDTO({
    required this.totalSets,
    required this.totalReps,
    this.totalGrips,
    required this.workDuration,
    required this.restDuration,
    required this.breakDuration,
  });
}
