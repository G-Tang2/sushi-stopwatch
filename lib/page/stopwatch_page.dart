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
    startTimer();
  }

  void addTime() {
    const addMilliseconds = 47;
    setState(() {
      final milliseconds = duration.inMilliseconds + addMilliseconds;
      duration = Duration(milliseconds: milliseconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(milliseconds: 47), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: buildTime()),
      );

  Widget buildTime() {
    String padDigits(int n, int padLength) =>
        n.toString().padLeft(padLength, '0');
    final minutes = padDigits(duration.inMinutes.remainder(60), 2);
    final seconds = padDigits(duration.inSeconds.remainder(60), 2);
    final milliseconds = padDigits(duration.inMilliseconds.remainder(1000), 3);
    return Text('$minutes:$seconds:$milliseconds');
  }
}
