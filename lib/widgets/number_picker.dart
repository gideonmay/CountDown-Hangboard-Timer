import 'package:flutter/cupertino.dart';

/// A scroll wheel that allows the user to choose a number between the given min
/// and max. The scroll wheel is preprended with the given title and subtitle.
class NumberPicker extends StatelessWidget {
  /// Unit of measure to display (ex. 'hour', 'min.', 'sec.')
  final String? unit;
  final int initialValue;
  final int min;
  final int max;
  final EdgeInsets padding;
  final void Function(int newValue) onItemChanged;

  const NumberPicker(
      {super.key,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.onItemChanged,
      this.unit,
      required this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 50,
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return CupertinoPicker(
            magnification: 1.22,
            squeeze: 1.0,
            useMagnifier: true,
            itemExtent: 35.0,
            onSelectedItemChanged: (int selectedItem) {
              // selectedItem + min equals the index/value of selected item
              onItemChanged(selectedItem + min);
            },
            selectionOverlay: selectionOverlayWithUnit(constraints),
            scrollController: FixedExtentScrollController(
                /*
                   * Subtracting by min gives index of initial value. Example:
                   * if initial=1 and min=0, then initialItem will be 1, which
                   * shows a 1 on the picker
                   */
                initialItem: initialValue - min),
            // Generate a list from min to max (inclusive)
            children: List<Widget>.generate(max - min + 1, (int index) {
              return Center(
                child: Text(
                  (index + min).toString(),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  /// Returns a CupertinoPickerDefaultSelectionOverlay with Text added
  /// specifying a particular unit of measure (ex. mins, secs, hours). If no
  /// unit was specified then returns CupertinoPickerDefaultSelectionOverlay.
  Widget selectionOverlayWithUnit(BoxConstraints constraints) {
    if (unit == null) {
      return const CupertinoPickerDefaultSelectionOverlay();
    }

    return Stack(children: [
      const CupertinoPickerDefaultSelectionOverlay(),
      Positioned(
          top: 11.5,
          right: constraints.maxWidth / 2 - 55,
          child: Text(
            unit!,
            style: const TextStyle(fontSize: 20.0),
          ))
    ]);
  }
}
