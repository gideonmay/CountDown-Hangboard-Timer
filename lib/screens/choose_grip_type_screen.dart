import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_type_dto.dart';
import '../utils/navigation_utils.dart';

/// A screen showing a list of all available grip types to choose for the
/// current grip
class ChooseGripTypeScreen extends StatefulWidget {
  final FormFieldState<GripTypeDTO> formFieldState;
  final String previousPageTitle;

  const ChooseGripTypeScreen({
    super.key,
    required this.formFieldState,
    required this.previousPageTitle,
  });

  @override
  State<ChooseGripTypeScreen> createState() => _ChooseGripTypeScreenState();
}

class _ChooseGripTypeScreenState extends State<ChooseGripTypeScreen> {
  List<GripTypeWithGripCount> _gripTypes = List.empty();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: widget.previousPageTitle,
          middle: const Text('Choose Grip Type'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.add),
            onPressed: () => navigateToAddGripTypeScreen(context, _gripTypes),
          ),
        ),
        child: SafeArea(child: _buildGripTypeList(context)));
  }

  /// Returns a list of CupertinoListTiles for each grip type in the stream
  StreamBuilder<List<GripTypeWithGripCount>> _buildGripTypeList(
      BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);
    return StreamBuilder(
      stream: db.watchAllGripTypesWithCount(),
      builder: (context, AsyncSnapshot<List<GripTypeWithGripCount>> snapshot) {
        _gripTypes = snapshot.data ?? List.empty();

        // Show message to user if they have not yet created any grip types
        if (_gripTypes.isEmpty) {
          return const Center(
            child: Text('No grip types added'),
          );
        }

        return CupertinoListSection.insetGrouped(children: <Widget>[
          for (int index = 0; index < _gripTypes.length; index++)
            CupertinoListTile(
              leading: _checkmarkIcon(_gripTypes[index].entry),
              title: Text(_gripTypes[index].entry.name),
              trailing: const Icon(CupertinoIcons.delete),
              onTap: () {
                setState(() {
                  widget.formFieldState.didChange(GripTypeDTO(
                      id: _gripTypes[index].entry.id,
                      name: _gripTypes[index].entry.name));
                });
              },
            ),
        ]);
      },
    );
  }

  /// Returns a checkmark icon for the grip type that is currently selected by
  /// the parent form field
  Widget _checkmarkIcon(GripType currGripType) {
    if (currGripType.id == widget.formFieldState.value?.id) {
      return const Icon(CupertinoIcons.check_mark);
    }

    return Container();
  }
}
