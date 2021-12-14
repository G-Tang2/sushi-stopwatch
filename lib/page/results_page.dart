import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';

class ResultsPage extends StatelessWidget {
  final Duration _duration;
  final double _numberOfRolls;

  const ResultsPage(this._duration, this._numberOfRolls, {Key? key})
      : super(key: key);

  Widget reportInfo() {
    double secondsPerRoll;
    int rollsPerHour;
    if (_duration.inSeconds > 5) {
      secondsPerRoll = _duration.inSeconds / _numberOfRolls;
      rollsPerHour = ((60 * 60) / secondsPerRoll).round();
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FormattedTime(_duration).buildTime(),
          Text('${secondsPerRoll}s/roll ($rollsPerHour rolls/hr)')
        ],
      );
    } else {
      return const Text(
          'Mate, you can\'t finish making hand rolls that quickly.',
          textAlign: TextAlign.center);
    }
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
