import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// A wrapper widget that calls haptic feedback light impact in its initState
/// method. This causes haptic feedback to occur any time this widget is
/// rendered.
class HapticWrapper extends StatefulWidget {
  final Widget child;

  const HapticWrapper({super.key, required this.child});

  @override
  State<HapticWrapper> createState() => _HapticWrapperState();
}

class _HapticWrapperState extends State<HapticWrapper> {
  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
