import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/goals/goal_widget.dart';
import 'package:jogr/screens/navigator/home/last_run_card.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/utils/background_clipper.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_scaffold.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {

  final UserData userData;
  final ScreenNavigatorState navigator;

  Home(this.userData, this.navigator);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    UserData ud = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences(ud.lightMode);
    BackgroundClipper clipper = BackgroundClipper();

    return CustomScaffold(
      userData: ud,
      appBar: Padding(
        padding: const EdgeInsets.only(left: 30, bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome back,',
              style: prefs.text_header_invert_bold,
            ),
            Text(
              ud.name,
              style: prefs.text_background,
            )
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: LastRunCard(
                userData: ud,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Goals',
                  style: prefs.text_header,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: LayoutBuilder(
              builder: (context, box) {
                return Container(
                  height: box.maxHeight,
                  child: ListView(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Goal(userData: ud, a: 29, b: 50, label: 'km'),
                      Goal(userData: ud, header: 'DAYLY', a: 126.8, b: 500, label: 'km'),
                      Goal(userData: ud, header: 'YEARLY', a: 2009, b: 5680, label: 'km'),
                      Goal(userData: ud, a: 2050, b: 2000, label: 'cal'),
                      Goal(userData: ud, a: 29, b: 50, label: 'km'),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: Icon(
                              CustomIcons.add_circle,
                            ),
                            iconSize: 60,
                            //splashRadius: 30,
                            onPressed: notImplemented,
                            color: prefs.color_shadow,
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,

                          ),
                        ),
                      )
                    ],
                  )
                );
              },
            ),
          ),
          Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
            color: prefs.color_shadow,
          ),
          Expanded(
            flex: 4,
            child: LayoutBuilder(
              builder: (context, box) {
                return Container(

                  child: Center(
                    child: RawMaterialButton(
                      elevation: 10,
                      onPressed: () {
                        widget.navigator.setState(() {
                          widget.navigator.running = true;
                        });
                      },
                      child: Container(
                        child: Icon(Icons.directions_run, color: prefs.color_text_header, size: box.maxHeight / 5),
                        padding: EdgeInsets.all(box.maxHeight / 3.5),
                      ),
                      shape: CircleBorder(side: BorderSide(width: 2, color: prefs.color_main)),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      highlightColor: prefs.color_shadow,
                      focusColor: prefs.color_shadow,
                      hoverColor: prefs.color_shadow,
                      splashColor: prefs.color_shadow,

                    )
                  )
                );
              },
            )
          ),
        ],
      ),
    );
  }
}