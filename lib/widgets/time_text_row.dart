import 'package:flutter/material.dart';

/// Takes a title and a duration string and displays both in a single row with
/// styled text
class TimeTextRow extends StatelessWidget {
  final String title;
  final String durationString;

  const TimeTextRow(
      {super.key, required this.title, required this.durationString});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey.shade700, fontSize: 20.0),
        ),
        Text(
          durationString,
          style: const TextStyle(fontSize: 20.0),
        )
      ],
    );
  }
}
