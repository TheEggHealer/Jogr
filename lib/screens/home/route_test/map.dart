import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/utils/constants.dart';
import 'package:latlong/latlong.dart' as ll;
import 'package:location/location.dart';

class Map extends StatefulWidget {
  List<LocationDto> positions = [];

  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  Completer<GoogleMapController> _controller = Completer();
  static const String _isolateName = "JogrIsolator";
  ReceivePort port = ReceivePort();
  LatLng position = LatLng(0, 0);
  static const int stepSize = 7;

  List<LatLng> waypoints = [];
  PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> routeCoordinates = [];
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) {
      print('Data: $data');

      ll.Distance distance = ll.Distance();


      if (widget.positions.length > 0 && distance.as(ll.LengthUnit.Meter, ll.LatLng(data.latitude, data.longitude), ll.LatLng(widget.positions.last.latitude, widget.positions.last.longitude)) >= stepSize) {
        setState(() {
          widget.positions.add(data);
        });
      } else if(widget.positions.isEmpty) {

        setState(() {
          widget.positions.add(data);
        });
      }
    });
    initPlatformState();
  }

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

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  static void callback(LocationDto loc) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(loc);
  }

  void startLocationService(){
    BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
        //Scroll down to see the different options
          notificationTitle: "Start Location Tracking",
          notificationMsg: "Track location in background",
          wakeLockTime: 20,
          autoStop: false,
          interval: 5
      ),
    );
  }

  Set<Marker> latLongsToMakers(List<LocationDto> latLongs) {
    return latLongs.map((e) => Marker(
      markerId: MarkerId(e.longitude.toString()),
      position: LatLng(e.latitude, e.longitude),
    )).toSet();
  }

  Set<Polyline> latLongsToPolylines(List<LocationDto> latLongs) {
    if(latLongs.length >= 3) {
      ll.Path path = ll.Path.from(
          latLongs.map((e) => ll.LatLng(e.latitude, e.longitude))).equalize(
          stepSize, smoothPath: true);
      return {Polyline(
        polylineId: PolylineId('path'),
        points: path.coordinates.map((e) => LatLng(e.latitude, e.longitude))
            .toList(),
      )};
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {

    void onCreate(GoogleMapController controller) async {
      _controller.complete(controller);
      position = await setupLocation();
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 18)));
    }

    void addWaypoint(LatLng loc) async {
      waypoints.add(loc);

      int totalDistance = 0;

      if(waypoints.length > 1) {
        routeCoordinates.clear();
        for(int i = 0; i < waypoints.length - 1; i++) {
          PolylineResult result = await _polylinePoints?.getRouteBetweenCoordinates(
              "AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4",
              PointLatLng(waypoints[i].latitude, waypoints[i].longitude),
              PointLatLng(waypoints[i+1].latitude, waypoints[i+1].longitude),
              travelMode: TravelMode.walking
          );
          List<PointLatLng> points = result.points;

          if(points.isNotEmpty) {
            for(int i = 0; i < points.length; i++) {
              routeCoordinates.add(LatLng(points[i].latitude, points[i].longitude));
            }

            Dio dio = Dio();
            Response response = await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${waypoints[i].latitude},${waypoints[i].longitude}&destinations=${waypoints[i+1].latitude},${waypoints[i+1].longitude}&mode=walking&key=AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4");
            totalDistance += int.parse(response.data.toString().split('distance: ')[1].split('value: ')[1].split('}')[0]);
          }
        }

        if(waypoints.length > 2) {
          PolylineResult result = await _polylinePoints
              ?.getRouteBetweenCoordinates(
              "AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4",
              PointLatLng(waypoints.last.latitude, waypoints.last.longitude),
              PointLatLng(waypoints.first.latitude, waypoints.first.longitude),
              travelMode: TravelMode.walking
          );
          List<PointLatLng> points = result.points;

          if (points.isNotEmpty) {
            for (int i = 0; i < points.length; i++) {
              routeCoordinates.add(
                  LatLng(points[i].latitude, points[i].longitude));
            }
          }

          Dio dio = Dio();
          Response response = await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${waypoints.last.latitude},${waypoints.last.longitude}&destinations=${waypoints.first.latitude},${waypoints.first.longitude}&mode=walking&key=AIzaSyDROcsS2YsgIGqjz8TOSIPbK9QFj9oo7s4");
          totalDistance += int.parse(response.data.toString().split('distance: ')[1].split('value: ')[1].split('}')[0]);
        }
      }

      print(totalDistance);

      setState(() {
        Polyline polyline = Polyline(
            polylineId: PolylineId('Route'),
            color: Color.fromARGB(255, 40, 122, 198),
            width: 4,
            points: routeCoordinates
        );

        _polylines.add(polyline);

        _markers.add(Marker(
          markerId: MarkerId('point${loc.longitude}'),
          position: loc,
          onTap: () {
            setState(() {
              _markers.remove(_markers.firstWhere((Marker marker) => marker.markerId.value == 'point${loc.longitude}'));
            });
          },
        ));
      });
    }

    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: position, zoom: 18),
            myLocationEnabled: true,
            buildingsEnabled: true,
            mapType: MapType.hybrid,
            onMapCreated: onCreate,
            onTap: addWaypoint,
            polylines: _polylines,
            markers: _markers,
          ),
          Center(
            child: OutlineButton(
              onPressed: () {startLocationService();},
              child: Text('START'),
              color: color_text_highlight,
              highlightColor: color_text_highlight,
              highlightedBorderColor: color_text_highlight,
              focusColor: color_text_highlight,
              hoverColor: color_text_highlight,
              textColor: color_text_dark,
              borderSide: BorderSide(color: color_text_highlight),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  'Lates point: ${widget.positions.length > 0 ? widget.positions.last : 0}',
                  style: TextStyle(
                    color: color_background,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Amount of points: ${widget.positions.length}',
                style: TextStyle(
                  color: color_background,
                  fontSize: 12,
                ),
              )
            ],
          ),

        ]
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
