import 'package:flutter/material.dart';
import '../screens/add_grip_type_screen.dart';
import '../screens/grip_types_screen.dart';

/// Navigates to the GripTypesScreen widget. The optional current grip type
/// argument will be passed to the GripTypesScreen widget if given.
void navigateToGripTypeScreen(BuildContext context,
    [int? currGripTypeID]) async {
  /*
   * Must add a short delay to prevent new route from being
   * immediately popped. Solution copied from this source:
   * https://stackoverflow.com/questions/67713122/navigator-inside-popupmenuitem-does-not-work
   */
  await Future.delayed(Duration.zero);

  if (context.mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GripTypesScreen(
                currGripTypeID: currGripTypeID,
              )),
    );
  }
}

/// Navigates to the AddGripTypeScreen widget
void navigateToAddGripTypeScreen(BuildContext context) {
  if (context.mounted) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const AddGripTypeScreen()));
  }
}
