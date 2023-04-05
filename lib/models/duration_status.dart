import 'package:flutter/material.dart';
import 'status_value.dart';

/// Represents a Duration that has an associated status value and color. While
/// the duration is being counted down by the timer, the status value and color
/// can be displayed as an indicator of which phase of the countdown the user is
/// in.
class DurationStatus {
  final Duration duration;
  final StatusValue statusValue;
  Color statusColor;

  DurationStatus(
      {required this.duration,
      required this.statusValue,
      required this.statusColor});

  String get status => statusValue.status.toString().toUpperCase();

  @override
  String toString() {
    int seconds = duration.inSeconds;
    String status = statusValue.status;
    return '($status for $seconds sec)';
  }
}
