import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../extensions/duration_ceil_extension.dart';
import '../models/duration_status_list.dart';
import '../models/timer_durations_dto.dart';
import '../widgets/timer_control_buttons.dart';
import '../widgets/timer_details.dart';
import '../widgets/time_text_row.dart';

/// Defines the countdown timer, which takes a DurationStatusList, then produces
/// and animation of the timer. The timer can be started, paused, and reset
/// using a set of buttons included in this widget.
class CountdownTimer extends StatefulWidget {
  final TimerDurationsDTO timerDurations;

  const CountdownTimer({super.key, required this.timerDurations});

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  late DurationStatusList _durationStatusList;

  /// The index in the durationStatusList that the timer is currently on
  int _durationIndex = 0;

  /// Indicates if timer has started yet
  bool _hasStarted = false;

  /// Indicates if timer is currently paused
  bool _isPaused = false;
  late final AnimationController _controller;

  /// Starts the countdown timer
  void startTimer() {
    setState(() {
      _durationIndex = 0;
      _controller.duration = _durationStatusList[_durationIndex].duration;
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
      _controller.duration = _durationStatusList[_durationIndex].duration;
      _controller.reset();
      _hasStarted = false;
      _isPaused = false;
    });
  }

  /// Skips to next element
  void skipDuration() {
    setState(() {
      // Do not skip if already at last element
      if (_durationIndex < _durationStatusList.length - 1) {
        _controller.stop();
        _durationIndex++;
        _controller.duration = _durationStatusList[_durationIndex].duration;
        _controller.reset();

        // Continue animation if timer not currently paused
        if (!_isPaused) {
          _controller.forward();
        }

        // Restore buttons to initial state if last duration has been reached
        if (_durationIndex == _durationStatusList.length - 1) {
          _hasStarted = false;
          _isPaused = false;
        }
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

    // Initialize DurationStatusList
    _durationStatusList = DurationStatusList(
        sets: widget.timerDurations.sets.toInt(),
        reps: widget.timerDurations.reps.toInt(),
        workDuration: widget.timerDurations.workDuration,
        restDuration: widget.timerDurations.restDuration,
        breakDuration: widget.timerDurations.breakDuration,
        includePrepare: true);

    // Initialize AnimationController and associated listeners
    _controller = AnimationController(
      duration: _durationStatusList[_durationIndex].duration,
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            _durationIndex == _durationStatusList.length - 1) {
          // Mark timer as completed and reset buttons to start point
          setState(() {
            _hasStarted = false; // Changes buttons to initial starting state
          });
        } else if (status == AnimationStatus.completed &&
            _durationIndex < _durationStatusList.length - 1) {
          // Move timer to next DurationStatus if there are any left
          setState(() {
            _durationIndex++;
            _controller.duration = _durationStatusList[_durationIndex].duration;
            _controller.reset();
            _controller.forward();
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
        _durationIndex < _durationStatusList.length - 1) {
      timeLeftCeil = const Duration(seconds: 1);
    }

    timeLeftCeil = timeLeft.ceil(const Duration(seconds: 1));
    return _durationString(timeLeftCeil);
  }

  /// Takes a Duration object then returns a String formatted like "M:SS"
  String _durationString(Duration? duration) {
    if (duration == null) {
      return '0:00';
    }

    int minutesLeft = duration.inMinutes;
    int secondsLeft = duration.inSeconds % 60;
    return '$minutesLeft:${(secondsLeft).toString().padLeft(2, '0')}';
  }

  /// Returns a String representing the total duration that has passed during
  /// this workout
  String _elapsedDurationString() {
    return _durationString(_elapsedDuration());
  }

  /// Returns the total duration that has passed during the current countdown
  Duration _elapsedDuration() {
    Duration startDuration = _durationStatusList[_durationIndex].startTime;

    // Get duration of current countdown
    Duration? elapsedDuration = _controller.duration;

    if (elapsedDuration != null) {
      // elapsedDuration * value gives duration passed for current countdown
      return startDuration + (elapsedDuration * _controller.value);
    }

    return startDuration;
  }

  /// Returns the minimum between the widgets current width and height. This
  /// ensures that the timer animation never exceeds that available space.
  double getTimerWidth(BoxConstraints constraints) {
    double width = math.min(constraints.maxWidth, constraints.maxHeight);
    return width * 0.87; // 0.87 arbitrarily chosen based on what looks good
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 18,
            child: TimerDetails(
                timerDurations: widget.timerDurations,
                currentSet: _durationStatusList[_durationIndex].currSet,
                currentRep: _durationStatusList[_durationIndex].currRep),
          ),
          Flexible(
            flex: 75,
            child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, Widget? child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        painter: ArcPainter(
                            animation: _controller,
                            color:
                                _durationStatusList[_durationIndex].statusColor,
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
                      Positioned(
                        top: constraints.maxHeight / 2 - 240,
                        child: Text(
                          _durationStatusList[_durationIndex].status,
                          style: TextStyle(
                            fontSize: 40.0,
                            color:
                                _durationStatusList[_durationIndex].statusColor,
                          ),
                        ),
                      ),
                      Positioned(
                          top: constraints.maxHeight / 2 - 65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TimeTextRow(
                                    title: 'Total ',
                                    durationString: _durationString(Duration(
                                        seconds:
                                            _durationStatusList.totalSeconds))),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: TimeTextRow(
                                    title: 'Elapsed ',
                                    durationString: _elapsedDurationString()),
                              ),
                            ],
                          )),
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
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    double progress = (1.0 - animation.value) * 2 * math.pi;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCenter(center: center, width: width, height: width);

    canvas.drawArc(rect, math.pi * 3 / 2, progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
