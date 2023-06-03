import 'package:flutter/material.dart';
import '../screens/grip_types_screen.dart';

/// Navigates to the GripTypesScreen widget
void navigateToAddGripType(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const GripTypesScreen()),
  );
}
