import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;
import 'file:///C:/Users/jonru/Documents/GitHub/Jogr/lib/utils/custom_widgets/data_display.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/screens/run/location_tracker.dart';
import 'package:jogr/screens/run/map_dialog.dart';
import 'package:jogr/screens/run/run_complete.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/file_manager.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/run_log.dart';
import 'package:jogr/utils/models/userdata.dart';

class RunScreen extends StatefulWidget {

  final UserData _userData;
  final DatabaseService db;
  ScreenNavigatorState navigator;

  RunScreen(this._userData, this.navigator, this.db);

  @override
  _RunScreenState createState() => _RunScreenState(_userData, navigator, db);
}

class _RunScreenState extends State<RunScreen> with SingleTickerProviderStateMixin {

  UserData userData;
  DatabaseService db;
  LocationTracker tracker;
  ScreenNavigatorState navigator;
  RunLog log = RunLog('');

  Route selectedRoute;
  AnimationController _play_pause;
  bool running = false;
  bool loading = true;

  int distance = 0;

  String timeString = '00:00';
  Stopwatch stopwatch = Stopwatch();
  Timer timer;
  int startTimeSeconds = 0;
  int updateTimeDistanceCooldown = 5;

  MapDialog map = MapDialog();

  _RunScreenState(this.userData, this.navigator, this.db) {
    selectedRoute = userData.routes.isNotEmpty ? (userData.lastRoute != null ? userData.lastRoute : userData.routes[0]) : null;
  }

  Widget routeWidget(BuildContext context, Route route) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: color_dark_card,
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
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                borderSide: BorderSide(color: color_dark_text_highlight),
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
              icon: Icon(CustomIcons.back, size: 30, color: color_dark_text_highlight),
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
      backgroundColor: color_dark_background,
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
    Timer(Duration(milliseconds: 1000), () {
      if(running) {
        startTimer();
        setState(() {
          if(--updateTimeDistanceCooldown <= 0) {
            updateTimeDistanceCooldown = 20;
            update();
            print('Updating');
          }
          timeString = Run(time: stopwatch.elapsed.inSeconds + startTimeSeconds).timeString;
        });
      }
    });
  }

  Future<void> update() async {
    String fileContent = await FileManager.read();
    if(fileContent.isNotEmpty) {
      this.log = RunLog(fileContent);
      startTimeSeconds = ((DateTime.now().millisecondsSinceEpoch - log.startTime) / 1000).round();
      distance = log.distance.round();

      stopwatch.reset();
    }
  }

  void setupAlreadyActive() async {
    String fileContent = await FileManager.read();
    print('SETING UP');
    if(fileContent.isNotEmpty) {
      this.log = RunLog(fileContent);

      setState(() {
        this.running = true;
        _play_pause.forward();
        startTimeSeconds = ((DateTime.now().millisecondsSinceEpoch - log.startTime) / 1000).round();
        distance = log.distance.round();

        startTimer();
        stopwatch.start();
        loading = false;
      });

      print('************** TRACKING');
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    tracker = LocationTracker(map, db);
    tracker.init();

    _play_pause = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    setupAlreadyActive();
  }

  void _onPlayPause() {
    running = !running;
    running ? _play_pause.forward() : _play_pause.reverse();

    if(running) {
      if(!tracker.initializedTracking) tracker.startLocationService();
      startTimer();
      stopwatch.start();
      //CallbackHandler.setActive(true);
    } else {
      //CallbackHandler.setActive(false);
      FileManager.write('*\n');
    }

    /**
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
        */
  }

  void _onStop() async {
    if((await FileManager.read()).isNotEmpty) tracker.startLocationService();
    stopwatch.stop();
    running = false;
    //CallbackHandler.setActive(false);
    print(await FileManager.read());
    print('File size: ${await FileManager.fileSize()}');
    await FileManager.clear();
    _play_pause.reverse();

    Navigator.push(context, MaterialPageRoute(builder: (context) => RunComplete(log, selectedRoute, userData, db, navigator)));
    tracker.stopLocationService();
  }

  void _onMap() {
    setState(() async {
      await update();
      map.map.positions = log.locations;
      if(selectedRoute != null) map.map.setupRoute(selectedRoute);
      Navigator.push(context, MaterialPageRoute(builder: (context) => map));
    });
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: color_dark_background,
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
                    icon: Icon(CustomIcons.back, size: 30, color: color_dark_text_highlight),
                    onPressed: () {
                      navigator.setState(() {
                        navigator.running = false;
                      });
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
                      DataDisplay(
                        icon: CustomIcons.timer,
                        data: loading ? '--:--:--' : timeString,
                        label: timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',
                      ),
                      DataDisplay(
                        icon: CustomIcons.distance,
                        data: loading ? '--' : '$distance',
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
                              onPressed: _onStop,
                              child: Container(
                                child: Icon(Icons.stop, color: color_dark_text_highlight, size: constraints.maxHeight / 7),
                                padding: EdgeInsets.all(constraints.maxHeight / 18),
                              ),
                              shape: CircleBorder(side: BorderSide(width: 2, color: color_dark_button_green)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: color_dark_button_green,
                              focusColor: color_dark_button_green,
                              highlightColor: color_dark_button_green,
                              splashColor: color_dark_button_green,
                            ),
                            RawMaterialButton(
                              elevation: 0,
                              onPressed: _onPlayPause,
                              child: Container(
                                child: AnimatedIcon(
                                  icon: AnimatedIcons.play_pause,
                                  progress: _play_pause,
                                  size: constraints.maxHeight / 3,
                                  color: color_dark_text_highlight,
                                ),
                                padding: EdgeInsets.all(constraints.maxHeight / 12),
                              ),
                              shape: CircleBorder(side: BorderSide(width: 2, color: color_dark_button_green)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: color_dark_button_green,
                              focusColor: color_dark_button_green,
                              highlightColor: color_dark_button_green,
                              splashColor: color_dark_button_green,
                            ),
                            RawMaterialButton(
                              elevation: 0,
                              onPressed: _onMap,
                              child: Container(
                                child: Icon(CustomIcons.gps, color: color_dark_text_highlight, size: constraints.maxHeight / 7),
                                padding: EdgeInsets.all(constraints.maxHeight / 18),
                              ),
                              shape: CircleBorder(side: BorderSide(width: 2, color: color_dark_button_green)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              hoverColor: color_dark_button_green,
                              focusColor: color_dark_button_green,
                              highlightColor: color_dark_button_green,
                              splashColor: color_dark_button_green,
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
    loading = true;
    tracker.dispose();
    print('DISPOSED');
    super.dispose();
  }
}
