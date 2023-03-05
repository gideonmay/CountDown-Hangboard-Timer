import 'package:flutter/material.dart';
import '../widgets/timer_details_tile.dart';

class TimerDetails extends StatefulWidget {
  const TimerDetails({super.key});

  @override
  State<TimerDetails> createState() => _TimerDetailsState();
}

class _TimerDetailsState extends State<TimerDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        
        Expanded(
          child: Row(
            children: const [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Colors.grey,
                    text: 'Work 0:12',
                    fontSize: 16.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Colors.grey,
                    text: 'Rest 0:03',
                    fontSize: 16.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Colors.grey,
                    text: 'Break 3:00',
                    fontSize: 16.0,
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Set 1/3',
                    fontSize: 20.0,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TimerDetailsTile(
                    color: Theme.of(context).colorScheme.secondary,
                    text: 'Rep 2/8',
                    fontSize: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
