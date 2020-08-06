import 'dart:async';

import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  int selectedMarked = -1;

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
    });
  }

  void swapMarkers(int a, int b) async {
    Marker last = widget.markers.firstWhere((m) => m.markerId.value == 'point$b');
    Marker selected = widget.markers.firstWhere((m) => m.markerId.value == 'point$a');

    LatLng tmp = widget.waypoints[b - 1];
    widget.waypoints[b - 1] = widget.waypoints[a - 1];
    widget.waypoints[a - 1] = tmp;

    widget.markers.remove(last);
    widget.markers.remove(selected);
    widget.markers.add(await createMarker(widget.waypoints[b - 1], b));
    widget.markers.add(await createMarker(widget.waypoints[a - 1], a));
    setState(() {});
  }

  void removeMarker(int id) async {
    widget.markers.clear();
    widget.waypoints.removeAt(id-1);

    for(int i = 0; i < widget.waypoints.length; i++) {
      widget.markers.add(await createMarker(widget.waypoints[i], i+1));
    }

    setState(() {});
  }

  Future<Marker> createMarker(LatLng loc, int num) async {
    widget.polylines = {};

    BitmapDescriptor icon = await getMarkerIcon(
        num,
        color_dark_button_green,
        color_dark_background,
        70
    );

    Marker m = Marker(
      markerId: MarkerId('point$num'),
      draggable: true,
      anchor: Offset(0.5, 1),
      onDragEnd: (pos) {
        widget.waypoints[num-1] = pos;
        print(widget.waypoints.length);
        widget.polylines.clear();
        setState(() {});
      },
      onTap: () {
        selectedMarked = num;
        showDialog(context: context, builder: swapDialog);
      },
      icon: icon,
      position: loc,
    );

    return m;
  }

  Widget swapDialog(BuildContext context) {
    int num = selectedMarked;
    int start = selectedMarked;

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          backgroundColor: color_dark_background,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Center(
                      child: Text(
                        'Modify',
                        style: textStyleHeader,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: IconButton(
                        icon: Icon(CustomIcons.back, size: 30, color: color_dark_text_highlight),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Order:',
                      style: textStyleDarkLightLarge,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(CustomIcons.down, color: num == 1 ? color_dark_text_dark : color_dark_text_highlight),
                          onPressed: num == 1 ? null : () {
                            setState(() {
                              num--;
                            });
                          },
                        ),
                        Text(
                          '$num',
                          style: textStyleHeader,
                        ),
                        IconButton(
                          icon: Icon(CustomIcons.up, color: num == widget.waypoints.length ? color_dark_text_dark : color_dark_text_highlight),
                          onPressed: num == widget.waypoints.length ? null : () {
                            setState(() {
                              num++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlineButton(
                        onPressed: () {
                          removeMarker(start);
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Text('REMOVE')
                        ),
                        color: color_dark_error,
                        highlightColor: color_dark_error,
                        highlightedBorderColor: color_dark_error,
                        focusColor: color_dark_error,
                        hoverColor: color_dark_error,
                        textColor: color_dark_text_dark,
                        splashColor: color_dark_error,
                        borderSide: BorderSide(color: color_dark_error),
                      ),
                      OutlineButton(
                        onPressed: () {
                          swapMarkers(start, num);
                          Navigator.pop(context);
                        },
                        child: Container(
                            child: Text('CONFIRM'),
                        ),
                        color: color_dark_text_highlight,
                        highlightColor: color_dark_text_highlight,
                        highlightedBorderColor: color_dark_text_highlight,
                        focusColor: color_dark_text_highlight,
                        hoverColor: color_dark_text_highlight,
                        textColor: color_dark_text_dark,
                        splashColor: color_dark_text_highlight,
                        borderSide: BorderSide(color: color_dark_text_highlight),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    void onCreate(GoogleMapController controller) async {
      controller.setMapStyle(widget._mapTheme);
      position = await setupLocation();
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 18)));

    }

    void addWaypoint(LatLng loc) async {
      showMarkes = true;
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
      onTap: addWaypoint,
      polylines: widget.polylines,
      markers: showMarkes ? widget.markers : {},
      padding: EdgeInsets.only(top: 20, bottom: 120),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
