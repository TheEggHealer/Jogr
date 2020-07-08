import 'package:jogr/utils/models/route.dart';

class Run {

  int distance; //Distance in meters
  int time;     //Time in seconds
  int calories;
  int temperature;
  String date;
  Route route;

  Run({ this.date, this.distance, this.time, this.calories, this.route });

  String get distanceString => ((distance/1000 * 10).round().toDouble() / 10).toString();

  String get timeString {
    int hours = (time / 60 / 60).floor();
    int minutes = (time / 60 % 60).floor();
    int seconds = (time % 60);
    return '${hours > 0 ? '$hours:' : ''}${minutes < 10 ? '0$minutes' : minutes.toString()}:${seconds < 10 ? '0$seconds' : seconds.toString()}';
  }

  double get speed {
    return distance / time;
  }


}