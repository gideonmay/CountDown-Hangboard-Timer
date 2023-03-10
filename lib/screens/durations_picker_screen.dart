import 'package:flutter/material.dart';
import '../widgets/durations_picker_form.dart';

/// A screen with a form that allows the user to choose the work, rest, and
/// break durations in addition to the number or reps and sets.
class DurationsPickerScreen extends StatefulWidget {
  const DurationsPickerScreen({super.key});

  @override
  State<DurationsPickerScreen> createState() => _DurationsPickerScreenState();
}

class _DurationsPickerScreenState extends State<DurationsPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer'),
      ),
      body: const DurationsPickerForm()
    );
  }
}
