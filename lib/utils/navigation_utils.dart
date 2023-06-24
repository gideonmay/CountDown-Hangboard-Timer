import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../models/grip_type_dto.dart';
import '../screens/add_grip_type_screen.dart';
import '../screens/choose_grip_type_screen.dart';
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
      CupertinoPageRoute(
          builder: (context) => GripTypesScreen(
                currGripTypeID: currGripTypeID,
              )),
    );
  }
}

/// Navigates to the AddGripTypeScreen widget
void navigateToAddGripTypeScreen(BuildContext context,
    List<GripTypeWithGripCount> gripTypes) {
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
    FormFieldState<GripTypeDTO> state, String previousPageTitle) {
  Navigator.push(
    context,
    CupertinoPageRoute(
        builder: (context) => ChooseGripTypeScreen(
              formFieldState: state,
              previousPageTitle: previousPageTitle,
            )),
  );
}
