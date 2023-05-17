import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../widgets/app_divider.dart';

/// A widget to view and delete any grip type in the database
class GripTypesList extends StatelessWidget {
  final List<GripTypeWithGripCount> gripTypes;

  const GripTypesList({super.key, required this.gripTypes});

  @override
  Widget build(BuildContext context) {
    return _buildGripTypeListView(context);
  }

  /// Returns a ListView displaying all grip types
  ListView _buildGripTypeListView(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: gripTypes.length,
      itemBuilder: (context, index) {
        final gripType = gripTypes[index];
        return Column(
          children: [
            ListTile(
              title: Text(gripType.entry.name),
              subtitle: Text('Used with ${gripType.gripCount} grips'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showAlertDialog(context, gripType),
              ),
              horizontalTitleGap: 5.0,
            ),
            const AppDivider(indent: 15.0, height: 1.0)
          ],
        );
      },
    );
  }

  // Shows a dialog box to confirm grip type deletion
  Future<void> _showAlertDialog(
      BuildContext context, GripTypeWithGripCount gripType) {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Are you sure?'),
        content: Text(_dialogText(gripType)),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              _deleteGripType(context, gripType.entry);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  /// Returns dialog text with the correct pluralization
  String _dialogText(GripTypeWithGripCount gripType) {
    String text =
        'The grip type \'${gripType.entry.name}\' will be permanently deleted';
    int? gripCount = gripType.gripCount;

    if (gripCount != null && gripCount != 0) {
      if (gripType.gripCount == 1) {
        text += ' along with the $gripCount grip that it is used on';
      } else {
        text += ' along with the $gripCount grips that it is used on';
      }
    }

    return text;
  }

  /// Deletes the given grip type from the database
  void _deleteGripType(BuildContext context, GripType gripType) async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    await db.deleteGripType(gripType);
  }
}
