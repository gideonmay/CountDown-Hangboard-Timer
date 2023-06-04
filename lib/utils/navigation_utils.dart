import 'package:flutter/material.dart';
import '../screens/grip_types_screen.dart';

/// Navigates to the GripTypesScreen widget
void navigateToAddGripType(BuildContext context) async {
  /*
   * Must add a short delay to prevent new route from being
   * immediately popped. Solution copied from this source:
   * https://stackoverflow.com/questions/67713122/navigator-inside-popupmenuitem-does-not-work
   */
  await Future.delayed(Duration.zero);

  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const GripTypesScreen()),
    );
  }
}
