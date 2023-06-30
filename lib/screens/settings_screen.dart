import 'package:flutter/cupertino.dart';
import '../widgets/settings_list_view.dart';

/// The screen that allows the user to changed settings such as sound on,
/// vibration on, and dark mode on
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        child: CustomScrollView(slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Settings'),
          ),
          SliverSafeArea(
              top: false,
              minimum: EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: SettingsListView(),
              ))
        ]));
  }
}
