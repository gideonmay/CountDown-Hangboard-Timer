import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:countdown_app/services/shared_preferences_service.dart';

void main() {
  test('Getting all values returns false if keys are not set', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    bool soundOn = prefService.getSoundOn();
    bool vibrationOn = prefService.getVibrationOn();
    bool darkModeOn = prefService.getDarkModeOn();

    expect(soundOn, false);
    expect(vibrationOn, false);
    expect(darkModeOn, false);
  });

  test('Getting all values returns true if keys already set', () async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesService.soundOnKey: true,
      SharedPreferencesService.vibrationOnKey: true,
      SharedPreferencesService.darkModeOnKey: true
    });

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    bool soundOn = prefService.getSoundOn();
    bool vibrationOn = prefService.getVibrationOn();
    bool darkModeOn = prefService.getDarkModeOn();

    expect(soundOn, true);
    expect(vibrationOn, true);
    expect(darkModeOn, true);
  });

  test('Setting initial sound on value sets value correctly', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    prefService.setSoundOn(true);
    bool soundOn = prefService.getSoundOn();
    expect(soundOn, true);
  });

  test('Updating sound on value sets new value correctly', () async {
    SharedPreferences.setMockInitialValues(
        {SharedPreferencesService.soundOnKey: true});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    prefService.setSoundOn(false);
    bool soundOn = prefService.getSoundOn();
    expect(soundOn, false);
  });

  test('Setting initial vibration on value sets value correctly', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    prefService.setVibrationOn(true);
    bool vibrationOn = prefService.getVibrationOn();
    expect(vibrationOn, true);
  });

  test('Updating vibration on value sets new value correctly', () async {
    SharedPreferences.setMockInitialValues(
        {SharedPreferencesService.vibrationOnKey: true});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    prefService.setVibrationOn(false);
    bool vibrationOn = prefService.getVibrationOn();
    expect(vibrationOn, false);
  });

  test('Setting initial dark mode on value sets value correctly', () async {
    SharedPreferences.setMockInitialValues({});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    prefService.setDarkModeOn(true);
    bool darkModeOn = prefService.getDarkModeOn();
    expect(darkModeOn, true);
  });

  test('Updating dark mode on value sets new value correctly', () async {
    SharedPreferences.setMockInitialValues(
        {SharedPreferencesService.darkModeOnKey: true});

    final prefs = await SharedPreferences.getInstance();
    final prefService = SharedPreferencesService(sharedPreferences: prefs);

    prefService.setDarkModeOn(false);
    bool darkModeOn = prefService.getDarkModeOn();
    expect(darkModeOn, false);
  });
}