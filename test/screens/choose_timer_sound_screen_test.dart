import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/screens/choose_timer_sound_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
    chooseSoundScreen = CupertinoApp(
        home: ChooseTimerSoundScreen(
      initialSoundIndex: 0,
      onTimerSoundChanged: (param) {},
    ));
  });

  testWidgets('ChooseTimerSoundScreen renders without any errors',
      (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
