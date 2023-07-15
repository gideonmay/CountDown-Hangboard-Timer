import 'package:flutter/cupertino.dart';
import '../models/duration_status_list.dart';
import '../widgets/countdown_timer.dart';

class WorkoutTimerScreen extends StatelessWidget {
  final String title;
  final DurationStatusList durationStatusList;

  const WorkoutTimerScreen(
      {super.key, required this.title, required this.durationStatusList});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
        ),
        child: SafeArea(
            child: CountdownTimer.fromList(
          durationStatusList: durationStatusList,
        )));
  }
}
