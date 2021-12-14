import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';

class ResultsPage extends StatelessWidget {
  final Duration _duration;
  final double _numberOfRolls;

  const ResultsPage(this._duration, this._numberOfRolls, {Key? key})
      : super(key: key);

  Widget reportInfo() {
    final secondsPerRoll = _duration.inSeconds / _numberOfRolls;
    final rollsPerHour = ((60 * 60) / secondsPerRoll).round();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FormattedTime(_duration).buildTime(),
        Text('${secondsPerRoll}s/roll ($rollsPerHour rolls/hr)')
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            reportInfo(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('BACK'))
          ])),
    );
  }
}
