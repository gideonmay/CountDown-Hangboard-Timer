import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/screens/durations_picker_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
    chooseSoundScreen = const CupertinoApp(home: DurationsPickerScreen());
  });

  testWidgets('DurationsPickerScreen renders without any errors',
      (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
