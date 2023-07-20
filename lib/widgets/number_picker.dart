import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/sound_utils.dart';

/// A widget with plus and minus buttons that allows the user to pick a number
/// from between the given min and max values
class NumberPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String title;
  final void Function(int newValue) onValueChanged;

  const NumberPicker(
      {super.key,
      required this.onValueChanged,
      required this.minValue,
      required this.maxValue,
      required this.initialValue,
      required this.title});

  @override
  State<NumberPicker> createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  late int _currValue;

  /// The timer that controls how quickly values autoincrement on long press
  Timer _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {});

  @override
  void initState() {
    super.initState();
    _currValue = widget.initialValue;
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(widget.title),
      trailing: Row(children: [
        _valueText(),
        _changeValueButtons(),
      ]),
    );
  }

  /// A text widget containing the value of this number picker
  Widget _valueText() {
    return SizedBox(
        width: 70.0,
        child: Text(
          _currValue.toString(),
          style: const TextStyle(fontSize: 20.0),
        ));
  }

  /// A plus and a minus button in a single row
  Widget _changeValueButtons() {
    return SizedBox(
      height: 35.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _minusButton(),
          const VerticalDivider(
            thickness: 1.0,
            indent: 5.0,
            endIndent: 5.0,
            width: 0,
          ),
          _plusButton(),
        ],
      ),
    );
  }

  /// A button to decrease the value
  Widget _minusButton() {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onLongPress: () {
          _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
            _decreaseValueBy(1);
          });
        },
        onLongPressUp: () {
          _timer.cancel();
        },
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _decreaseValueBy(1),
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Icon(CupertinoIcons.minus_circle_fill,
                  color: CupertinoColors.systemGrey2),
            ),
          ),
        ),
      ),
    );
  }

  /// Increases value without going under minumum
  void _decreaseValueBy(int amount) {
    int newValue = _currValue - amount;

    if (newValue >= widget.minValue) {
      playButtonSound();
      HapticFeedback.lightImpact();
      setState(() {
        _currValue = newValue;
      });
      widget.onValueChanged(newValue);
    }
  }

  /// A button to decrease the value
  Widget _plusButton() {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onLongPress: () {
          _timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
            _increaseValueBy(1);
          });
        },
        onLongPressUp: () {
          _timer.cancel();
        },
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () => _increaseValueBy(1),
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Icon(CupertinoIcons.add_circled_solid,
                  color: CupertinoColors.systemGrey2),
            ),
          ),
        ),
      ),
    );
  }

  /// Decreases value without going over maximum
  void _increaseValueBy(int amount) async {
    int newValue = _currValue + amount;

    if (newValue <= widget.maxValue) {
      playButtonSound();
      HapticFeedback.lightImpact();
      setState(() {
        _currValue = newValue;
      });
      widget.onValueChanged(newValue);
    }
  }
}
