import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  final Duration _duration;
  final double _numberOfRolls;

  ReportPage(this._duration, this._numberOfRolls);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(children: <Widget>[
        Text('$_duration'),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('BACK'))
      ])),
    );
  }
}
