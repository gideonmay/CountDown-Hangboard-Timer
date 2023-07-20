import 'package:intl/intl.dart';

/// Returns true if the given DateTime occurred today.
/// Adapted from:
/// https://stackoverflow.com/questions/54391477/check-if-datetime-variable-is-today-tomorrow-or-yesterday
bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  final int diff = DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;

  return diff == 0;
}

/// Returns the given datetime formatted as 'MM/DD/YYYY'. If dateTime is null,
/// then returns '-'. If dateTime occurred today, then returns the time.
String formattedDate(DateTime? dateTime) {
  if (dateTime == null) {
    return '-';
  }

  if (isToday(dateTime)) {
    return DateFormat('h:mm a').format(dateTime);
  }

  return DateFormat('M/dd/yyyy').format(dateTime);
}
