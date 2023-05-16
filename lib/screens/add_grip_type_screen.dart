import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../forms/add_grip_type_form.dart';
import '../widgets/app_header.dart';
import '../widgets/app_divider.dart';
import '../widgets/grip_types_list.dart';

/// A screen that allows the user to create new grip types and delete existing
/// grips that they no longer want listed
class AddGripTypeScreen extends StatefulWidget {
  const AddGripTypeScreen({super.key});

  @override
  State<AddGripTypeScreen> createState() => _AddGripTypeScreenState();
}

class _AddGripTypeScreenState extends State<AddGripTypeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Grip Type'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: _gripTypeFormAndList(context),
          ),
        ));
  }

  /// Returns a widget containing a form to add a new grip type and a list of
  /// all existing grip types
  StreamBuilder<List<GripTypeWithGripCount>> _gripTypeFormAndList(
      BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
        stream: db.watchAllGripTypesWithCount(),
        builder:
            (context, AsyncSnapshot<List<GripTypeWithGripCount>> snapshot) {
          final gripTypes = snapshot.data ?? List.empty();

          if (gripTypes.isEmpty) {
            return AddGripTypeForm(gripTypes: gripTypes);
          }

          return Column(children: [
            AddGripTypeForm(gripTypes: gripTypes),
            const AppDivider(),
            const AppHeader(title: 'Grip Types'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('All added grip types will appear here'),
            ),
            GripTypesList(gripTypes: gripTypes),
          ]);
        });
  }
}
