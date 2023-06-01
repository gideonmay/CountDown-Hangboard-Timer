import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/grip_dto.dart';

void main() {
  test('GripDTO.standard() has correct standard values', () {
    final gripDTO = GripDTO.standard();

    expect(gripDTO.sets, 1);
    expect(gripDTO.reps, 1);
    expect(gripDTO.workSeconds, 10);
    expect(gripDTO.restSeconds, 5);
    expect(gripDTO.breakMinutes, 0);
    expect(gripDTO.breakSeconds, 30);
    expect(gripDTO.lastBreakMinutes, 0);
    expect(gripDTO.lastBreakSeconds, 30);
    expect(gripDTO.edgeSize, null);
    expect(gripDTO.gripTypeID, null);
  });

  test('GripDTO.standard() returns correct last break duration', () {
    final gripDTO = GripDTO.standard();
    expect(gripDTO.lastBreakDuration, const Duration(seconds: 30));
  });
}
