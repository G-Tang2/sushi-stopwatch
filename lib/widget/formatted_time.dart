import 'package:flutter/material.dart';

class FormattedTime extends StatelessWidget {
  final Duration _duration;

  const FormattedTime(this._duration, {Key? key}) : super(key: key);

  Widget buildTime() {
    String padDigits(int n, int padLength) =>
        n.toString().padLeft(padLength, '0');
    final minutes = padDigits(_duration.inMinutes.remainder(60), 2);
    final seconds = padDigits(_duration.inSeconds.remainder(60), 2);
    final milliseconds = padDigits(_duration.inMilliseconds.remainder(1000), 3);
    return Text('$minutes:$seconds:$milliseconds');
  }

  @override
  Widget build(BuildContext context) {
    return buildTime();
  }
}
