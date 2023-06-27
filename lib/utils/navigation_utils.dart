import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../models/grip_type_dto.dart';
import '../screens/add_grip_type_screen.dart';
import '../screens/choose_grip_type_screen.dart';

/// Navigates to the AddGripTypeScreen widget
void navigateToAddGripTypeScreen(
    BuildContext context, List<GripTypeWithGripCount> gripTypes) {
  if (context.mounted) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => AddGripTypeScreen(
                  gripTypes: gripTypes,
                )));
  }
}

/// Navigates to the ChooseGripTypeScreen widget
void navigateToChooseGripType(BuildContext context,
    GripTypeDTO currGripType, String previousPageTitle, Function(GripTypeDTO newGripType) onGripTypeChanged) {
  Navigator.push(
    context,
    CupertinoPageRoute(
        builder: (context) => ChooseGripTypeScreen(
              currGripType: currGripType,
              previousPageTitle: previousPageTitle,
              onGripTypeChanged: onGripTypeChanged
            )),
  );
}
