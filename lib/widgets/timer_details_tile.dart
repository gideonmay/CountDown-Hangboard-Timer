import 'package:flutter/material.dart';

/// Defines a tile that has a color and text that displays details about the
/// current state of the countdown timer, such as current rep or set.
class TimerDetailsTile extends StatelessWidget {
  final Color color;
  final String text;
  final double fontSize;

  const TimerDetailsTile(
    {super.key,
    required this.color,
    required this.text,
    required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 1)
          )
        ]
      ),
      child: Center(child: Text(text, style: TextStyle(fontSize: fontSize),))
    );
  }
}