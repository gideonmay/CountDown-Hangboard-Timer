import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/sound_utils.dart';

/// A widget with plus and minus buttons that allows the user to pick a number
/// from between the given min and max values
class NumberPicker extends StatefulWidget {
  final int initialValue;
  final int minValue;
  final int maxValue;
  final String? unit;
  final EdgeInsets padding;
  final void Function(int newValue) onValueChanged;

  const NumberPicker(
      {super.key,
      required this.onValueChanged,
      required this.padding,
      required this.minValue,
      required this.maxValue,
      required this.initialValue,
      this.unit});

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
    return Padding(
      padding: widget.padding,
      child: Container(
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            color: Color.fromRGBO(234, 234, 236, 1.0)),
        height: 40,
        child: Row(children: [
          _valueText(),
          _changeValueButtons(),
        ]),
      ),
    );
  }

  /// A text widget containing the value of this number picker
  Widget _valueText() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          Positioned(
            top: 4.75,
            right: constraints.maxWidth / 2 - 10,
            child: Text(
              _currValue.toString(),
              style: const TextStyle(fontSize: 26.0),
            ),
          ),
          _unitText(constraints),
        ],
      );
    }));
  }

  /// Returns a positioned text containing the unit if the unit is not null
  Widget _unitText(BoxConstraints constraints) {
    if (widget.unit == null) {
      return Container();
    }

    return Positioned(
        top: 13,
        left: constraints.maxWidth / 2 + 12,
        child: Text(
          widget.unit!,
          style: const TextStyle(fontSize: 18.0),
        ));
  }

  /// A plus and a minus button in a single row
  Widget _changeValueButtons() {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          color: Color.fromRGBO(214, 214, 215, 1.0)),
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
          _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
            _decreaseValueBy(1);
          });
        },
        onLongPressUp: () {
          _timer.cancel();
        },
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          onTap: () => _decreaseValueBy(1),
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Icon(Icons.remove),
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
          _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
            _increaseValueBy(1);
          });
        },
        onLongPressUp: () {
          _timer.cancel();
        },
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(7.0)),
          onTap: () => _increaseValueBy(1),
          child: const Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Icon(Icons.add),
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
      setState(() {
        _currValue = newValue;
      });
      widget.onValueChanged(newValue);
    }
  }
}
