import 'package:flutter/cupertino.dart';

/// Shows a CupertinoModalPopup with a fixed height which hosts a
/// CupertinoTimerPicker. Copied from Flutter documentation:
/// https://api.flutter.dev/flutter/cupertino/CupertinoTimerPicker-class.html
void showBottomDialog(BuildContext context, Widget child) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => Container(
      height: 216,
      padding: const EdgeInsets.only(top: 6.0),
      margin: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: child,
      ),
    ),
  );
}
