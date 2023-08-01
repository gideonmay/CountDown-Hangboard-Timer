import 'package:flutter/cupertino.dart';

/// Takes a title and a duration string and displays both in a single row with
/// styled text
class TimeTextRow extends StatelessWidget {
  final String title;
  final String durationString;
  final double fontSize;

  /// The width that the title text will take up
  final double titleWidth;

  const TimeTextRow(
      {super.key,
      required this.title,
      required this.durationString,
      required this.fontSize,
      required this.titleWidth});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: titleWidth,
          child: Text(
            title,
            style: TextStyle(
                color: CupertinoColors.systemGrey, fontSize: fontSize),
          ),
        ),
        Text(
          durationString,
          style: TextStyle(fontSize: fontSize),
        )
      ],
    );
  }
}
