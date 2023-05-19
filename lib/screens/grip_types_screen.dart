import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../forms/add_grip_type_form.dart';
import '../widgets/add_grip_type_tab.dart';
import '../widgets/view_grip_types_tab.dart';

/// A screen that allows the user to create new grip types and delete existing
/// grips that they no longer want listed
class GripTypesScreen extends StatefulWidget {
  const GripTypesScreen({super.key});

  @override
  State<GripTypesScreen> createState() => _GripTypesScreenState();
}

class _GripTypesScreenState extends State<GripTypesScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Grip Types'),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.add),
                      ),
                      Text('Add Grip Type')
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Icon(Icons.view_list),
                      ),
                      Text('View Grip Types')
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: _tabBarView(context)),
    );
  }

  /// Returns a TabBarView containing tabs to add and edit grip types
  StreamBuilder<List<GripTypeWithGripCount>> _tabBarView(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return StreamBuilder(
        stream: db.watchAllGripTypesWithCount(),
        builder:
            (context, AsyncSnapshot<List<GripTypeWithGripCount>> snapshot) {
          final gripTypes = snapshot.data ?? List.empty();

          if (gripTypes.isEmpty) {
            return AddGripTypeForm(gripTypes: gripTypes);
          }

          return TabBarView(children: [
            AddGripTypeTab(gripTypes: gripTypes),
            ViewGripTypesTab(gripTypes: gripTypes),
          ]);
        });
  }
}
