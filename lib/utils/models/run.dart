import 'package:intl/intl.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run_log.dart';
import 'package:jogr/utils/models/userdata.dart';

class Run {

  int distance; //Distance in meters
  int time; //Time in seconds
  int pace; //Pace in seconds / km
  int calories;
  int temperature;
  String date;
  Route route;

  Run({ this.date, this.distance, this.time, this.calories, this.route }) {
    pace = time != null && distance != null ? (time / (distance / 1000)).round() : 0;
  }

  static Run from(RunLog log, Route route, UserData userData) {
    int distance = log.distance.round();
    int time = ((DateTime.now().millisecondsSinceEpoch - log.startTime) / 1000).round();
    int calories = (0.0175 * 7 * userData.weight * (time / 60)).round();                                    //TODO: Improve calories calculation
    String date = DateFormat('yyMMdd').format(DateTime.now());

    print(log.startTime);

    return Run(
      date: date,
      distance: distance,
      time: time,
      calories: calories,
      route: route,
    );
  }

  String get distanceString => ((distance/1000 * 10).round().toDouble() / 10).toString();

  String get timeString {
    int hours = (time / 60 / 60).floor();
    int minutes = (time / 60 % 60).floor();
    int seconds = (time % 60);
    return '${hours > 0 ? '$hours:' : ''}${minutes < 10 ? '0$minutes' : minutes.toString()}:${seconds < 10 ? '0$seconds' : seconds.toString()}';
  }

  String get paceString {
    int hours = (pace / 60 / 60).floor();
    int minutes = (pace / 60 % 60).floor();
    int seconds = (pace % 60);
    return '${hours > 0 ? '$hours:' : ''}${minutes < 10 ? '0$minutes' : minutes.toString()}:${seconds < 10 ? '0$seconds' : seconds.toString()}';
  }

  double get speed {
    return distance / time;
  }


}