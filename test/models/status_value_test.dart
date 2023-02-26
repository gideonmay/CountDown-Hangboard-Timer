import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/status_value.dart';

void main() {
  test('Work status value should have correct status', () {
    final statusValue = StatusValue.isWorking();
    expect(statusValue.status, 'work');
  });

  test('Rest status value should have correct status', () {
    final statusValue = StatusValue.isResting();
    expect(statusValue.status, 'rest');
  });

  test('Break status value should have correct status', () {
    final statusValue = StatusValue.isBreak();
    expect(statusValue.status, 'break');
  });

  test('Prepare status value should have correct status', () {
    final statusValue = StatusValue.isPreparing();
    expect(statusValue.status, 'prepare');
  });
}