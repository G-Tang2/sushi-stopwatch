import 'package:flutter/material.dart';

class StopWatchPage extends StatefulWidget {
  const StopWatchPage({Key? key}) : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopWatchPage> {
  Duration duration = Duration();

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
