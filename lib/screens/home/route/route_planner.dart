import 'dart:collection';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/screens/home/route/map.dart';
import 'package:jogr/screens/home/route/route_panel.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/loading.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RoutePlanner extends StatefulWidget {
  final User user;
  final UserData userData;

  _RoutePlannerState state = _RoutePlannerState();

  RoutePlanner(this.user, this.userData);

  @override
  _RoutePlannerState createState() => state;
}

class _RoutePlannerState extends State<RoutePlanner> {

  Map map = Map();
  double dist = 0;
  Set<Polyline> _polylines = {};

  int totalDistance = 0;
  bool loading = false;

  static final _formKey = GlobalKey<FormState>();

  void generateRoute() async {
    _polylines.clear();
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

      loading = false;
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

  Widget routeWidget(BuildContext context, Route route) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: color_card,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.name,
                    style: textStyleDarkLightLarge,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(
                        '${route.distance}',
                        style: textStyleHeaderSmall,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'm',
                        style: textStyleDark,
                      )
                    ],
                  )
                ],
              ),
              OutlineButton(
                onPressed: () { load(route); Navigator.of(context).pop(); },
                child: Text('LOAD'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                borderSide: BorderSide(color: color_text_highlight),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadDialog(BuildContext context) {
    List<Widget> items = [
      SizedBox(height: 20),
      Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Text(
              'Select route',
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
      TextFormField(

      )
    ]..addAll(widget.userData.routes.map((e) => routeWidget(context, e)).toList());

    widget.userData.routes.forEach((element) {print(element.name);});

    return Dialog(
      backgroundColor: color_background,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ScrollConfiguration(
            behavior: NoScrollGlow(),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    items
                  )
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

  Widget helpDialog(BuildContext context) {
    TextStyle main = TextStyle(
      fontFamily: 'RobotoLight',
      color: Color(0xffaaaaaa),
    );

    TextStyle highlight = TextStyle(
      fontFamily: 'RobotoLight',
      color: color_text_highlight,
    );

    return Dialog (
      backgroundColor: color_background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Center(
                  child: Text(
                    'Help',
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
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: '\tHere you can create and plan routes. To create a route, simply tap on the map to place waypoints. Optimally, these waypoints should be placed whereever you plan to change road. A number is shown on each waypoint. This number signifies the order that you place them and the order in which the route will be created.',
                style: main,
                children: [
                  TextSpan(text: '\n\n\tIf your not happy with a waypoint, tap ', style: main, ),
                  TextSpan(text: 'REMOVE LAST', style: highlight),
                  TextSpan(text: ' to remove the last waypoint you placed. ', style: main, ),
                  TextSpan(text: '\n\n\tAfter you have placed your waypoints, tap the ', style: main, ),
                  TextSpan(text: 'GENERATE ROUTE', style: highlight),
                  TextSpan(text: ' button. This will run an algorithm finding the shortes path between each of your waypoints and connecting the ends. After this is done, you can see the total distance of the route you just created at the bottom of the screen.', style: main),
                  TextSpan(text: '\n\n\tIf you\'re happy with the route, give it a name using the textfield at the bottom, then tap ', style: main, ),
                  TextSpan(text: 'SAVE', style: highlight),
                  TextSpan(text: ' in order to save it. If you have created and saved routes in the past, simply tap ', style: main, ),
                  TextSpan(text: 'LOAD', style: highlight),
                  TextSpan(text: ' and select the route you want to load.', style: main, ),
                  TextSpan(text: '\n\n\tIf you\'re not happy with the route, tap ', style: main, ),
                  TextSpan(text: 'CLEAR', style: highlight),
                  TextSpan(text: ' to clear all the waypoints and start from the beginning.', style: main, ),
                  TextSpan(text: '\n\n\tGood luck!', style: main, ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget saveDialog(BuildContext context) {
    String routeName = '';

    return Dialog(
      backgroundColor: color_background,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Center(
                    child: Text(
                      'Save',
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
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,

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
              SizedBox(height:10),
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
              ),
              SizedBox(height:10),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: OutlineButton(
                  onPressed: () {
                    if(_formKey.currentState.validate()) {
                      save(routeName);
                    }
                  },
                  child: Container(
                    child: Text('SAVE')
                  ),
                  color: color_button_green,
                  highlightColor: color_button_green,
                  highlightedBorderColor: color_button_green,
                  focusColor: color_button_green,
                  hoverColor: color_button_green,
                  textColor: color_text_dark,
                  splashColor: color_button_green,
                  borderSide: BorderSide(color: color_button_green),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void load(Route route) async {
    Set<Marker> markers = {};
    for(int i = 0; i < route.waypoints.length; i++) {
      markers.add(await map.state.createMarker(route.waypoints[i], i+1));
    }

    map.waypoints = route.waypoints;
    map.markers = markers;

    setState(() {
      loading = true;
    });

    generateRoute();
  }

  String checkName(String name) {
    return name.isEmpty ? 'Enter a valid name' : (widget.userData.routes.map((e) => e.name).contains(name) ? 'Route with that name already exists.' : null);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints);
        return SlidingUpPanel(
          renderPanelSheet: false,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
          maxHeight: constraints.maxWidth > 400 ? MediaQuery.of(context).size.height/2.7 : MediaQuery.of(context).size.height/1.7,
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
          panel: constraints.maxWidth > 400 ? WideRoutePanel(widget) : NarrowRoutePanel(widget),
          body: map,
        );
      },
    );
  }
}
