import 'package:flutter/material.dart';
import 'package:sushi_stopwatch/main.dart';
import 'package:sushi_stopwatch/page/home_page.dart';
import 'package:sushi_stopwatch/page/results_page.dart';
import 'package:sushi_stopwatch/page/stopwatch_page.dart';

class ResultsArguments {
  final Duration duration;
  final double numberOfRolls;

  ResultsArguments(this.duration, this.numberOfRolls);
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    ResultsArguments? args;
    if (settings.arguments != null) {
      args = settings.arguments as ResultsArguments;
    }

    switch (settings.name) {
      case HomePage.route:
        return MaterialPageRoute(builder: (context) => const HomePage());
      case StopWatchPage.route:
        return MaterialPageRoute(builder: (context) => const StopWatchPage());
      case ResultsPage.route:
        return MaterialPageRoute(
            builder: (context) =>
                ResultsPage(args!.duration, args.numberOfRolls));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          body: Center(child: Text('Oops, the page does not exist.')));
    });
  }
}
