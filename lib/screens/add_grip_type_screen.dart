import 'package:flutter/cupertino.dart';

class AddGripTypeScreen extends StatelessWidget {
  const AddGripTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          previousPageTitle: 'Add Grip',
          middle: const Text('Add Grip Type'),
        ),
        child: SafeArea(child: Container()));
  }
}
