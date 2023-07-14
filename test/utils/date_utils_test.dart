import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:countdown_app/utils/date_utils.dart';

void main() {
  test('A given DateTime returns the correctly formatted date', () {
    final date = DateTime(2023, 7, 10);
    final dateString = formattedDate(date);

    expect(dateString, '7/10/2023');
  });

  test('A time is returned if given date is today', () {
    final now = DateTime.now();
    final dateString = formattedDate(now);

    expect(dateString, DateFormat('h:m a').format(now));
  });
}
