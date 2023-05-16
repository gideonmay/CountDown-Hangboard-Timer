import 'package:flutter/material.dart';

/// A standard header used throughout the app
class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 20.0)),
    );
  }
}
