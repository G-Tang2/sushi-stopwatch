import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopWatchPage> {
  Duration duration = const Duration();
  Timer? timer;
  double _secondsPerRoll = 30;
  final AudioCache _audioCache = AudioCache(
    prefix: 'assets/audio/',
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  @override
  void initState() {
    super.initState();
  }

  void addTime() {
    const addMilliseconds = 47;
    setState(() {
      final milliseconds = duration.inMilliseconds + addMilliseconds;
      duration = Duration(milliseconds: milliseconds);
    });

    intervalNotification(_secondsPerRoll);
  }

  void intervalNotification(double intervalInSeconds) {
    if (duration.inSeconds % intervalInSeconds == 0 &&
        duration.inMilliseconds % 1000 < 47) {
      _audioCache.play('beep.mp3');
    }
  }

  void reset() {
    setState(() => duration = const Duration());
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    timer = Timer.periodic(const Duration(milliseconds: 47), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Column(children: [
          buildTime(),
          buildStopwatchButtons(),
          buildConfigFields()
        ])),
      );

  Widget buildTime() {
    String padDigits(int n, int padLength) =>
        n.toString().padLeft(padLength, '0');
    final minutes = padDigits(duration.inMinutes.remainder(60), 2);
    final seconds = padDigits(duration.inSeconds.remainder(60), 2);
    final milliseconds = padDigits(duration.inMilliseconds.remainder(1000), 3);
    return Text('$minutes:$seconds:$milliseconds');
  }

  Widget buildStopwatchButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = duration.inMilliseconds == 0;

    return isRunning || !isCompleted
        ? Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  if (isRunning) {
                    stopTimer(resets: false);
                  } else {
                    startTimer(resets: false);
                  }
                },
                child: Text(isRunning ? 'PAUSE' : 'RESUME')),
            isRunning
                ? Container()
                : ElevatedButton(
                    onPressed: stopTimer, child: const Text('RESET')),
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

  Widget buildConfigFields() {
    final isCompleted = duration.inMilliseconds == 0;
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Seconds per roll: ${_secondsPerRoll.round()}s'),
          isCompleted
              ? Slider(
                  value: _secondsPerRoll,
                  min: 10,
                  max: 60,
                  divisions: 50,
                  onChanged: (value) {
                    updateSecondPerRoll(value);
                  })
              : Container()
        ]);
  }
}
