import 'package:flutter/services.dart';

/// A data transfer object to store timer sound details. The soundName is the
/// name that is shown to the user and the filePrefix is the name of the file
/// before '_high.wav' or '_low.wav'. For example, a filePrefix of 'beep'
/// indicates that there are two files, 'beep_high.wav' and 'beep_low.wav' in
/// the assets folder.
///
/// Any audio file added to assets should be 0.4 seconds long. That is the audio
/// length that the app has been tested for. It is unknown if adding longer
/// audio will cause error, so best to keep audio to the 0.4 seconds.
class TimerSoundDTO {
  final String soundName;
  final String filePrefix;

  TimerSoundDTO({required this.soundName, required this.filePrefix});
}

/// A List of the available timer sounds.
final List<TimerSoundDTO> timerSoundList = [
  TimerSoundDTO(soundName: 'Beep (default)', filePrefix: 'beep'),
  TimerSoundDTO(soundName: 'Buzzer', filePrefix: 'buzzer'),
  TimerSoundDTO(soundName: 'Chime', filePrefix: 'chime'),
  TimerSoundDTO(soundName: 'Electronic', filePrefix: 'electric'),
  TimerSoundDTO(soundName: 'Glass', filePrefix: 'glass'),
];

/// Plays system button sound
void playButtonSound() async {
  await SystemSound.play(SystemSoundType.click);
}
