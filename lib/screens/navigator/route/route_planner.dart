import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/screens/navigator/route/map.dart';
import 'package:jogr/screens/navigator/route/route_panel.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/loading.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../run/map_widget.dart';

class RoutePlanner extends StatefulWidget {
  final User user;
  final MapWidget map = MapWidget();

  RoutePlanner(this.user);

  @override
  RoutePlannerState createState() => RoutePlannerState();
}

class RoutePlannerState extends State<RoutePlanner> with SingleTickerProviderStateMixin {

  Map map;
  double dist = 0;
  Set<Polyline> _polylines = {};

  UserData userData;

  int totalDistance = 0;
  bool loading = false;

  bool setting_connectEnds = true;
  bool setting_forceToRoad = true;

  AnimationController controller;
  PageController pageController = PageController(initialPage: 0);

  static final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    map = Map(this);

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void generateRoute(UserPreferences prefs) async {
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
          color: prefs.color_error,
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
      if(controller.status == AnimationStatus.completed) controller.reverse();
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
      'saved_routes': userData.raw['saved_routes'].putIfAbsent('', () => {
        routeName: {
          'distance': totalDistance.toString(),
          'timesRan': '0',
          'totalDistanceRan': '0',
          'totalTime': '0',
        }..addAll(map.waypoints.asMap().map((key, value) => MapEntry(key.toString(), '${value.latitude}&${value.longitude}')))
      })
    });
  }

  Widget routeWidget(BuildContext context, Route route, UserPreferences prefs) {
    return CustomCard(
      userData: userData,
      onTap: null,
      paddingFactor: 4,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: route.name,
                      style: prefs.text_background,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    textBaseline: TextBaseline.ideographic,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    children: [
                      Text(
                        route.distance.toString(),
                        style: prefs.text_goal,
                      ),
                      Text(
                        'm',
                        style: prefs.text_label,
                      )
                    ],
                  ),
                ],
              ),
            ),
            Spacer(flex: 1,),
            Expanded(
              flex: 4,
              child: button(
                text: 'Load',
                  textColor: prefs.color_text_background,
                  splashColor: prefs.color_splash,
                  borderColor: prefs.color_highlight,
                onTap: () { load(route); Navigator.of(context).pop(); }
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget loadDialog(BuildContext context) {
    UserPreferences prefs = UserPreferences(userData.lightMode);
    List<Widget> items = [
      SizedBox(height: 20),
      Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Text(
              'Select route',
              style: prefs.text_header,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(CustomIcons.back, size: 30, color: prefs.color_main),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      SizedBox(height: 20),
    ]..addAll(this.userData.routes.map((e) => routeWidget(context, e, prefs)).toList());

    return Dialog(
      backgroundColor: prefs.color_background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
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
      color: color_dark_text_highlight,
    );

    return Dialog (
      backgroundColor: color_dark_background,
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
                    icon: Icon(CustomIcons.back, size: 30, color: color_dark_text_highlight),
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
    UserPreferences prefs = UserPreferences(userData.lightMode);

    return Dialog(
      backgroundColor: prefs.color_background,
      child: Padding(
        padding: const EdgeInsets.all(10),
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
                      style: prefs.text_header,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: Icon(CustomIcons.back, size: 30, color: prefs.color_main),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              textField(
                validator: checkName,
                onChanged: (val) {
                  setState(() {
                    routeName = val;
                  });
                },
                textColor: prefs.color_text_header,
                activeColor: prefs.color_main,
                borderColor: prefs.color_shadow,
                errorColor: prefs.color_error,
                helperText: 'Name your route',
                icon: Icon(CustomIcons.save, color: prefs.color_shadow),
                textStyle: prefs.text_header_2,
                borderRadius: 30
              ),
              /**
              TextFormField(
                validator: checkName,
                cursorColor: prefs.color_text_header,
                onChanged: (val) {
                  setState(() {
                    routeName = val;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(color: prefs.color_shadow)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(color: prefs.color_main)),
                  errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(color: prefs.color_error)),
                  focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)),borderSide: BorderSide(color: prefs.color_error)),
                  errorStyle: TextStyle(
                      fontFamily: 'RobotoLight',
                      color: prefs.color_error
                  ),
                  border: OutlineInputBorder(borderSide: BorderSide(color: prefs.color_shadow)),
                  hintText: 'Name your route',
                  hintStyle: TextStyle(
                      fontFamily: 'RobotoLight',
                      color: prefs.color_shadow
                  ),
                  prefixIcon: Icon(CustomIcons.save, color: prefs.color_shadow),
                  focusColor: prefs.color_main,
                  hoverColor: prefs.color_main,
                ),
                style: prefs.text_header_2,
              ),
              */
              SizedBox(height:10),
              button(
                onTap: () {
                  if(_formKey.currentState.validate()) {
                    save(routeName);
                    Navigator.pop(context);
                  }
                },
                text: 'Save',
                textColor: prefs.color_text_header,
                borderColor: prefs.color_main,
                borderRadius: 30
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
      controller.forward();
    });

    generateRoute(UserPreferences(userData.lightMode));
  }

  String checkName(String name) {
    return name.isEmpty ? 'Enter a valid name' : (userData.routes.map((e) => e.name).contains(name) ? 'Route with that name already exists.' : null);
  }

  @override
  Widget build(BuildContext context) {

    this.userData = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences(userData.lightMode);

    return LayoutBuilder(
      builder: (context, box) {
        print('Panel: $box');

        double cardHeight = box.maxHeight / 3.2;
        double minHeight = 70;

        return Stack(
          children: [
            SlidingUpPanel(
              parallaxEnabled: true,
              parallaxOffset: 0.4,
              renderPanelSheet: false,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
              maxHeight: cardHeight + minHeight + 30,
              minHeight: minHeight,

              collapsed: Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: prefs.color_background,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                          Icons.remove,
                          size: 30,
                          color: prefs.color_shadow
                      ),
                      Text(
                        'Route Planner',
                        style: prefs.text_header,
                      ),
                    ],
                  )
              ),
              panel: Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: prefs.color_background,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8.0,
                        color: prefs.color_shadow,
                      ),
                    ]
                ),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                        Icons.remove,
                        size: 30,
                        color: prefs.color_shadow
                    ),
                    Text(
                      'Route Planner',
                      style: prefs.text_header,
                    ),
                    Divider(
                      color: prefs.color_shadow,
                    ),
                    Container(
                      height: cardHeight,
                      child: PageView(
                        controller: pageController,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 14, left: 5, right: 5),
                            child: Center(
                              child: CustomCard(
                                userData: userData,
                                paddingFactor: 1,
                                child: Container(
                                  width: box.maxWidth * 0.7,
                                  height: cardHeight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          width: double.infinity,
                                          child: button(
                                              text: 'Done',
                                              textColor: prefs.color_text_background,
                                              splashColor: prefs.color_splash,
                                              borderColor: prefs.color_highlight,
                                              onTap: () {
                                                setState(() {
                                                  controller.forward();
                                                  loading = true;
                                                });
                                                generateRoute(prefs);
                                              }
                                          )
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 10,
                                              child: button(
                                                  text: 'Help',
                                                  textColor: prefs.color_text_background,
                                                  splashColor: prefs.color_splash,
                                                  borderColor: prefs.color_highlight,
                                                  onTap: () => showDialog(context: context, builder: helpDialog)
                                              )
                                          ),
                                          Spacer(flex: 1),
                                          Expanded(
                                              flex: 10,
                                              child: button(
                                                  text: 'Clear',
                                                  textColor: prefs.color_text_background,
                                                  splashColor: prefs.color_splash,
                                                  borderColor: prefs.color_highlight,
                                                  onTap: () => clearRoute()
                                              )
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 10,
                                              child: button(
                                                  text: 'Load',
                                                  textColor: prefs.color_text_background,
                                                  splashColor: prefs.color_splash,
                                                  borderColor: prefs.color_highlight,
                                                  onTap: () => showDialog(context: context, builder: loadDialog)
                                              )
                                          ),
                                          Spacer(flex: 1),
                                          Expanded(
                                              flex: 10,
                                              child: button(
                                                  text: 'Save',
                                                  textColor: prefs.color_text_background,
                                                  splashColor: prefs.color_splash,
                                                  borderColor: prefs.color_highlight,
                                                  onTap: () => showDialog(context: context, builder: saveDialog)
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 14, left: 5, right: 5),
                            child: Center(
                              child: CustomCard(
                                userData: userData,
                                paddingFactor: 1,
                                child: Container(
                                  width: box.maxWidth * 0.7,
                                  height: cardHeight,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Connect ends',
                                            style: prefs.text_background,
                                          ),
                                          Switch(
                                            value: setting_connectEnds,
                                            activeColor: prefs.color_highlight,
                                            inactiveThumbColor: prefs.color_text_header,
                                            inactiveTrackColor: prefs.color_shadow,
                                            onChanged: (val) {
                                              notImplemented();
                                              setState(() {
                                                setting_connectEnds = !setting_connectEnds;
                                              });
                                            },
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Follow roads',
                                            style: prefs.text_background,
                                          ),
                                          Switch(
                                            value: setting_forceToRoad,
                                            activeColor: prefs.color_highlight,
                                            inactiveThumbColor: prefs.color_text_header,
                                            inactiveTrackColor: prefs.color_shadow,
                                            onChanged: (val) {
                                              notImplemented();
                                              setState(() {
                                                setting_forceToRoad = !setting_forceToRoad;
                                              });
                                            },
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          )
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Show markers',
                                            style: prefs.text_background,
                                          ),
                                          Switch(
                                            value: map.state.showMarkes,
                                            activeColor: prefs.color_highlight,
                                            inactiveThumbColor: prefs.color_text_header,
                                            inactiveTrackColor: prefs.color_shadow,
                                            onChanged: (val) {
                                              setState(() {
                                                map.state.setState(() {
                                                  map.state.showMarkes = val;
                                                });
                                              });
                                            },
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: pageController,
                      effect: WormEffect(
                        radius: 4,
                        spacing: 4,
                        strokeWidth: 1,
                        dotHeight: 8,
                        dotWidth: 8,
                        activeDotColor: prefs.color_main,
                        dotColor: prefs.color_text_header,
                      ),
                      count: 2,
                    )
                  ],
                ),
              ),
              //panel: constraints.maxWidth > 400 ? WideRoutePanel(this, userData) : NarrowRoutePanel(this),
              body: map,
            ),
            Center(
              heightFactor: 0,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, -1),
                  end: Offset(0, 1),
                ).animate(CurvedAnimation(
                  parent: controller,
                  curve: Curves.ease,
                )),
                child: CustomCard(
                  userData: userData,
                  child: Container(
                    width: box.maxWidth / 3,
                    height: 40,
                    child: AnimatedCrossFade(
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      firstChild: Center(
                        child: SpinKitChasingDots(
                          color: prefs.color_shadow,
                          size: 20,
                        ),
                      ),
                      secondChild: Center(
                        child: DataDisplay(
                          prefs: prefs,
                          data: totalDistance.toString(),
                          label: 'm',
                        ),
                      ),
                      alignment: Alignment.center,
                      crossFadeState: loading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    )
                  )
                ),
              ),
            ),
          ]
        );
      },
    );
  }
}
