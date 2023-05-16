import 'package:flutter/material.dart';

/// A standard divider widget used throughout the app
class AppDivider extends StatelessWidget {
  /// Front indent of divider. If left blank, defaults to 1.
  final double? indent;
  /// Height of divider with padding. If left blank, defaults to 3.
  final double? height;

  const AppDivider({super.key, this.indent = 8.0, this.height});

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1.0,
      indent: indent,
      endIndent: 8.0,
      height: height,
    );
  }
}
