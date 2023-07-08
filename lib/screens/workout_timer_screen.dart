import 'package:flutter/cupertino.dart';
import '../db/drift_database.dart';
import '../widgets/countdown_timer.dart';

class WorkoutTimerScreen extends StatelessWidget {
  final String title;
  final List<GripWithGripType> gripList;

  const WorkoutTimerScreen(
      {super.key, required this.title, required this.gripList});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        navigationBar: CupertinoNavigationBar(
          middle: Text(title),
        ),
        child:
            SafeArea(child: CountdownTimer.fromGripList(gripList: gripList)));
  }
}
