import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

/// Displays a horizontal progress bar that depicts the number of reps/sets
/// completed compared to the total reps/sets
class ProgressCounter extends StatelessWidget {
  final int completed;
  final int total;
  final String title;
  final double fontSize;

  const ProgressCounter(
      {super.key,
      required this.completed,
      required this.total,
      required this.title,
      required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 48,
          child: Text(
            title,
            style: TextStyle(color: Colors.grey.shade700, fontSize: fontSize),
          ),
        ),
        Expanded(
          child: StepProgressIndicator(
            totalSteps: total,
            currentStep: completed,
            size: 20,
            padding: 1.0,
            selectedColor: Theme.of(context).colorScheme.secondary,
            unselectedColor: Colors.grey.shade300,
            customStep: (index, color, _) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(3.0)),
                    color: color),
                child: Center(
                    child: FittedBox(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(color: Colors.white),
                  ),
                )),
              );
            },
          ),
        )
      ],
    );
  }
}
