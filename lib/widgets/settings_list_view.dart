import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/shared_preferences_service.dart';

/// A ListView that lists all of the settings available for the user to change
class SettingsListView extends StatefulWidget {
  const SettingsListView({super.key});

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  late final SharedPreferencesService prefService;
  bool _soundOn = false;
  bool _vibrationOn = false;
  bool _darkModeOn = false;

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();
  }

  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefService = SharedPreferencesService(sharedPreferences: prefs);
    setState(() {
      _soundOn = prefService.getSoundOn();
      _vibrationOn = prefService.getVibrationOn();
      _darkModeOn = prefService.getDarkModeOn();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.volume_up),
          title: const Text('Timer Sound'),
          trailing: Switch(
              value: _soundOn, onChanged: (bool value) => _setSound(value)),
        ),
        const Divider(thickness: 1.0),
        ListTile(
          leading: const Icon(Icons.vibration),
          title: const Text('Timer Vibration'),
          trailing: Switch(
              value: _vibrationOn,
              onChanged: (bool value) => _setVibration(value)),
        ),
        const Divider(thickness: 1.0),
        ListTile(
          leading: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          trailing: Switch(
              value: _darkModeOn,
              onChanged: (bool value) => _setDarkMode(value)),
        ),
        const Divider(thickness: 1.0),
      ],
    );
  }

  /// Set sound on or off
  Future<void> _setSound(bool newValue) async {
    setState(() {
      _soundOn = newValue;
      prefService.setSoundOn(newValue);
    });
  }

  /// Set vibration on or off
  Future<void> _setVibration(bool newValue) async {
    setState(() {
      _vibrationOn = newValue;
      prefService.setVibrationOn(newValue);
    });
  }

  /// Set dark mode on or off
  Future<void> _setDarkMode(bool newValue) async {
    setState(() {
      _darkModeOn = newValue;
      prefService.setDarkModeOn(newValue);
    });
  }
}
