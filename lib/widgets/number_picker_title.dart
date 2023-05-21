import 'package:flutter/material.dart';

/// A Text widget that provides a title to the left of a NumberPicker
class NumberPickerTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  /// The max width this widget will occupy
  final double maxWidth;

  const NumberPickerTitle(
      {super.key, required this.title, this.subtitle, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 0.0, 8.0),
      child: SizedBox(
        width: maxWidth,
        child: _titleText(),
      ),
    );
  }

  /// Returns the title text alone if the subtitle text is null. Otherwise,
  /// returns a Column containing both the title and subtitle.
  Widget _titleText() {
    if (subtitle != null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20.0),
          ),
          Text(
            subtitle ?? '',
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      );
    }

    return Text(
      title,
      style: const TextStyle(fontSize: 20.0),
    );
  }
}
