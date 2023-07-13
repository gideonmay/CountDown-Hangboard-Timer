import 'package:intl/intl.dart';

/// Returns the given datetime formatted as 'MM/DD/YYYY'. If dateTime is null,
/// then returns 'Never'
String formattedDate(DateTime? dateTime) {
  if (dateTime == null) {
    return '-';
  }

  return DateFormat('MM/dd/yyyy').format(dateTime);
}
