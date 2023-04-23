import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './db/drift_database.dart';
import 'screens/settings_screen.dart';
import 'screens/durations_picker_screen.dart';
import 'screens/workout_screen.dart';

void main() {
  final database = AppDatabase();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => AppDatabase(),
      dispose:(context, db) => db.close(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch().copyWith(
                  primary: Colors.blue, secondary: Colors.blue.shade300)),
          home: const AppScaffold()),
    );
  }
}

class AppScaffold extends StatefulWidget {
  const AppScaffold({super.key});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  static const List<Widget> _screenOptions = <Widget>[
    WorkoutScreen(),
    DurationsPickerScreen(),
    SettingsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _screenOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}
