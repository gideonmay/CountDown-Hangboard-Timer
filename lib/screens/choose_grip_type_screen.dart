import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../models/grip_type_dto.dart';
import '../widgets/grip_types_list.dart';
import '../utils/navigation_utils.dart';

/// A screen showing a list of all available grip types to choose for the
/// current grip
class ChooseGripTypeScreen extends StatefulWidget {
  /// The currently selected grip type
  final GripTypeDTO currGripType;
  final String previousPageTitle;

  /// To be executed when the grip type is changed
  final Function(GripTypeDTO newGripType) onGripTypeChanged;

  const ChooseGripTypeScreen(
      {super.key,
      required this.currGripType,
      required this.previousPageTitle,
      required this.onGripTypeChanged});

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

  /// Builds and returns a GripTypeList using the specified stream
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

        return GripTypesList(
            initialGripType: widget.currGripType,
            previousPageTitle: widget.previousPageTitle,
            gripTypes: _gripTypes,
            onGripTypeChanged: widget.onGripTypeChanged);
      },
    );
  }
}
