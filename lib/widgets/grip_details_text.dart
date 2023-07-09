import 'package:flutter/cupertino.dart';

/// Displays the name of the current and next grips in the workout
class GripDetailsText extends StatelessWidget {
  final String? currGripName;
  final String? nextGripName;

  const GripDetailsText({super.key, this.currGripName, this.nextGripName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
      child: SizedBox.expand(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _currGripText(constraints.maxHeight * 0.6),
              _nextGripText(constraints.maxHeight * 0.35)
            ],
          );
        }),
      ),
    );
  }

  Widget _currGripText(double textHeight) {
    if (currGripName != null) {
      return SizedBox(
          height: textHeight, child: FittedBox(child: Text(currGripName!)));
    }

    return const SizedBox.shrink();
  }

  Widget _nextGripText(double textHeight) {
    if (nextGripName != null) {
      return SizedBox(
        height: textHeight,
        child: FittedBox(
          child: Text(
            'Next Grip: ${nextGripName!}',
            style: const TextStyle(color: CupertinoColors.systemGrey),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
