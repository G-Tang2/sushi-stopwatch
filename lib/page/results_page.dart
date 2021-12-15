import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';

class ResultsPage extends StatelessWidget {
  static const String route = '/results';
  final Duration _duration;
  final double _secondsPerRoll;
  final double _numberOfRolls;

  const ResultsPage(this._duration, this._secondsPerRoll, this._numberOfRolls,
      {Key? key})
      : super(key: key);

  Widget outcome() {
    final actualSecondsPerRoll = (_duration.inSeconds / _numberOfRolls).round();
    final paceDifference = actualSecondsPerRoll - _secondsPerRoll.round();
    final rollsPerHour = ((60 * 60) / actualSecondsPerRoll).round();
    String result = paceDifference <= 0 ? "PASSED" : "FAILED";
    return Container(
      margin: const EdgeInsets.all(35),
      child: Column(children: [
        Container(
            margin: const EdgeInsets.only(bottom: 70),
            child: Text(
              result,
              style: TextStyle(
                  color: paceDifference <= 0 ? Colors.green : Colors.red,
                  fontSize: 64),
            )),
        RichText(
            text: TextSpan(
                style: const TextStyle(height: 1.5, fontSize: 32),
                children: <TextSpan>[
              const TextSpan(text: 'You took '),
              TextSpan(
                  text: FormattedTime(_duration).formattedTime(),
                  style: const TextStyle(color: Colors.yellowAccent)),
              const TextSpan(text: ' to make '),
              TextSpan(
                  text: '${_numberOfRolls.round()} handrolls',
                  style: TextStyle(color: Colors.purple[200])),
              const TextSpan(text: '. That\'s an average pace of '),
              TextSpan(
                  text: '${actualSecondsPerRoll}s/roll',
                  style: const TextStyle(color: Colors.orange)),
              TextSpan(
                  text: paceDifference <= 0
                      ? ' (${paceDifference}s/roll)'
                      : ' (+${paceDifference}s/roll)',
                  style: TextStyle(color: Colors.grey[400])),
              const TextSpan(text: ', equivalent to '),
              TextSpan(
                  text: '$rollsPerHour rolls/hr',
                  style: TextStyle(color: Colors.teal[200])),
              const TextSpan(text: '.')
            ]))
      ]),
    );
  }

  Widget reportInfo() {
    if (_duration.inSeconds > 5) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          outcome(),
        ],
      );
    } else {
      return Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(35),
          child: const Text(
            'Mate, you can\'t finish making hand rolls that quickly.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
          ));
    }
  }

  Widget homeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            Navigator.popUntil(
                context, (Route<dynamic> predicate) => predicate.isFirst);
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
            Expanded(child: reportInfo()),
            Container(
              child: homeButton(context),
              margin: const EdgeInsets.fromLTRB(15, 20, 15, 30),
            )
          ])),
    );
  }
}
