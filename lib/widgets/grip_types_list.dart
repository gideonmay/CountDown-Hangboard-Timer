import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';

/// A widget to view and delete any grip type in the database
class GripTypesList extends StatelessWidget {
  const GripTypesList({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildGripTypeList(context);
  }

  /// Returns a ListView displaying all grip types
  StreamBuilder<List<GripTypeWithGripCount>> _buildGripTypeList(
      BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
        stream: db.watchAllGripTypesWithCount(),
        builder:
            (context, AsyncSnapshot<List<GripTypeWithGripCount>> snapshot) {
          final gripTypes = snapshot.data ?? List.empty();

          if (gripTypes.isEmpty) {
            return Container();
          }

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
                      onPressed: () => _dialogBuilder(context, gripType),
                    ),
                    horizontalTitleGap: 5.0,
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 5,
                    thickness: 1.0,
                    height: 1,
                  ),
                ],
              );
            },
          );
        });
  }

  /// Shows a dialog box to confirm workout deletion. Adapted example from:
  /// https://api.flutter.dev/flutter/material/showDialog.html
  Future<void> _dialogBuilder(
      BuildContext context, GripTypeWithGripCount gripType) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: Text(_dialogText(gripType)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                _deleteGripType(context, gripType.entry);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
