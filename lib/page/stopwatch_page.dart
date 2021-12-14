import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/page/results_page.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';

class StopWatchPage extends StatefulWidget {
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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              FormattedTime(_duration).buildTime(),
              buildStopwatchButtons(),
              buildConfigFields()
            ])),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ResultsPage(_duration, _numberOfRolls))).then((value) {
            reset();
          });
        },
        child: const Text('STOP'));
  }

  Widget buildStopwatchButtons() {
    final isRunning = _timer == null ? false : _timer!.isActive;
    final isCompleted = _duration.inMilliseconds == 0;

    return isRunning || !isCompleted
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
                : ElevatedButton(
                    onPressed: pauseTimer, child: const Text('RESET')),
          ])
        : ElevatedButton(
            onPressed: () {
              startTimer();
            },
            child: const Text('START'));
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

  Widget sliderWithText(
      {required String displayText,
      required double value,
      required double min,
      required double max,
      required callback}) {
    return Column(children: <Widget>[
      Text(displayText),
      Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: (value) {
            callback(value);
          })
    ]);
  }

  Widget buildConfigFields() {
    final isCompleted = _duration.inMilliseconds == 0;
    double estimatedTime = _secondsPerRoll * _numberOfRolls;
    final duration = Duration(seconds: estimatedTime.round());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final rollsPerHour = (60 * 60 / _secondsPerRoll).round();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          isCompleted
              ? Column(children: <Widget>[
                  sliderWithText(
                      displayText:
                          'Seconds per roll: ${_secondsPerRoll.round()} \n($rollsPerHour rolls per hour)',
                      value: _secondsPerRoll,
                      min: 10,
                      max: 60,
                      callback: updateSecondPerRoll),
                  sliderWithText(
                      displayText: 'Number of rolls: ${_numberOfRolls.round()}',
                      value: _numberOfRolls,
                      min: 1,
                      max: 32,
                      callback: updateNumberOfRolls),
                  Text('Estimated duration: ${minutes}m ${seconds}s'),
                ])
              : Column(children: <Widget>[
                  Text('Seconds per roll: ${_secondsPerRoll.round()}s'),
                  Text(
                      'Expected number of rolls completed: $_expectedCompletedRolls')
                ])
        ]);
  }
}
