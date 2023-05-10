import 'package:flutter/cupertino.dart';

/// A scroll wheel that allows the user to choose a number between the given min
/// and max. The scroll wheel is preprended with the given title and subtitle.
class NumberPicker extends StatelessWidget {
  final String title;
  final String? subtitle;

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
      this.subtitle});

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  getSubtitle(),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                magnification: 1.22,
                squeeze: 1.0,
                useMagnifier: true,
                itemExtent: 35.0,
                onSelectedItemChanged: (int selectedItem) {
                  onItemChanged(selectedItem + 1);
                },
                scrollController: FixedExtentScrollController(
                  initialItem: initialValue - 1
                ),
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

  /// Returns a Text widget for the subtitle or null if subtitle does not exist
  Widget getSubtitle() {
    if (subtitle != null) {
      return Text(subtitle!, style: const TextStyle(fontSize: 12.0));
    }

    return Container();
  }
}
