import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/choose_timer_sound_screen.dart';
import '../services/shared_preferences_service.dart';
import '../utils/sound_utils.dart';

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
  int _timerSoundIndex = 0;

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
      _timerSoundIndex = prefService.getTimerSoundIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListSection.insetGrouped(
      children: [
        CupertinoListTile(
          leading: const Icon(CupertinoIcons.alarm),
          title: const Text('Timer Vibration'),
          trailing: CupertinoSwitch(
              value: _vibrationOn,
              onChanged: (bool value) => _setVibration(value)),
        ),
        CupertinoListTile(
          leading: _soundOn
              ? const Icon(CupertinoIcons.speaker_1)
              : const Icon(CupertinoIcons.speaker_slash),
          title: const Text('Timer Sound'),
          trailing: CupertinoSwitch(
              value: _soundOn, onChanged: (bool value) => _setSound(value)),
        ),
        CupertinoListTile(
          title: const Text('Sound Type'),
          additionalInfo: Text(_soundType()),
          trailing: const CupertinoListTileChevron(),
          onTap: () => _navigateToChooseTimerSound(context),
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

  /// Set new timer sound index
  Future<void> _setTimerSound(int newIndex) async {
    setState(() {
      _timerSoundIndex = newIndex;
      prefService.setTimerSoundIndex(newIndex);
    });
  }

  /// Returns the name of the timer sound based on the chosen timer sound index
  String _soundType() {
    return timerSoundList[_timerSoundIndex].soundName;
  }

  // Navigates to screen to choose a timer sound
  void _navigateToChooseTimerSound(BuildContext context) {
    final int soundIndex = prefService.getTimerSoundIndex();

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => ChooseTimerSoundScreen(
                initialSoundIndex: soundIndex,
                onTimerSoundChanged: _setTimerSound)));
  }
}
