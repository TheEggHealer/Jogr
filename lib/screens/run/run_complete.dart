import 'package:flutter/material.dart' hide Route;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/screens/home/goal_widget.dart';
import 'package:jogr/screens/home/home.dart';
import 'package:jogr/screens/home/home_component.dart';
import 'package:jogr/screens/run/statistics_widget.dart';
import 'package:jogr/services/database.dart';
import 'file:///E:/Documents/AndroidProjects/Flutter/jogr/lib/screens/run/map_widget.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/run_log.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RunComplete extends StatefulWidget {

  RunLog log;
  Run run;
  MapWidget map = MapWidget();
  UserData userData;
  DatabaseService db;
  HomeState home;

  RunComplete(this.log, Route route, this.userData, this.db, this.home) {
    map.positions = log.locations;

    run = !log.empty ? Run.from(log, route, userData) : Run(date: '20200724', distance: 3093, time: 839, calories: 132, route: route);
  }

  @override
  _RunCompleteState createState() => _RunCompleteState();
}

class _RunCompleteState extends State<RunComplete> {

  Widget statsBuilder(BuildContext context, int index) {

    List<Widget> goals = [
      StatisticsWidget(widget.run),
      Goal(
        header: 'THIS MONTH • RUN SOME DISTANCE',
        fraction: true,
        a: HomeComponent(data: '17.4', label: 'km',),
        b: HomeComponent(data: '40', label: 'km'),
      ),
      Goal(
        header: 'THIS WEEK • BURN SOME CALORIES',
        fraction: true,
        a: HomeComponent(data: '2150', label: 'cal',),
        b: HomeComponent(data: '2000', label: 'cal'),
        completed: true,
      ),
      Goal(
        header: 'THIS MONTH • REACH SOME PACE',
        content: HomeComponent(data: '7.1', label: 'm/s'),
      ),
      Goal(
        header: 'THIS WEEK • RUN SOME DISTANCE',
        fraction: true,
        a: HomeComponent(data: '3.5', label: 'km',),
        b: HomeComponent(data: '10', label: 'km'),
        post: 'ran',
      ),

    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 5,
        color: color_card,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: goals[index]),

        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: 0);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
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
                color: color_background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
              ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        Icons.drag_handle,
                        size: 30,
                        color: color_text_dark
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
                color: color_background,
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
                          dotColor: color_text_dark,
                          activeDotColor: color_text_highlight,
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
                              },
                              child: Icon(
                                CustomIcons.trash,
                              ),
                              color: color_error,
                              splashColor: color_error,
                              highlightColor: color_error,
                              focusColor: color_error,
                              textColor: color_text_dark,
                              borderSide: BorderSide(color: color_error),
                              highlightedBorderColor: color_error,
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
                                    'previous_runs': widget.userData.raw['previous_runs'].putIfAbsent('', () => {run.date: {'distance': run.distance,'time': run.time, 'calories': run.calories, 'route': run.route.name}})
                                  });
                                  widget.home.setState(() {
                                    widget.home.running = false;
                                    Navigator.pop(context);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                      'SAVE AND CONTINUE',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          color: color_text_dark
                                      )
                                  ),
                                ),
                                color: color_button_green,
                                splashColor: color_button_green,
                                highlightColor: color_button_green,
                                focusColor: color_button_green,
                                textColor: color_text_dark,
                                borderSide: BorderSide(color: color_button_green),
                                highlightedBorderColor: color_button_green,
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
        },
      ),
    );
  }
}
