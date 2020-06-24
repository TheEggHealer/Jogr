import 'dart:async';

import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart' show rootBundle;

class Map extends StatefulWidget {
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  List<LatLng> waypoints = [];
  String _mapTheme = "";

  _MapState state = _MapState();


  @override
  _MapState createState() => state;
}

class _MapState extends State<Map> {

  LatLng position = LatLng(0, 0);
  bool showMarkes = true;


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

  @override
  void initState() {
    super.initState();
    rootBundle.loadString('assets/map_theme.json').then((string) {
      widget._mapTheme = string;
      print(string);
    });
  }

  //Bitmap icon for markers
  Future<BitmapDescriptor> getMarkerIcon(int clusterSize, Color clusterColor, Color textColor, int width) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = clusterColor;
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double radius = width / 2;

    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );

    final image = await pictureRecorder.endRecording().toImage(
      radius.toInt() * 2,
      radius.toInt() * 2,
    );

    final data = await image.toByteData(format: ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<Marker> createMarker(LatLng loc, int num) async {
    widget.polylines = {};

    BitmapDescriptor icon = await getMarkerIcon(
        num,
        color_button_green,
        color_text_dark,
        70
    );

    Marker m = Marker(
      markerId: MarkerId('point$num'),
      infoWindow: InfoWindow(
          title: 'title',
          snippet: 'snippet'
      ),
      icon: icon,
      position: loc,
    );

    return m;
  }

  @override
  Widget build(BuildContext context) {

    void onCreate(GoogleMapController controller) async {
      controller.setMapStyle(widget._mapTheme);
      position = await setupLocation();
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 18)));

    }

    void addWaypoint(LatLng loc) async {
      widget.waypoints.add(loc);
      Marker m = await createMarker(loc, widget.waypoints.length);

      setState(() {
        widget.markers.add(m);
      });
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: position, zoom: 18),
      myLocationEnabled: true,
      buildingsEnabled: true,
      onMapCreated: onCreate,
      onCameraMove: (pos) {
        setState(() {
          showMarkes = pos.zoom > 14;
        });
      },
      onTap: addWaypoint,
      polylines: widget.polylines,
      markers: showMarkes ? widget.markers : {},
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
