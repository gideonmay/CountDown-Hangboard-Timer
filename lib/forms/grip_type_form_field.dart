import 'package:flutter/cupertino.dart';
import '../models/grip_type_dto.dart';
import '../utils/navigation_utils.dart';

/// A form field that allows the user to choose a grip type. This form field
/// stores a GripTypeDTO object, which stores information regarding a specific
/// grip type.
class GripTypeFormField extends FormField<GripTypeDTO> {
  GripTypeFormField(
      {super.key,
      required BuildContext context,
      required FormFieldSetter<GripTypeDTO> onSaved,
      required FormFieldValidator<GripTypeDTO> validator,
      required GripTypeDTO initialValue,
      required String currentPageTitle,
      bool autovalidate = false})
      : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (FormFieldState<GripTypeDTO> state) {
              return CupertinoFormRow(
                padding: EdgeInsets.zero,
                // Show error text if it is not null
                error: state.errorText == null
                    ? null
                    : Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                        child: Text(state.errorText!),
                      ),
                child: CupertinoListTile(
                  title: const Text('Grip Type'),
                  // Show 'None' as grip type if no grip type is chosen
                  additionalInfo: state.value?.name == null
                      ? const Text('None')
                      : Text(state.value!.name!),
                  trailing: const CupertinoListTileChevron(),
                  onTap: () => navigateToChooseGripType(
                      context, state, currentPageTitle),
                ),
              );
            });
}
