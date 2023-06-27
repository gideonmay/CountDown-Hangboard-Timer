import 'package:flutter/cupertino.dart';
import 'countdown_timer_screen.dart';
import '../forms/durations_picker_form.dart';
import '../models/timer_durations_dto.dart';

/// A screen with a form that allows the user to choose the work, rest, and
/// break durations in addition to the number or reps and sets.
class DurationsPickerScreen extends StatefulWidget {
  const DurationsPickerScreen({super.key});

  @override
  State<DurationsPickerScreen> createState() => _DurationsPickerScreenState();
}

class _DurationsPickerScreenState extends State<DurationsPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemGrey6,
        child: CustomScrollView(slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Timer Setup'),
          ),
          SliverSafeArea(
              top: false,
              minimum: EdgeInsets.only(top: 0),
              sliver: SliverToBoxAdapter(
                child: DurationsPickerForm(onStartPressed: navigateToTimer),
              ))
        ]));
  }

  /// Navigates to the countdown timer screen
  static navigateToTimer(
      BuildContext context, TimerDurationsDTO timerDurations) {
    Navigator.push(
      context,
      CupertinoPageRoute(
          builder: (context) =>
              CountdownTimerScreen(timerDurations: timerDurations)),
    );
  }
}
