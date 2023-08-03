import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:countdown_app/screens/settings_screen.dart';

void main() {
  late Widget chooseSoundScreen;

  setUp(() {
    chooseSoundScreen = const CupertinoApp(home: SettingsScreen());
  });

  testWidgets('SettingsScreen renders without any errors', (tester) async {
    await tester.pumpWidget(chooseSoundScreen);
  });
}
