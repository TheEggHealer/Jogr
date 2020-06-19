import 'dart:collection';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/screens/home/route/map.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/loading.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RoutePlanner extends StatefulWidget {
  final User user;
  final UserData userData;

  RoutePlanner(this.user, this.userData);

  @override
  _RoutePlannerState createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {

  Map map = Map();
  double dist = 0;
  Set<Polyline> _polylines = {};

  int totalDistance = 0;

  void generateRoute() async {
    List<LatLng> routeCoordinates = [];
    List<LatLng> waypoints = map.waypoints;
    PolylinePoints _polylinePoints = PolylinePoints();
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

    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId('Route'),
          color: color_text_highlight,
          width: 4,
          points: routeCoordinates
      );

      _polylines.add(polyline);

      map.state.setState(() {
        map.polylines = _polylines;
      });

      this.totalDistance = totalDistance;
    });
  }

  void clearRoute() {
    setState(() {
      this.totalDistance = 0;
      map.state.setState(() {
        map.polylines = {};
        map.markers = {};
        map.waypoints = [];
      });
    });
  }

  void removeLast() {
    if(map.markers.isNotEmpty) {
      setState(() {
        map.state.setState(() {
          map.polylines = {};
          map.markers.removeWhere((element) =>
          element.markerId.value == 'point${map.markers.length}');
          map.waypoints.removeLast();
        });
      });
    }
  }

  void save(String routeName) async {
    DatabaseService db = DatabaseService(uid: widget.user.uid);

    await db.mergeUserDataFields({
      'saved_routes': widget.userData.raw['saved_routes'].putIfAbsent('', () => {
        routeName: {
          'distance': totalDistance.toString(),
          'timesRan': '0',
          'totalDistanceRan': '0',
          'totalTime': '0',
        }..addAll(map.waypoints.asMap().map((key, value) => MapEntry(key.toString(), '${value.latitude}&${value.longitude}')))
      })
    });
  }

  String checkName(String name) {
    return name.isEmpty ? 'Enter a valid name' : (widget.userData.routes.map((e) => e.name).contains(name) ? 'Route with that name already exists.' : null);
  }

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    String routeName = '';

    return SlidingUpPanel(
      renderPanelSheet: false,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
      maxHeight: MediaQuery.of(context).size.height/2.1, //2.7
      minHeight: 70,

      collapsed: Container(
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: color_background,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.drag_handle,
              size: 30,
              color: color_text_dark
            ),
            Text(
              'Route planner',
              style: textStyleHeaderSmall,
            ),
          ],
        )
      ),
      panel: Container(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: color_background,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black,
            ),
          ]
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Add waypoints to the map',
                  style: textStyleHeaderSmall,
                ),
              ),
              Divider(
                color: Color(0xff555555),
                endIndent: 20,
                indent: 20,
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    onPressed: () {print('help');},
                    child: Text('HELP'),
                    color: color_text_highlight,
                    highlightColor: color_text_highlight,
                    highlightedBorderColor: color_text_highlight,
                    focusColor: color_text_highlight,
                    hoverColor: color_text_highlight,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_text_highlight),
                  ),
                  OutlineButton(
                    onPressed: () { generateRoute(); },
                    child: Text('GENERATE ROUTE'),
                    color: color_text_highlight,
                    highlightColor: color_text_highlight,
                    highlightedBorderColor: color_text_highlight,
                    focusColor: color_text_highlight,
                    hoverColor: color_text_highlight,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_text_highlight),
                  ),
                  OutlineButton(
                    onPressed: () { clearRoute(); },
                    child: Text('CLEAR'),
                    color: color_error,
                    highlightColor: color_error,
                    highlightedBorderColor: color_error,
                    focusColor: color_error,
                    hoverColor: color_error,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_error),
                  ),

                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlineButton(
                    onPressed: () { removeLast(); },
                    child: Text('REMOVE LAST'),
                    color: color_text_highlight,
                    highlightColor: color_text_highlight,
                    highlightedBorderColor: color_text_highlight,
                    focusColor: color_text_highlight,
                    hoverColor: color_text_highlight,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_text_highlight),
                  ),
                  OutlineButton(
                    onPressed: () { },
                    child: Text('LOAD'),
                    color: color_text_highlight,
                    highlightColor: color_text_highlight,
                    highlightedBorderColor: color_text_highlight,
                    focusColor: color_text_highlight,
                    hoverColor: color_text_highlight,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_text_highlight),
                  ),
                  OutlineButton(
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        save(routeName);
                      }
                    },
                    child: Text('SAVE'),
                    color: color_button_green,
                    highlightColor: color_button_green,
                    highlightedBorderColor: color_button_green,
                    focusColor: color_button_green,
                    hoverColor: color_button_green,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_button_green),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Distance:',
                        style: textStyleDarkLightLarge,
                      ),
                      SizedBox(width: 15,),
                      Text(
                        '$totalDistance',
                        style: textStyleHeader,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'm',
                        style: textStyleDark,
                      )
                    ],
                  ),
                  Positioned(
                    right: 30,
                    child: Loading(),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                validator: checkName,
                cursorColor: color_text_highlight,
                onChanged: (val) {
                  routeName = val;
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_text_dark)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_text_highlight)),
                  border: OutlineInputBorder(borderSide: BorderSide(color: color_text_dark)),
                  hintText: 'Name your route',
                  hintStyle: TextStyle(
                    fontFamily: 'RobotoLight',
                    color: Color(0x1fffffff)
                  )
                ),
                style: textStyleDarkLight,
              )
            ],
          ),
        ),
      ),
      body: map,
    );
  }
}
