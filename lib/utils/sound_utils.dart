import 'package:flutter/services.dart';

/// Plays system button sound
void playButtonSound() async {
  await SystemSound.play(SystemSoundType.click);
}
