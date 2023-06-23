import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../models/grip_dto.dart';

/// A screen showing a list of all available grip types to choose for the
/// current grip
class ChooseGripTypeScreen extends StatefulWidget {
  final GripDTO gripDTO;

  /// The index of the currently selected grip type in the grip types list
  final List<GripTypeWithGripCount> gripTypes;
  final Function(int newGripTypeID) onGripTypeChange;

  const ChooseGripTypeScreen(
      {super.key,
      required this.gripTypes,
      required this.gripDTO,
      required this.onGripTypeChange});

  @override
  State<ChooseGripTypeScreen> createState() => _ChooseGripTypeScreenState();
}

class _ChooseGripTypeScreenState extends State<ChooseGripTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: 'Add Grip',
          middle: const Text('Choose Grip Type'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.add),
            onPressed: () {},
          ),
        ),
        child: SafeArea(child: _gripTypesList(context)));
  }

  /// A list of CupertinoListTiles for each grip type available to choose
  Widget _gripTypesList(BuildContext context) {
    return CupertinoListSection.insetGrouped(children: <Widget>[
      for (int index = 0; index < widget.gripTypes.length; index++)
        CupertinoListTile(
          leading: _checkmarkIcon(widget.gripTypes[index].entry),
          title: Text(widget.gripTypes[index].entry.name),
          trailing: const Icon(CupertinoIcons.delete),
          onTap: () {
            setState(() {
              widget.onGripTypeChange(widget.gripTypes[index].entry.id);
            });
          },
        ),
    ]);
  }

  Widget _checkmarkIcon(GripType currGripType) {
    if (currGripType.id == widget.gripDTO.gripTypeID) {
      return const Icon(CupertinoIcons.check_mark);
    }

    return Container();
  }
}
