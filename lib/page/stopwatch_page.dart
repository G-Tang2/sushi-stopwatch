import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/page/results_page.dart';
import 'package:sushi_stopwatch/route_generator.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';

class StopWatchPage extends StatefulWidget {
  static const String route = '/stopwatch';

  const StopWatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopWatchPage> {
  Duration _duration = const Duration();
  Timer? _timer;
  double _secondsPerRoll = 30;
  double _numberOfRolls = 8;
  int _expectedCompletedRolls = 0;
  final int _intervalInMilliseconds = 47;
  final AudioCache _audioCache = AudioCache(
    prefix: 'assets/audio/',
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(children: [
                  const Spacer(flex: 5),
                  FormattedTime(_duration).buildTime(),
                  const Spacer(flex: 3),
                ])),
                Container(
                  child: buildStopwatchButtons(),
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                )
              ]),
        ),
      );

  void addTime() {
    setState(() {
      final milliseconds = _duration.inMilliseconds + _intervalInMilliseconds;
      _duration = Duration(milliseconds: milliseconds);
    });

    intervalNotification(_secondsPerRoll);
  }

  void intervalNotification(double intervalInSeconds) {
    if (_duration.inSeconds % intervalInSeconds == 0 &&
        _duration.inMilliseconds % 1000 < _intervalInMilliseconds) {
      _expectedCompletedRolls++;
      _audioCache.play('beep.mp3');
    }
  }

  void reset() {
    setState(() {
      _duration = const Duration();
      _expectedCompletedRolls = 0;
    });
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 47), (_) => addTime());
  }

  void pauseTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() => _timer?.cancel());
  }

  Widget stopTimer() {
    return ElevatedButton(
        onPressed: () {
          pauseTimer(resets: false);
          Navigator.pushNamed(context, ResultsPage.route,
                  arguments: ResultsArguments(_duration, _numberOfRolls))
              .then((value) {
            reset();
          });
        },
        child: const Text('STOP'));
  }

  Widget buildStopwatchButtons() {
    final isRunning = _timer == null ? false : _timer!.isActive;

    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      ElevatedButton(
          onPressed: () {
            if (isRunning) {
              pauseTimer(resets: false);
            } else {
              startTimer(resets: false);
            }
          },
          child: Text(isRunning ? 'PAUSE' : 'RESUME')),
      isRunning
          ? stopTimer()
          : ElevatedButton(onPressed: pauseTimer, child: const Text('RESET')),
    ]);
  }

  void updateSecondPerRoll(double value) {
    setState(() {
      _secondsPerRoll = value;
    });
  }

  void updateNumberOfRolls(double value) {
    setState(() {
      _numberOfRolls = value;
    });
  }
}
