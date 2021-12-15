import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/page/results_page.dart';
import 'package:sushi_stopwatch/route_generator.dart';
import 'package:sushi_stopwatch/widget/formatted_time.dart';
import 'package:wakelock/wakelock.dart';

class StopWatchPage extends StatefulWidget {
  static const String route = '/stopwatch';
  final double secondsPerRoll;
  final double numberOfRolls;

  const StopWatchPage(this.secondsPerRoll, this.numberOfRolls, {Key? key})
      : super(key: key);

  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopWatchPage> {
  Duration _duration = const Duration();
  Timer? _timer;
  int _expectedCompletedRolls = 0;
  final int _intervalInMilliseconds = 47;
  final AudioCache _audioCache = AudioCache(
    prefix: 'assets/audio/',
    fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP),
  );

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  String remainingTime() {
    final int expectedCompletionInMilliseconds =
        (widget.secondsPerRoll * widget.numberOfRolls).round() * 1000;
    final int remainingTimeInMilliseconds =
        expectedCompletionInMilliseconds - _duration.inMilliseconds;
    final Duration remainingDuration = remainingTimeInMilliseconds >= 0
        ? Duration(milliseconds: remainingTimeInMilliseconds)
        : Duration(milliseconds: remainingTimeInMilliseconds * -1);
    return remainingTimeInMilliseconds >= 0
        ? '-${FormattedTime(remainingDuration).formattedTime()}'
        : '+${FormattedTime(remainingDuration).formattedTime()}';
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
                  const Spacer(flex: 4),
                  FormattedTime(_duration).buildTime(),
                  Text(
                    remainingTime(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    '$_expectedCompletedRolls',
                    style: const TextStyle(fontSize: 64),
                  ),
                  Container(
                      margin: const EdgeInsets.all(25),
                      child: LinearProgressIndicator(
                          value: ((_duration.inMilliseconds %
                                  (widget.secondsPerRoll * 1000))) /
                              (widget.secondsPerRoll * 1000))),
                  const Spacer(
                    flex: 1,
                  ),
                  configFields()
                ])),
                Container(
                  child: buildStopwatchButtons(),
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 30),
                )
              ]),
        ),
      );

  void addTime() {
    setState(() {
      final milliseconds = _duration.inMilliseconds + _intervalInMilliseconds;
      _duration = Duration(milliseconds: milliseconds);
    });

    intervalNotification(widget.secondsPerRoll);
  }

  void intervalNotification(double intervalInSeconds) {
    if (_duration.inSeconds % intervalInSeconds == 0 &&
        _duration.inMilliseconds % 1000 < _intervalInMilliseconds) {
      _expectedCompletedRolls++;
      _audioCache.play('beep.mp3');
    }
  }

  void reset() {
    setState(() {
      _duration = const Duration();
      _expectedCompletedRolls = 0;
    });
  }

  void startTimer({bool resets = true}) {
    setState(() {
      Wakelock.enable();
    });
    if (resets) {
      reset();
    }
    _timer = Timer.periodic(const Duration(milliseconds: 47), (_) => addTime());
  }

  void pauseTimer({bool resets = true}) {
    setState(() {
      Wakelock.disable();
    });
    if (resets) {
      reset();
    }

    setState(() => _timer?.cancel());
  }

  Widget stopTimer() {
    return Expanded(
        flex: 1,
        child: Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
                onPressed: () {
                  pauseTimer(resets: false);
                  Navigator.pushNamed(context, ResultsPage.route,
                          arguments: ResultsArguments(_duration,
                              widget.secondsPerRoll, widget.numberOfRolls))
                      .then((value) {
                    reset();
                  });
                },
                child: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 13, 0, 8),
                    child: Text(
                      'STOP',
                      style: TextStyle(fontSize: 32),
                    )),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red.shade400)))));
  }

  Widget configFields() {
    return Container(
        margin: const EdgeInsets.all(25),
        child: Column(children: <Widget>[
          const Text('SETTINGS', style: TextStyle(color: Colors.grey)),
          Text('Seconds per roll: ${widget.secondsPerRoll.round()}',
              style: const TextStyle(height: 1.5, color: Colors.grey)),
          Text('Number of rolls: ${widget.numberOfRolls.round()}',
              style: const TextStyle(height: 1.5, color: Colors.grey))
        ]));
  }

  Widget buildStopwatchButtons() {
    final isRunning = _timer == null ? false : _timer!.isActive;

    return SizedBox(
        width: double.infinity,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (isRunning) {
                          pauseTimer(resets: false);
                        } else {
                          startTimer(resets: false);
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 13, 0, 8),
                          child: Text(isRunning ? 'PAUSE' : 'RESUME',
                              style: const TextStyle(fontSize: 32)))))),
          isRunning
              ? stopTimer()
              : Expanded(
                  flex: 1,
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          onPressed: pauseTimer,
                          child: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 13, 0, 8),
                              child: Text('RESET',
                                  style: TextStyle(fontSize: 32))),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.grey))))),
        ]));
  }
}
