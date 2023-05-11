import 'package:flutter/cupertino.dart';

/// A scroll wheel that allows the user to choose a number between the given min
/// and max. The scroll wheel is preprended with the given title and subtitle.
class NumberPicker extends StatelessWidget {
  final String title;

  /// Unit of measure to display (ex. 'hour', 'min.', 'sec.')
  final String? unit;

  /// The width that the title text will take up
  final double titleWidth;
  final int initialValue;
  final int min;
  final int max;
  final void Function(int newValue) onItemChanged;

  const NumberPicker(
      {super.key,
      required this.title,
      required this.initialValue,
      required this.min,
      required this.max,
      required this.onItemChanged,
      required this.titleWidth,
      this.unit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            SizedBox(
              width: titleWidth,
              child: Text(
                title,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.0,
                useMagnifier: true,
                itemExtent: 35.0,
                onSelectedItemChanged: (int selectedItem) {
                  // selectedItem + min equals the index/value of selected item
                  onItemChanged(selectedItem + min);
                },
                selectionOverlay: selectionOverlayWithUnit(context),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a CupertinoPickerDefaultSelectionOverlay with Text added
  /// specifying a particular unit of measure (ex. mins, secs, hours). If no
  /// unit was specified then returns CupertinoPickerDefaultSelectionOverlay.
  Widget selectionOverlayWithUnit(BuildContext context) {
    if (unit == null) {
      return const CupertinoPickerDefaultSelectionOverlay();
    }

    return Stack(children: [
      const CupertinoPickerDefaultSelectionOverlay(),
      Positioned(
          top: 11.5,
          right: MediaQuery.of(context).size.width / 2 - 105.0,
          child: Text(
            unit!,
            style: const TextStyle(fontSize: 20.0),
          ))
    ]);
  }
}
