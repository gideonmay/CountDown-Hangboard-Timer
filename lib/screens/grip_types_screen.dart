import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../db/drift_database.dart';
import '../tabs/add_grip_type_tab.dart';
import '../tabs/view_grip_types_tab.dart';
import '../widgets/helper_dialog.dart';

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
            actions: [
              IconButton(
                  onPressed: () => _showHelperDialog(context),
                  icon: const Icon(Icons.help))
            ],
            bottom: TabBar(
              indicatorColor: Colors.white,
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

          return TabBarView(children: [
            AddGripTypeTab(gripTypes: gripTypes),
            ViewGripTypesTab(gripTypes: gripTypes),
          ]);
        });
  }

  Future<String?> _showHelperDialog(BuildContext context) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => const HelperDialog(
            title: 'Grip Types',
            body:
                'A grip type is a resuable descriptor for a grip. Adding a grip type will add it to your list of saved grip types.\n\n'
                'Be careful when deleting grip types from the list, as any grip that it is used on will also be deleted.'));
  }
}
