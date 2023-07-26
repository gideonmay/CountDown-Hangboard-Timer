import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './db/drift_database.dart';
import 'screens/settings_screen.dart';
import 'screens/durations_picker_screen.dart';
import 'screens/workouts_screen.dart';

void main() {
  runApp(Provider<AppDatabase>(
    create: (context) => AppDatabase(openConnection()),
    dispose: (context, db) => db.close(),
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
        localizationsDelegates: [
          // These are necessary for the ReorderableListView widget to work
          DefaultMaterialLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        theme: CupertinoThemeData(brightness: Brightness.light),
        home: AppScaffold());
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  /// The screens available in the bottom tab bar
  static const List<Widget> _screenOptions = <Widget>[
    WorkoutsScreen(),
    DurationsPickerScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: 'Settings',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return _screenOptions[index];
          },
        );
      },
    );
  }
}
