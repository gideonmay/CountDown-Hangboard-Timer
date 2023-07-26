import 'timer_durations_dto.dart';

/// A data transfer object that inherits from the TimerDurationsDTO class and,
/// additionally, stores the grip type ID, grip name, and last break duration.
/// The last break represents the break between this grip and the next one,
/// which may differ from this grip's break duration.
class GripDTO extends TimerDurationsDTO {
  int? gripTypeID;
  String? gripTypeName;
  int? edgeSize;

  /// Break minutes between this grip and the next grip
  int lastBreakMinutes;

  /// Break seconds between this grip and the next grip
  int lastBreakSeconds;

  /// Create a gripDTO with initial standard values
  GripDTO.standard()
      : lastBreakMinutes = 0,
        lastBreakSeconds = 0,
        super.standard();

  /// Returns a Duration object with last break duration
  Duration get lastBreakDuration => Duration(
      minutes: lastBreakMinutes.toInt(), seconds: lastBreakSeconds.toInt());
}
