import 'dart:async';

import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopWatchPage> {
  Duration duration = const Duration();
  Timer? timer;

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
  }

  void reset() {
    setState(() => duration = Duration());
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
        body: Center(child: Column(children: [buildTime(), buildButtons()])),
      );

  Widget buildTime() {
    String padDigits(int n, int padLength) =>
        n.toString().padLeft(padLength, '0');
    final minutes = padDigits(duration.inMinutes.remainder(60), 2);
    final seconds = padDigits(duration.inSeconds.remainder(60), 2);
    final milliseconds = padDigits(duration.inMilliseconds.remainder(1000), 3);
    return Text('$minutes:$seconds:$milliseconds');
  }

  Widget buildButtons() {
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
}
