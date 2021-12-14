import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _secondsPerRoll = 30;
  double _numberOfRolls = 8;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(children: [
                  const Spacer(flex: 5),
                  Text("Placeholder"),
                  const Spacer(flex: 3),
                  Container(
                    child: Column(children: [
                      buildConfigFields(),
                    ]),
                    margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    padding: const EdgeInsets.fromLTRB(10, 25, 10, 25),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade400, width: 1.5)),
                  )
                ])),
                Container(
                  child: buildStopwatchButtons(),
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                )
              ]),
        ),
      );

  Widget buildStopwatchButtons() {
    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/stopwatch');
        },
        child: const Text('START'));
  }

  void updateSecondPerRoll(double value) {
    setState(() {
      _secondsPerRoll = value;
    });
  }

  void updateNumberOfRolls(double value) {
    setState(() {
      _numberOfRolls = value;
    });
  }

  Widget sliderWithText(
      {required String primaryText,
      required String valueText,
      String? secondaryText,
      required double value,
      required double min,
      required double max,
      required callback}) {
    return Column(children: <Widget>[
      Text(primaryText, style: const TextStyle(fontSize: 16)),
      Text(
        valueText,
        style: const TextStyle(fontSize: 24),
      ),
      secondaryText != null
          ? Text('($secondaryText)',
              style: const TextStyle(fontWeight: FontWeight.w300))
          : Container(),
      Slider(
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: (value) {
            callback(value);
          })
    ]);
  }

  Widget buildConfigFields() {
    double estimatedTime = _secondsPerRoll * _numberOfRolls;
    final duration = Duration(seconds: estimatedTime.round());
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    final rollsPerHour = (60 * 60 / _secondsPerRoll).round();

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(children: <Widget>[
            sliderWithText(
                primaryText: 'Seconds per roll',
                valueText: _secondsPerRoll.round().toString(),
                secondaryText: '$rollsPerHour rolls/hr',
                value: _secondsPerRoll,
                min: 10,
                max: 60,
                callback: updateSecondPerRoll),
            Container(
              height: 25,
            ),
            sliderWithText(
                primaryText: 'Number of rolls',
                valueText: _numberOfRolls.round().toString(),
                value: _numberOfRolls,
                min: 1,
                max: 32,
                callback: updateNumberOfRolls),
            Container(
              height: 25,
            ),
            const Text('Estimated duration:'),
            Text('${minutes}m ${seconds}s',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 24)),
          ])
        ]);
  }
}
