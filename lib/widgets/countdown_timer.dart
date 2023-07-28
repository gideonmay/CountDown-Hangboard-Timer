import 'dart:math' as math;
import 'package:countdown_app/models/timer_details_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import '../extensions/duration_ceil_extension.dart';
import '../models/audio_pool.dart';
import '../models/duration_status_list.dart';
import '../models/timer_durations_dto.dart';
import '../services/shared_preferences_service.dart';
import '../utils/sound_utils.dart';
import '../widgets/grip_details_text.dart';
import '../widgets/timer_control_buttons.dart';
import '../widgets/timer_details.dart';
import '../widgets/time_text_row.dart';

/// Defines the countdown timer, which takes a DurationStatusList, then produces
/// and animation of the timer. The timer can be started, paused, and reset
/// using a set of buttons included in this widget.
class CountdownTimer extends StatefulWidget {
  final TimerDurationsDTO? timerDurations;

  /// The workout to execute the timer for. Overrides timerDurations if given.
  final DurationStatusList? durationStatusList;

  const CountdownTimer({
    super.key,
    required this.timerDurations,
  }) : durationStatusList = null;

  /// Creates a countdown timer from a list of grips for a particular workout
  const CountdownTimer.fromList({
    super.key,
    required this.durationStatusList,
  }) : timerDurations = null;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer>
    with TickerProviderStateMixin {
  late DurationStatusList _durationStatusList;
  late final SharedPreferencesService _prefService;

  /// The index in the durationStatusList that the timer is currently on
  int _durationIndex = 0;

  /// Indicates if timer has started yet
  bool _hasStarted = false;

  /// Indicates if timer is currently paused
  bool _isPaused = false;

  /// Indicates if audio has already played at 1, 2 and 3 second marks
  final Map<int, bool> _hasPlayedAtSecond = {1: false, 2: false, 3: false};

  late int _lowBeepIndex;
  late int _highBeepIndex;
  final _audioPool = AudioPool();
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSharedPreferences();

    // Initialize DurationStatusList based on which constructor was used
    if (widget.timerDurations != null) {
      final timerDetails = TimerDetailsDTO(
          totalSets: widget.timerDurations!.sets,
          totalReps: widget.timerDurations!.reps,
          workDuration: widget.timerDurations!.workDuration,
          restDuration: widget.timerDurations!.restDuration,
          breakDuration: widget.timerDurations!.breakDuration);

      _durationStatusList = TimerDurationStatusList(
          durationStatusListDTO: DurationStatusListDTO(
              timerDetails: timerDetails,
              includePrepare: true,
              includeLastBreak: false));
    }

    if (widget.durationStatusList != null) {
      _durationStatusList = widget.durationStatusList!;
    }

    // Initialize AnimationController and associated listeners
    _controller = AnimationController(
      duration: _durationStatusList[_durationIndex].duration,
      vsync: this,
    )
      ..addStatusListener((status) {
        // Play final beep once countdown timer reaches zero
        if (status == AnimationStatus.completed) {
          _playFinalBeepAndVibration();
        }

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
      })
      ..addListener(() {
        _playLeadingBeepAndVibration();
      });
  }

  /// Loads shared preferences service and timer audio files
  Future<void> _loadSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _prefService = SharedPreferencesService(sharedPreferences: prefs);

