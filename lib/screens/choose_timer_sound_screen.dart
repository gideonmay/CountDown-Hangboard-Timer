import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import '../utils/sound_utils.dart';

/// A screen that allows the user to choose a sound that they would like the
/// timer to play during the timer countdown
class ChooseTimerSoundScreen extends StatefulWidget {
  /// The index of the inital timer sound to display
  final int initialSoundIndex;
  final Function(int) onTimerSoundChanged;

  const ChooseTimerSoundScreen(
      {super.key,
      required this.onTimerSoundChanged,
      required this.initialSoundIndex});

  @override
  State<ChooseTimerSoundScreen> createState() => _ChooseTimerSoundScreenState();
}

class _ChooseTimerSoundScreenState extends State<ChooseTimerSoundScreen> {
  late int _currSoundIndex;

  @override
  void initState() {
    super.initState();
    _currSoundIndex = widget.initialSoundIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: const CupertinoNavigationBar(
          previousPageTitle: 'Settings',
          middle: Text('Timer Sound'),
        ),
        child: SafeArea(
            child: CupertinoListSection.insetGrouped(
          children: _soundChoiceListView(),
        )));
  }

  /// Builds and returns a list of widgets from ther timerSoundChoices list
  List<Widget> _soundChoiceListView() {
    List<Widget> soundChoices = [];

    for (int index = 0; index < timerSoundList.length; index++) {
      final timerSound = timerSoundList[index];

      soundChoices.add(CupertinoListTile(
        leading: index == _currSoundIndex
            ? const Icon(CupertinoIcons.check_mark)
            : Container(),
        title: Text(
          timerSound.soundName,
        ),
        onTap: () {
          setState(() {
            _currSoundIndex = index;
            widget.onTimerSoundChanged(index);
            _playSound(timerSound.filePrefix);
          });
        },
      ));
    }

    return soundChoices;
  }

  /// Plays the lower version of the audio file with the givin prefix
  void _playSound(String filePrefix) async {
    String assetPath = 'assets/audio/${filePrefix}_low.wav';
    final player = AudioPlayer();
    await player.setAsset(assetPath);
    await player.play();
  }
}
