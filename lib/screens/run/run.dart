import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart' hide Route;
import 'package:flutter/material.dart' hide Route;
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/screens/run/location_tracker.dart';
import 'package:jogr/screens/run/map_dialog.dart';
import 'package:jogr/screens/run/run_complete.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/custom_scaffold.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/file_manager.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/run_log.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

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
                  onTap: () {
                    setState(() {
                      selectedRoute = route;
                    });
                    Navigator.of(context).pop();
                  }
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

  void startTimer() {
    Timer(Duration(milliseconds: 1000), () {
      if(running) {
        startTimer();
        setState(() {
          if(--updateTimeDistanceCooldown <= 0) {
            updateTimeDistanceCooldown = 20;
            update();
          }
          timeString = Run(time: stopwatch.elapsed.inSeconds + startTimeSeconds).timeString;
        });
      }
    });
  }

  Future<void> update() async {
    String fileContent = await FileManager.read();
    print('File content: $fileContent');
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
      print('Creating runlog from: $fileContent');
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
  }

  void _onStop() async {
    if(running) {
      if ((await FileManager.read()).isNotEmpty) tracker.startLocationService();
      stopwatch.stop();
      running = false;
      //CallbackHandler.setActive(false);
      print(await FileManager.read());
      print('File size: ${await FileManager.fileSize()}');
      await FileManager.clear();
      _play_pause.reverse();

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => RunComplete(log, selectedRoute, userData, db, navigator)));
      tracker.stopLocationService();
    } else {
      await FileManager.clear();
      tracker.stopLocationService();
      widget.navigator.running = false;
      Navigator.pop(context);
    }
  }

  void _onMap() {
    setState(() async {
      await update();
      map.map.setTheme(userData);
      map.map.positions = log.locations;
      if(selectedRoute != null) map.map.setupRoute(selectedRoute);
      Navigator.push(context, MaterialPageRoute(builder: (context) => map));
    });
  }

  Future<bool> _onWillPop(UserPreferences prefs) {
    print(running);
    if(running) {
      return showDialog(
        context: context,
        builder: (context) =>
        new Dialog(
          backgroundColor: prefs.color_background,
          child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Exit?',
                    style: prefs.text_header,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'If you go back, your current run will be lost. Are you sure you want to exit?',
                  style: prefs.text_header_2,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    button(
                      onTap: () => Navigator.of(context).pop(false),
                      borderColor: prefs.color_main,
                      textColor: prefs.color_text_header,
                      splashColor: prefs.color_splash,
                      text: 'Cancel',
                    ),
                    button(
                      onTap: () async {
                        tracker.stopLocationService();
                        stopwatch.stop();
                        running = false;
                        await FileManager.clear();
                        widget.navigator.running = false;
                        Navigator.of(context).pop(true);
                      },
                      borderColor: prefs.color_error,
                      textColor: prefs.color_text_header,
                      splashColor: prefs.color_splash,
                      text: 'Exit',
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ) ?? false;
    } else {
      widget.navigator.running = false;
      Navigator.pop(context);
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {

    UserPreferences prefs = UserPreferences(userData.lightMode);

    return WillPopScope(
      onWillPop: () {
        return _onWillPop(prefs);
      },
      child: Scaffold(
        body: CustomScaffold(
          userData: userData,
          appBar: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () async {
                      if(running) {
                        bool quit = await _onWillPop(prefs);
                        if (quit) Navigator.pop(context);
                      } else {
                        widget.navigator.running = false;
                        Navigator.pop(context);
                      }
                    },
                    iconSize: 30,
                    splashColor: prefs.color_splash,
                    icon: Icon(CustomIcons.back, color: prefs.color_highlight,),
                    color: prefs.color_highlight,
                  ),
                  Text(
                    'Run',
                    style: prefs.text_header_invert_bold,
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(flex: 4),
                Flexible(
                  flex: 5,
                  child: CustomCard(
                    userData: userData,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Planned route',
                              style: prefs.text_label,
                            ),
                            Text(
                              selectedRoute == null ? 'No route' : selectedRoute.name,
                              style: prefs.text_header_invert_2,
                            ),
                            DataDisplay(
                              prefs: prefs,
                              data: selectedRoute == null ? '--' : selectedRoute.distance.toString(),
                              label: 'm',
                            )
                          ],
                        ),
                        button(
                          onTap: () => showDialog(context: context, builder: loadDialog),
                          text: 'Pick route',
                          borderColor: prefs.color_highlight,
                          textColor: prefs.color_text_background,
                          splashColor: prefs.color_splash,
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: prefs.color_shadow,
                ),
                Flexible(
                  flex: 7,
                  child: CustomCard(
                    userData: userData,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Current run',
                          style: prefs.text_label,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DataDisplay(
                                prefs: prefs,
                                icon: CustomIcons.timer,
                                data: loading ? '--:--:--' : timeString,
                                label: timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',
                              ),
                              DataDisplay(
                                prefs: prefs,
                                icon: CustomIcons.distance,
                                data: loading ? '--' : '$distance',
                                label: 'm',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: LayoutBuilder(
                    builder: (context, box) {
                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
                          RawMaterialButton(
                            elevation: 0,
                            onPressed: _onStop,
                            child: Container(
                              child: Icon(Icons.stop, color: prefs.color_main, size: box.maxHeight / 7),
                              padding: EdgeInsets.all(box.maxHeight / 14),
                            ),
                            shape: CircleBorder(side: BorderSide(width: 2, color: prefs.color_main)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            highlightColor: prefs.color_shadow,
                            focusColor: prefs.color_shadow,
                            hoverColor: prefs.color_shadow,
                            splashColor: prefs.color_shadow,
                          ),
                          RawMaterialButton(
                            elevation: 0,
                            onPressed: _onPlayPause,
                            child: Container(
                              child: AnimatedIcon(
                                icon: AnimatedIcons.play_pause,
                                progress: _play_pause,
                                size: box.maxHeight / 2.5,
                                color: prefs.color_main,
                              ),
                              padding: EdgeInsets.all(box.maxHeight / 10),
                            ),
                            shape: CircleBorder(side: BorderSide(width: 2, color: prefs.color_main)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            highlightColor: prefs.color_shadow,
                            focusColor: prefs.color_shadow,
                            hoverColor: prefs.color_shadow,
                            splashColor: prefs.color_shadow,
                          ),
                          RawMaterialButton(
                            elevation: 0,
                            onPressed: _onMap,
                            child: Container(
                              child: Icon(CustomIcons.gps, color: prefs.color_main, size: box.maxHeight / 7),
                              padding: EdgeInsets.all(box.maxHeight / 14),
                            ),
                            shape: CircleBorder(side: BorderSide(width: 2, color: prefs.color_main)),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            highlightColor: prefs.color_shadow,
                            focusColor: prefs.color_shadow,
                            hoverColor: prefs.color_shadow,
                            splashColor: prefs.color_shadow,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ]
            ),
          )
        )
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
