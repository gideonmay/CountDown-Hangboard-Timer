import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../extensions/duration_ceil_extension.dart';
import '../models/duration_status_list.dart';
import '../widgets/timer_control_buttons.dart';

/// Defines the countdown timer, which takes a DurationStatusList, then produces
/// and animation of the timer. The timer can be started, paused, and reset
/// using a set of buttons included in this widget.
class CountdownTimer extends StatefulWidget {
  final DurationStatusList durationStatusList;

  const CountdownTimer({super.key, required this.durationStatusList});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  /// The index in the durationStatusList that the timer is currently on
  int _durationIndex = 0;

  /// Indicates if timer has started yet
  bool _hasStarted = false;

  /// Indicates if timer is currently paused
  bool _isPaused = false;

  /// Indicates if the workout has completed
  bool _isComplete = false;
  late final AnimationController _controller;

  /// Starts the countdown timer
  void startTimer() {
    setState(() {
      _durationIndex = 0;
      _controller.duration = widget.durationStatusList[_durationIndex].duration;
      _controller.reset();
      _controller.forward();
      _hasStarted = true;
    });
  }

  /// Pauses timer operation
  void pauseTimer() {
    setState(() {
      _controller.stop();
      _isPaused = true;
    });
  }

  /// Resumes timer operation
  void resumeTimer() {
    setState(() {
      _controller.forward();
      _isPaused = false;
    });
  }

  /// Resets timer to initial state
  void resetTimer() {
    setState(() {
      _durationIndex = 0;
      _controller.duration = widget.durationStatusList[_durationIndex].duration;
      _controller.reset();
      _hasStarted = false;
      _isPaused = false;
    });
  }

  /// Skips to next element
  void skipDuration() {
    setState(() {
      // Do not skip if already at last element
      if (_durationIndex < widget.durationStatusList.length - 1) {
        _durationIndex++;
        _controller.duration =
            widget.durationStatusList[_durationIndex].duration;
        _controller.reset();
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.durationStatusList[_durationIndex].duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            _durationIndex < widget.durationStatusList.length - 1) {
          // Move timer to next DurationStatus if there are any left
          setState(() {
            _durationIndex++;
            _controller.duration =
                widget.durationStatusList[_durationIndex].duration;
            _controller.reset();
            _controller.forward();
          });
        } else if (status == AnimationStatus.completed &&
            _durationIndex == widget.durationStatusList.length - 1) {
          // Mark timer as completed and reset buttons to start point
          setState(() {
            _isComplete = true;
            _hasStarted = false; // Changes buttons to initial starting state
          });
        }
      });
  }

  /// Returns a Duration object representing the time left in the countdown
  Duration get timeLeft {
    return _controller.duration! - (_controller.duration! * _controller.value);
  }

  /// Returns a string representing the time left in the format "M:SS". If the
  /// time left is a fraction of a second, then the time shown is rounded up to
  /// the nearest second. This allows the current second being counted down to
  /// be displayed, as opposed to showing the next second in the countdown.
  String get timerString {
    Duration timeLeftCeil;

    /// Only show a time of zero on the very last countdown. This prevents
    /// animation jank where zero flashes very briefly before starting next
    /// countdown.
    if (timeLeft == Duration.zero &&
        _durationIndex < widget.durationStatusList.length - 1) {
      timeLeftCeil = const Duration(seconds: 1);
    }

    timeLeftCeil = timeLeft.ceil(const Duration(seconds: 1));
    int minutesLeft = timeLeftCeil.inMinutes;
    int secondsLeft = timeLeftCeil.inSeconds % 60;
    return '$minutesLeft:${(secondsLeft).toString().padLeft(2, '0')}';
  }

  /// Returns the minimum between the widgets current width and height. This
  /// ensures that the timer animation never exceeds that available space.
  double getTimerWidth(BoxConstraints constraints) {
    double width = math.min(constraints.maxWidth, constraints.maxHeight);
    return width * 0.87;  // 0.87 arbitrarily chosen based on what looks good
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 75,
            child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Stack(
                    children: [
                      CustomPaint(
                        painter: ArcPainter(
                            animation: _controller,
                            color: widget
                                .durationStatusList[_durationIndex].statusColor,
                            width: getTimerWidth(constraints)),
                        child: Container(),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Text(
                            timerString,
                            style: const TextStyle(fontSize: 112.0),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
          Flexible(
            flex: 25,
            child: TimerControlButtons(
                hasStarted: _hasStarted,
                isPaused: _isPaused,
                startTimer: startTimer,
                pauseTimer: pauseTimer,
                resumeTimer: resumeTimer,
                resetTimer: resetTimer,
                skipDuration: skipDuration),
          )
        ],
      );
    });
  }
}

/// Paints an Arc to visualize the time left in the countdown
/// Adapted from:
/// https://medium.flutterdevs.com/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1
class ArcPainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;
  final double width;

  ArcPainter(
      {required this.color, required this.animation, required this.width})
      : super();

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;

    double progress = (1.0 - animation.value) * 2 * math.pi;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCenter(center: center, width: width, height: width);

    canvas.drawArc(rect, math.pi * 3 / 2, progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
