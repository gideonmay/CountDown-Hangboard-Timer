import 'package:flutter/material.dart';

/// A Text widget that provides a title to the left of a NumberPicker
class NumberPickerTitle extends StatelessWidget {
  final String title;

  /// The max width this widget will occupy
  final double maxWidth;

  const NumberPickerTitle(
      {super.key, required this.title, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
      child: SizedBox(
        width: maxWidth,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}
