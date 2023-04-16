import 'package:flutter/material.dart';

/// Defines a tile that has a color and text that displays details about the
/// current state of the countdown timer, such as current rep or set.
class TimerDetailsTile extends StatelessWidget {
  final Color? color;
  final double fontSize;
  final Widget child;

  const TimerDetailsTile(
      {super.key,
      this.color,
      required this.fontSize,
      required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: child,
    );
  }
}
