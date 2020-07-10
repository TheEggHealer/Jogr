import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/location_dto.dart';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;
import 'package:jogr/screens/home/home_component.dart';
import 'package:jogr/screens/run/location_tracker.dart';
import 'package:jogr/screens/run/map_dialog.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:latlong/latlong.dart';

class RunBegin extends StatefulWidget {

  final UserData _userData;

  RunBegin(this._userData);

  @override
  _RunBeginState createState() => _RunBeginState(_userData);
}

class _RunBeginState extends State<RunBegin> with SingleTickerProviderStateMixin {

  UserData userData;
  Route selectedRoute;
  AnimationController _play_pause;
  bool running = false;
  String timeString = '00:00:00';
  Stopwatch stopwatch = Stopwatch();
  Timer timer;

  MapDialog map = MapDialog();
  LocationTracker tracker;

  _RunBeginState(this.userData) {
    selectedRoute = userData.routes.isNotEmpty ? (userData.lastRoute != null ? userData.lastRoute : userData.routes[0]) : null;
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
                onPressed: () {
                  setState(() {
                    selectedRoute = route;
                  });
                  Navigator.of(context).pop();
                },
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

  Widget pickRouteDialog(BuildContext context) {
    List<Widget> items = [
      SizedBox(height: 20),
      Stack(
        alignment: Alignment.centerLeft,
        children: [
          Center(
            child: Text(
              'Pick route',
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
    ]..addAll(userData.routes.map((e) => routeWidget(context, e)).toList());

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

  void startTimer() {
    Timer(Duration(seconds: 1), () {
      print('Is running: $running');
      if(running) {
        startTimer();
        setState(() {
          timeString = Run(time: stopwatch.elapsed.inSeconds).timeString;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    tracker = LocationTracker(map);

    _play_pause = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    tracker.init();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: color_background,
      body: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Center(
                  child: Text(
                    'Run!',
                    style: textStyleHeader,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: IconButton(
                    icon: Icon(CustomIcons.back, size: 30, color: color_text_highlight),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            divider,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ROUTE',
                    style: textStyleDark
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                selectedRoute != null ? selectedRoute.name : 'No route.',
                                style: textStyleHeader,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            OutlineButton(
                              onPressed: () { showDialog(context: context, builder: pickRouteDialog); },
                              child: Text('PICK ROUTE'),
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
                              '${selectedRoute != null ? selectedRoute.distance : '--'}',
                              style: textStyleHeader,
                            ),
                            SizedBox(width: 5,),
                            Text(
                              'm',
                              style: textStyleDark,
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            divider,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height:30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeComponent(
                        icon: CustomIcons.timer,
                        data: timeString,
                        label: timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',
                      ),
                      HomeComponent(
                        icon: CustomIcons.distance,
                        data: tracker.totalDistance.toString(),
                        label: 'm',
                      ),
                    ],
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                tracker.stopLocationService();
                              },
                              child: Container(
                                child: Icon(Icons.stop, color: color_text_highlight, size: constraints.maxHeight / 7),
                                padding: EdgeInsets.all(constraints.maxHeight / 18),
                              ),
                              shape: CircleBorder(side: BorderSide(width: 2, color: color_button_green)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: color_button_green,
                              focusColor: color_button_green,
                              highlightColor: color_button_green,
                              splashColor: color_button_green,
                            ),
                            RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                running = !running;
                                running ? _play_pause.forward() : _play_pause.reverse();
                                if(running) {
                                  startTimer();
                                  stopwatch.start();
                                  if(!tracker.initializedTracking) tracker.startLocationService();
                                  tracker.setTracking(true);
                                } else {
                                  stopwatch.stop();
                                  tracker.setTracking(false);
                                }
                              },
                              child: Container(
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _play_pause,
                                  size: constraints.maxHeight / 3,
                                  color: color_text_highlight,
                                ),
                                padding: EdgeInsets.all(constraints.maxHeight / 12),
                              ),
                              shape: CircleBorder(side: BorderSide(width: 2, color: color_button_green)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: color_button_green,
                              focusColor: color_button_green,
                              highlightColor: color_button_green,
                              splashColor: color_button_green,
                            ),
                            RawMaterialButton(
                              elevation: 0,
                              onPressed: () {
                                map.positions = tracker.positions;
                                if(selectedRoute != null) map.setupRoute(selectedRoute);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => map));
                                //showDialog(context: context, builder: (context) {
                                //  return MapDialog();
                                //});
                              },
                              child: Container(
                                child: Icon(CustomIcons.gps, color: color_text_highlight, size: constraints.maxHeight / 7),
                                padding: EdgeInsets.all(constraints.maxHeight / 18),
                              ),
                              shape: CircleBorder(side: BorderSide(width: 2, color: color_button_green)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: color_button_green,
                              focusColor: color_button_green,
                              highlightColor: color_button_green,
                              splashColor: color_button_green,
                            ),
                          ],
                        );
                      }
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('DISPOSING');
    stopwatch.stop();
    running = false;
    tracker.dispose();
    super.dispose();
    print('DISPOSED');
  }
}
