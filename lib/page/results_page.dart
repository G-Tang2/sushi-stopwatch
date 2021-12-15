import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';

class ResultsPage extends StatelessWidget {
  static const String route = '/results';
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

  Widget homeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(
                context,
                (Route<dynamic> predicate) =>
                    predicate.isFirst); // TODO: Issue with named routes
          },
          child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 13, 0, 8),
              child: Text(
                'CLOSE',
                style: TextStyle(fontSize: 32),
              ))),
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
            Container(
              child: homeButton(context),
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
            )
          ])),
    );
  }
}
