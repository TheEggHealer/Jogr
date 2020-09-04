import 'package:flutter/material.dart' hide Route;
import 'package:jogr/screens/navigator/goals/goal_widget.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/screens/run/map_widget.dart';
import 'package:jogr/screens/run/statistics_widget.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/run_log.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RunComplete extends StatefulWidget {

  RunLog log;
  Run run;
  MapWidget map = MapWidget();
  UserData userData;
  DatabaseService db;
  ScreenNavigatorState navigator;

  RunComplete(this.log, Route route, this.userData, this.db, this.navigator) {
    map.positions = log.locations;
    map.setTheme(userData);

    run = !log.empty ? Run.from(log, route, userData) : Run(date: '202007241901', distance: 3093, time: 839, calories: 132, pace: 243, route: route);
  }

  @override
  _RunCompleteState createState() => _RunCompleteState();
}

class _RunCompleteState extends State<RunComplete> {

  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: 0);
    UserPreferences prefs = UserPreferences(widget.userData.lightMode);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, box) {

          double cardHeight = box.maxHeight / 4.3;
          double rest = box.maxHeight / 3 - cardHeight;
          double minHeight = 100;

          return SlidingUpPanel(
            parallaxEnabled: true,
            parallaxOffset: 0.4,
            renderPanelSheet: false,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
            maxHeight: cardHeight + minHeight + rest + 30,
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
                      'Run Completed',
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
                children: [
                  Icon(
                      Icons.remove,
                      size: 30,
                      color: prefs.color_shadow
                  ),
                  Text(
                    'Run Completed',
                    style: prefs.text_header,
                  ),
                  SizedBox(height: 20),
                  Divider(
                    color: prefs.color_shadow,
                  ),
                  Container(
                    height: cardHeight,
                    child: PageView(
                      controller: pageController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Center(
                            child: CustomCard(
                              userData: widget.userData,
                              paddingFactor: 1,
                              child: Container(
                                width: box.maxWidth * 0.8,
                                height: cardHeight,
                                child: StatisticsWidget(widget.run, widget.userData, prefs),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 14, left: 5, right: 5),
                          child: Center(
                            child: CustomCard(
                              userData: widget.userData,
                              paddingFactor: 1,
                              child: Container(
                                width: box.maxWidth * 0.7,
                                height: cardHeight,
                                child: Center(
                                  child: Text(
                                    'Height difference chart',
                                    style: prefs.text_header,
                                  ),
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: Icon(CustomIcons.trash, color: prefs.color_text_header),
                            onPressed: () async {
                              //TODO Show dialog asking if user wants to throw away run
                              widget.navigator.setState(() {
                                widget.navigator.running = false;
                                Navigator.pop(context);
                              });
                            },
                            iconSize: 30,
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: button(
                                onTap: () async {
                                  Run run = widget.run;
                                  await widget.db.mergeUserDataFields({
                                    'previous_runs': widget.userData.raw['previous_runs'].putIfAbsent('', () => {
                                      run.date: {
                                        'distance': run.distance,
                                        'time': run.time,
                                        'calories': run.calories,
                                        'route': run.route == null ? 'null' : run.route.name
                                      }
                                    })
                                  });
                                  print('Updated database');
                                  widget.navigator.setState(() {
                                    widget.navigator.running = false;
                                  });
                                  Navigator.pop(context);
                                },
                                text: 'Save and continue',
                                textColor: prefs.color_text_header,
                                borderColor: prefs.color_main,
                                splashColor: prefs.color_splash,
                                borderRadius: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: widget.map,
          );
          /**
          return SlidingUpPanel(
            renderPanelSheet: false,
            defaultPanelState: PanelState.OPEN,
            parallaxEnabled: true,
            parallaxOffset: 0.5,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
            maxHeight: MediaQuery.of(context).size.height/1.7,
            minHeight: 100,

            collapsed: Container(
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                color: color_dark_background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
              ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        Icons.drag_handle,
                        size: 30,
                        color: color_dark_text_dark
                    ),
                    Center(
                      child: Text(
                        'Run Complete',
                        style: textStyleHeaderSmall,
                      ),
                    ),
                  ],
                )
            ),

            panel: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: color_dark_background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8.0,
                    color: Colors.black,
                  ),
                ]
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Text(
                          'Run Complete',
                          style: textStyleHeaderSmall,
                        ),
                      ),
                      Divider(
                        color: Color(0xff555555),
                        endIndent: 20,
                        indent: 20,
                        height: 30,
                      ),
                    ],
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      maxHeight: constraints.maxHeight / 4,
                    ),
                    child: PageView.builder(
                      controller: controller,
                      itemBuilder: statsBuilder,
                      itemCount: 5,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 5,
                      effect: ExpandingDotsEffect(
                          dotColor: color_dark_text_dark,
                          activeDotColor: color_dark_text_highlight,
                          dotWidth: 6,
                          dotHeight: 6,
                          spacing: 3,
                          paintStyle: PaintingStyle.fill,
                          strokeWidth: 1
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height:60,
                            width: 60,
                            child: OutlineButton(
                              onPressed: () async {
                                widget.navigator.setState(() {
                                  widget.navigator.running = false;
                                  Navigator.pop(context);
                                });
                              },
                              child: Icon(
                                CustomIcons.trash,
                              ),
                              color: color_dark_error,
                              splashColor: color_dark_error,
                              highlightColor: color_dark_error,
                              focusColor: color_dark_error,
                              textColor: color_dark_text_dark,
                              borderSide: BorderSide(color: color_dark_error),
                              highlightedBorderColor: color_dark_error,
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 10,
                            child: SizedBox(
                              height: 60,
                              child: OutlineButton(
                                onPressed: () async {
                                  Run run = widget.run;
                                  await widget.db.mergeUserDataFields({
                                    'previous_runs': widget.userData.raw['previous_runs'].putIfAbsent('', () => {
                                      run.date: {
                                        'distance': run.distance,
                                        'time': run.time,
                                        'calories': run.calories,
                                        'route': run.route == null ? 'null' : run.route.name
                                      }
                                    })
                                  });
                                  print('Updated database');
                                  widget.navigator.setState(() {
                                    widget.navigator.running = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                      'SAVE AND CONTINUE',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          color: color_dark_text_dark
                                      )
                                  ),
                                ),
                                color: color_dark_button_green,
                                splashColor: color_dark_button_green,
                                highlightColor: color_dark_button_green,
                                focusColor: color_dark_button_green,
                                textColor: color_dark_text_dark,
                                borderSide: BorderSide(color: color_dark_button_green),
                                highlightedBorderColor: color_dark_button_green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            body: widget.map,
          );
              */
        },
      ),
    );
  }
}
