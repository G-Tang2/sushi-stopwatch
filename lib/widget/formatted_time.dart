import 'package:flutter/material.dart';

class FormattedTime extends StatelessWidget {
  final Duration _duration;

  const FormattedTime(this._duration, {Key? key}) : super(key: key);

  String _padDigits(int n, int padLength) =>
      n.toString().padLeft(padLength, '0');

  String formattedTime() {
    final minutes = _padDigits(_duration.inMinutes.remainder(60), 2);
    final seconds = _padDigits(_duration.inSeconds.remainder(60), 2);
    final milliseconds =
        _padDigits(_duration.inMilliseconds.remainder(1000), 3);
    return '$minutes:$seconds:$milliseconds';
  }

  Widget buildTime() {
    return Text(formattedTime(), style: const TextStyle(fontSize: 80));
  }

  @override
  Widget build(BuildContext context) {
    return buildTime();
  }
}
