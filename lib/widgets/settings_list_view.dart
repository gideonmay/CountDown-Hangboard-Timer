import 'package:flutter/cupertino.dart';
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
    return CupertinoListSection.insetGrouped(
      children: [
        CupertinoListTile(
          leading: _soundOn
              ? const Icon(CupertinoIcons.speaker_1)
              : const Icon(CupertinoIcons.speaker_slash),
          title: const Text('Timer Sound'),
          trailing: CupertinoSwitch(
              value: _soundOn, onChanged: (bool value) => _setSound(value)),
        ),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.alarm),
          title: const Text('Timer Vibration'),
          trailing: CupertinoSwitch(
              value: _vibrationOn,
              onChanged: (bool value) => _setVibration(value)),
        ),
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.moon),
          title: const Text('Dark Mode'),
          trailing: CupertinoSwitch(
              value: _darkModeOn,
              onChanged: (bool value) => _setDarkMode(value)),
        ),
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
