import 'package:flutter/services.dart';

/// A data transfer object to store timer sound details. The soundName is the
/// name that is shown to the user and the filePrefix is the name of the file
/// before '_high.wav' or '_low.wav'. For example, a filePrefix of 'beep'
/// indicates that there are two files, 'beep_high.wav' and 'beep_low.wav' in
/// the assets folder.
class TimerSoundDTO {
  final String soundName;
  final String filePrefix;

  TimerSoundDTO({required this.soundName, required this.filePrefix});
}

/// A List of the available timer sounds.
final List<TimerSoundDTO> timerSoundList = [
  TimerSoundDTO(soundName: 'Beep', filePrefix: 'beep'),
  TimerSoundDTO(soundName: 'Electronic', filePrefix: 'electric'),
];

/// Plays system button sound
void playButtonSound() async {
  await SystemSound.play(SystemSoundType.click);
}
