import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreatePath {

  LatLng source, destination;
  Set<Polyline> polyline = {};
  List<LatLng> coordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String apiKey = "AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4";

}