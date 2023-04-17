import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A ListView that lists all of the settings available for the use to change
class SettingsListView extends StatefulWidget {
  const SettingsListView({super.key});

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  static const soundOnKey = 'countdownTimerSoundOn';
  static const vibrationOnKey = 'countdownTimerVibrationOn';
  static const darkModeOnKey = 'countdownTimerDarkModeOn';
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
    setState(() {
      _soundOn = prefs.getBool(soundOnKey) ?? false;
      _vibrationOn = prefs.getBool(vibrationOnKey) ?? false;
      _darkModeOn = prefs.getBool(darkModeOnKey) ?? false;
    });
  }
  
  /// Set sound on or off
  Future<void> _setSound(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _soundOn = newValue;
      prefs.setBool(soundOnKey, newValue);
    });
  }

  /// Set vibration on or off
  Future<void> _setVibration(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrationOn = newValue;
      prefs.setBool(vibrationOnKey, newValue);
    });
  }

  /// Set dark mode on or off
  Future<void> _setDarkMode(bool newValue) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkModeOn = newValue;
      prefs.setBool(darkModeOnKey, newValue);
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
}
