import 'package:flutter/material.dart';

/// A popup dialog that shows a helper message with a title, body, and an
/// option to display a helper image
class HelperDialog extends StatelessWidget {
  final String title;
  final String body;
  final Image image;

  const HelperDialog(
      {super.key,
      required this.title,
      required this.body,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 8.0, 0),
                    child: Icon(
                      Icons.help,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(title,
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Text(
              body,
              style: const TextStyle(fontSize: 16.0),
            ),
            Container(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: image)),
            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
