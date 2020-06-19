import 'package:latlong/latlong.dart';

class Route {

  String name;
  List<LatLng> waypoints;
  int distance = 0;
  int timesRan = 0;
  int totalDistanceRan = 0;
  int totalTime = 0;

  Route({ this.name, this.waypoints, this.distance, this.timesRan, this.totalDistanceRan, this.totalTime });

}