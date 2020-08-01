import 'dart:async';

import 'package:flutter/cupertino.dart' hide Route, Path;
import 'package:flutter/material.dart' hide Route, Path;
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:latlong/latlong.dart' as ll;
import 'package:location/location.dart';

class MapWidget extends StatefulWidget {

  Set<Marker> markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> waypoints = [];
  List<List<ll.LatLng>> positions = [];

  bool staticMap = true;
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

  Polyline generatePolyline(List<ll.LatLng> latLongs, String id) {
    if(latLongs.length >= 3) {
      ll.Path path = ll.Path.from(latLongs).equalize(1, smoothPath: true);

      return Polyline(
        polylineId: PolylineId(id),
        color: color_button_green,
        zIndex: 1,
        width: 4,
        points: path.coordinates.map((e) => LatLng(e.latitude, e.longitude)).toList(),
      );
    } else {
      return null;
    }
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

  void generateRoute() async {
    widget._polylines.clear();
    List<LatLng> routeCoordinates = [];
    PolylinePoints _polylinePoints = PolylinePoints();

    if(widget.waypoints.length > 1) {
      routeCoordinates.clear();

      //TODO: Use PolyWayPoint to speed up route generation

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

  Future<Marker> createMarker(LatLng loc, int num) async {
    widget._polylines = {};

    BitmapDescriptor icon = await getMarkerIcon(
        num,
        color_button_green,
        color_background,
        70
    );

    Marker m = Marker(
      markerId: MarkerId('point$num'),
      draggable: !widget.staticMap,
      anchor: Offset(0.5, 1),
      onDragEnd: widget.staticMap ? (){} : (pos) {
        widget.waypoints[num-1] = pos;
        print(widget.waypoints.length);
        widget._polylines.clear();
        setState(() {});
      },
      onTap: widget.staticMap ? (){} : () {
        selectedMarked = num;
        showDialog(context: context, builder: swapDialog);
      },
      icon: icon,
      position: loc,
    );

    return m;
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

  Widget swapDialog(BuildContext context) {
    int num = selectedMarked;
    int start = selectedMarked;

    return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: color_background,
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
                          icon: Icon(CustomIcons.back, size: 30, color: color_text_highlight),
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
                            icon: Icon(CustomIcons.down, color: num == 1 ? color_text_dark : color_text_highlight),
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
                            icon: Icon(CustomIcons.up, color: num == widget.waypoints.length ? color_text_dark : color_text_highlight),
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
                          color: color_error,
                          highlightColor: color_error,
                          highlightedBorderColor: color_error,
                          focusColor: color_error,
                          hoverColor: color_error,
                          textColor: color_text_dark,
                          splashColor: color_error,
                          borderSide: BorderSide(color: color_error),
                        ),
                        OutlineButton(
                          onPressed: () {
                            swapMarkers(start, num);
                            Navigator.pop(context);
                          },
                          child: Container(
                            child: Text('CONFIRM'),
                          ),
                          color: color_text_highlight,
                          highlightColor: color_text_highlight,
                          highlightedBorderColor: color_text_highlight,
                          focusColor: color_text_highlight,
                          hoverColor: color_text_highlight,
                          textColor: color_text_dark,
                          splashColor: color_text_highlight,
                          borderSide: BorderSide(color: color_text_highlight),
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
        if(widget.positions[i].length >= 2) widget._polylines.add(widget.generatePolyline(widget.positions[i], 'path$i'));
      }
      position = await setupLocation();
      controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 18)));
    }

    void addWaypoint(LatLng loc) async {
      //showMarkes = true;
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
      onTap: widget.staticMap ? (pos) {} : addWaypoint,
      markers: widget.showMarkers ? widget.markers : {},
      polylines: widget.showRoute ? widget._polylines : widget._polylines.where((element) => element.zIndex == 1).toSet(),
      padding: EdgeInsets.only(top: 20, bottom: 90),
      zoomControlsEnabled: false,
      mapType: MapType.normal,
    );
  }
}