    final soundIndex = _prefService.getTimerSoundIndex();
    final filePrefix = timerSoundList[soundIndex].filePrefix;
    _lowBeepIndex = _audioPool.addAsset('assets/audio/${filePrefix}_low.wav');
    _highBeepIndex = _audioPool.addAsset('assets/audio/${filePrefix}_high.wav');
  }

  /// Plays the beep and vibration at the zero second mark
  void _playFinalBeepAndVibration() {
    // Reset played state of leading beeps
    _hasPlayedAtSecond[3] = false;
    _hasPlayedAtSecond[2] = false;
    _hasPlayedAtSecond[1] = false;

    // Play final beep and vibrate
    _playBeep(_highBeepIndex);
    _vibrate();
  }

  /// Plays beeps and vibrations at the 3, 2, and 1 second marks in the timer.
  void _playLeadingBeepAndVibration() {
    if (!_hasPlayedAtSecond[3]! && timerString == '0:03') {
      // Do not play the beep if the current duration is 3 seconds long
      if (_durationStatusList[_durationIndex].duration.inSeconds != 3) {
        _hasPlayedAtSecond[3] = true;
        _playBeep(_lowBeepIndex);
        _vibrate();
      }
    }

    if (!_hasPlayedAtSecond[2]! && timerString == '0:02') {
      // Do not play the beep if the current duration is 2 seconds long
      if (_durationStatusList[_durationIndex].duration.inSeconds != 2) {
        _hasPlayedAtSecond[2] = true;
        _playBeep(_lowBeepIndex);
        _vibrate();
      }
    }

    if (!_hasPlayedAtSecond[1]! && timerString == '0:01') {
      // Do not play the beep if the current duration is 1 second long
      if (_durationStatusList[_durationIndex].duration.inSeconds != 1) {
        _hasPlayedAtSecond[1] = true;
        _playBeep(_lowBeepIndex);
        _vibrate();
      }
    }
  }

  /// Vibrates if the vibration setting is on
  void _vibrate() {
    if (_prefService.getVibrationOn()) {
      Vibration.vibrate(duration: 500);
    }
  }

  /// Plays a beep if the sound setting is on
  void _playBeep(int beepIndex) {
    if (_prefService.getSoundOn()) {
      _audioPool.play(beepIndex);
    }
  }

  /// Returns a string representing the time left in the format "M:SS". If the
  /// time left is a fraction of a second, then the time shown is rounded up to
  /// the nearest second. This allows the current second being counted down to
  /// be displayed, as opposed to showing the next second in the countdown.
  String get timerString {
    final Duration timeLeftCeil = _timeLeft.ceil(const Duration(seconds: 1));
    final String timeLeftStr = _durationString(timeLeftCeil);

    /// Only show a time of zero on the very last countdown. This prevents
    /// animation jank where zero flashes very briefly before starting next
    /// countdown.
    if (timeLeftStr == '0:00' &&
        _durationIndex < _durationStatusList.length - 1) {
      return '0:01';
    }

    return timeLeftStr;
  }

  /// Returns a Duration object representing the time left in the countdown
  Duration get _timeLeft {
    return _controller.duration! - (_controller.duration! * _controller.value);
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return _timerLayout(constraints);
    });
  }

  /// Returns the timer with or without the grip details text
  Widget _timerLayout(BoxConstraints constraints) {
    // Do not show grip details text if there are were no grips given
    if (_durationStatusList[_durationIndex].timerDetails.totalGrips == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _timerDetails(),
          _animatedTimer(constraints),
          _timerControlButtons(),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _timerDetails(),
        _gripDetailsText(),
        _animatedTimer(constraints),
        _timerControlButtons(),
      ],
    );
  }

  /// The widget above the timer that displays info about sets, reps, grips, and
  /// the timer durations
  Widget _timerDetails() {
    return Flexible(
      flex: 19,
      child: TimerDetails(
        currSet: _durationStatusList[_durationIndex].currSet,
        currRep: _durationStatusList[_durationIndex].currRep,
        timerDetails: _durationStatusList[_durationIndex].timerDetails,
        currGrip: _durationStatusList[_durationIndex].currGrip,
      ),
    );
  }

  /// The text that displays the name of the current and next grips
  Widget _gripDetailsText() {
    return Flexible(
        flex: 10,
        child: GripDetailsText(
          currGripName: _durationStatusList[_durationIndex].gripName,
          nextGripName: _durationStatusList[_durationIndex].nextGripName,
        ));
  }

  /// The widget that renders the timer animation
  Widget _animatedTimer(BoxConstraints constraints) {
    return Flexible(
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
                      color: _durationStatusList[_durationIndex].statusColor,
                      width: getTimerWidth(constraints)),
                  child: Container(),
                ),
                _timerCenterText()
              ],
            );
          }),
    );
  }

  /// The buttons that control the timer
  Widget _timerControlButtons() {
    return Flexible(
      flex: 25,
      child: TimerControlButtons(
          hasStarted: _hasStarted,
          isPaused: _isPaused,
          startTimer: startTimer,
          pauseTimer: pauseTimer,
          resumeTimer: resumeTimer,
          resetTimer: resetTimer,
          skipDuration: skipDuration),
    );
  }

  /// Returns the minimum between the widgets current width and height. This
  /// ensures that the timer animation never exceeds that available space.
  double getTimerWidth(BoxConstraints constraints) {
    double width = math.min(constraints.maxWidth, constraints.maxHeight);
    return width * 0.87; // Value arbitrarily chosen based on what looks good
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
          _controller.forward();
        }
      }
    });
  }

  /// The text showing the current timer information
  Widget _timerCenterText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _timerCountdown(),
        _timerStatus(),
      ],
    );
  }

  /// Returns text showing the timer status and current countdown duration
  Widget _timerCountdown() {
    return Column(
      children: [
        Text(
          _durationStatusList[_durationIndex].status,
          style: TextStyle(
            fontSize: 38.0,
            color: _durationStatusList[_durationIndex].statusColor,
          ),
        ),
        Text(
          timerString,
          style: const TextStyle(fontSize: 112.0),
        ),
      ],
    );
  }

  /// Returns a widget displaying the total time and the elapsed time
  Widget _timerStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TimeTextRow(
              title: 'Total ',
              durationString: _durationString(
                  Duration(seconds: _durationStatusList.totalSeconds)),
              fontSize: 20.0,
              titleWidth: 80.0),
        ),
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: TimeTextRow(
              title: 'Elapsed ',
              durationString: _elapsedDurationString(),
              fontSize: 20.0,
              titleWidth: 80.0),
        ),
      ],
    );
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
      {required this.color, required this.animation, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw circle
    Offset center = Offset(size.width / 2, size.height / 2);
    Paint circlePaint = Paint()
      ..color = CupertinoColors.systemGrey5
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, width / 2, circlePaint);

    // Draw progress arc on top of circle
    Paint arcPaint = Paint()
      ..color = color
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    double progress = (1.0 - animation.value) * 2 * math.pi;
    Rect rect = Rect.fromCenter(center: center, width: width, height: width);
    canvas.drawArc(rect, math.pi * 3 / 2, progress, false, arcPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
