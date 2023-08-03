import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/models/timer_durations_dto.dart';
import 'package:countdown_app/screens/countdown_timer_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
    chooseSoundScreen = CupertinoApp(
        home: CountdownTimerScreen(
      timerDurations: TimerDurationsDTO.standard(),
    ));
  });

  testWidgets('CountdownTimerScreen renders without any errors',
      (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
