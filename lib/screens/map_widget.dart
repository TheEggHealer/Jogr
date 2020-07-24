import 'dart:async';

import 'package:flutter/cupertino.dart' hide Route, Path;
import 'package:flutter/material.dart' hide Route, Path;
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:latlong/latlong.dart' as ll;
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {

  Set<Marker> markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> waypoints = [];
  List<List<ll.LatLng>> positions = [];

  bool showMarkers = true;
  bool showRoute = true;

  void setupRoute(Route route) async {
    waypoints.clear();
    waypoints.addAll(route.waypoints);
    int index = 1;
    route.waypoints.forEach((element) async {
      Marker m = await createMarker(LatLng(element.latitude, element.longitude), index++);
      markers.add(m);
    });
  }

  Future<Marker> createMarker(LatLng loc, int num) async {
    BitmapDescriptor icon = await getMarkerIcon(
        num,
        color_button_green,
        color_background,
        70
    );

    Marker m = Marker(
      markerId: MarkerId('point$num'),
      anchor: Offset(0.5, 1),
      icon: icon,
      position: loc,
    );

    return m;
  }

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  LatLng position = LatLng(0, 0);
  Completer<GoogleMapController> _controller = Completer();
  String _mapTheme = '';

  Future<LatLng> setupLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permission;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if(!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if(!_serviceEnabled) print('Service is not enabled!');
    }

    _permission = await location.hasPermission();
    if(_permission == PermissionStatus.denied) {
      _permission = await location.requestPermission();
      if(_permission == PermissionStatus.denied) print('PEMISSION DENIED, CANNOT USE GPS!');
    }

    _locationData = await location.getLocation();

    return LatLng(_locationData.latitude, _locationData.longitude);
  }

  void generateRoute() async {
    widget._polylines.clear();
    List<LatLng> routeCoordinates = [];
    PolylinePoints _polylinePoints = PolylinePoints();

    if(widget.waypoints.length > 1) {
      routeCoordinates.clear();
      for(int i = 0; i < widget.waypoints.length - 1; i++) {
        PolylineResult result = await _polylinePoints?.getRouteBetweenCoordinates(
            "AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4",
            PointLatLng(widget.waypoints[i].latitude, widget.waypoints[i].longitude),
            PointLatLng(widget.waypoints[i+1].latitude, widget.waypoints[i+1].longitude),
            travelMode: TravelMode.walking
        );
        List<PointLatLng> points = result.points;

        if(points.isNotEmpty) {
          for(int i = 0; i < points.length; i++) {
            routeCoordinates.add(LatLng(points[i].latitude, points[i].longitude));
          }
        }
      }

      if(widget.waypoints.length > 2) {
        PolylineResult result = await _polylinePoints
            ?.getRouteBetweenCoordinates(
            "AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4",
            PointLatLng(widget.waypoints.last.latitude, widget.waypoints.last.longitude),
            PointLatLng(widget.waypoints.first.latitude, widget.waypoints.first.longitude),
            travelMode: TravelMode.walking
        );
        List<PointLatLng> points = result.points;

        if (points.isNotEmpty) {
          for (int i = 0; i < points.length; i++) {
            routeCoordinates.add(
                LatLng(points[i].latitude, points[i].longitude));
          }
        }
      }
    }

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('Route'),
          color: color_text_highlight,
          width: 4,
          points: routeCoordinates
      );

      setState(() {
        widget._polylines.add(polyline);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    rootBundle.loadString('assets/map_theme.json').then((string) {
      _mapTheme = string;
    });
  }

  @override
  Widget build(BuildContext context) {

    void onCreate(GoogleMapController controller) async {
      controller.setMapStyle(_mapTheme);
      _controller.complete(controller);
      generateRoute();
      for(int i = 0; i < widget.positions.length; i++) {
        //if(widget.positions[i].length >= 2) widget._polylines.add(generateRan(widget.positions[i]));
      }
      position = await setupLocation();
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 18)));
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: position, zoom: 18),
      myLocationEnabled: true,
      buildingsEnabled: true,
      onMapCreated: onCreate,
      markers: widget.showMarkers ? widget.markers : {},
      polylines: widget.showRoute ? widget._polylines : widget._polylines.where((element) => element.zIndex == 1).toSet(),
    );
  }
}
