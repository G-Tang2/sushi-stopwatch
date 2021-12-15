import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/page/home_page.dart';
import 'package:sushi_stopwatch/page/results_page.dart';
import 'package:sushi_stopwatch/page/stopwatch_page.dart';

class ResultsArguments {
  final Duration duration;
  final double secondsPerRoll;
  final double numberOfRolls;

  ResultsArguments(this.duration, this.secondsPerRoll, this.numberOfRolls);
}

class StopwatchArguments {
  final double secondsPerRoll;
  final double numberOfRolls;

  StopwatchArguments(this.secondsPerRoll, this.numberOfRolls);
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: prefer_typing_uninitialized_variables
    var args;

    switch (settings.name) {
      case HomePage.route:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case StopWatchPage.route:
        if (settings.arguments is StopwatchArguments) {
          args = settings.arguments as StopwatchArguments;
          return MaterialPageRoute(
              builder: (context) =>
                  StopWatchPage(args.secondsPerRoll, args.numberOfRolls));
        } else {
          return _errorRoute();
        }
      case ResultsPage.route:
        if (settings.arguments is ResultsArguments) {
          args = settings.arguments as ResultsArguments;
          return MaterialPageRoute(
              builder: (context) => ResultsPage(
                  args.duration, args.secondsPerRoll, args.numberOfRolls));
        } else {
          return _errorRoute();
        }
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
          body: Center(child: Text('Oops, the page does not exist.')));
    });
  }
}
