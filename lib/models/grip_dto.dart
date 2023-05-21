import 'timer_durations_dto.dart';

/// A data transfer object that stores all of the values in TimerDurationsDTO
/// and stores the grip type ID, grip name, and last break duration. The last
/// break represents the break between this grip and the next one, which may
/// differ from this grip's break duration.
class GripDTO extends TimerDurationsDTO {
  int? gripTypeID;
  String gripName;
  int? edgeSize;

  /// Break minutes between this grip and the next grip
  double lastBreakMinutes;

  /// Break seconds between this grip and the next grip
  double lastBreakSeconds;

  GripDTO(
      {required this.gripName,
      required this.lastBreakMinutes,
      required this.lastBreakSeconds,
      this.edgeSize})
      : super.standard(); // Initializes TimerDuration.standard

  /// Returns a Duration object with last break duration
  Duration get lastBreakDuration => Duration(
      minutes: lastBreakMinutes.toInt(), seconds: lastBreakSeconds.toInt());
}
