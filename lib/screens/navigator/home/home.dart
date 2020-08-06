import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/goals/goal_widget.dart';
import 'package:jogr/screens/navigator/home/last_run_card.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/utils/background_clipper.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/custom_scaffold.dart';
import 'package:jogr/utils/models/userdata.dart';
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
              style: textLightHeaderInvert,
            ),
            Text(
              ud.name,
              style: textLightBackground,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Goals',
                style: textLightHeader,
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
                      Goal(userData: ud,),
                      Goal(userData: ud,),
                      Goal(userData: ud,),
                      Goal(userData: ud,),
                      Goal(userData: ud,),
                    ],
                  )
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: LayoutBuilder(
              builder: (context, box) {
                return Container(

                  child: Center(
                    child: OutlineGradientButton(
                      child: SizedBox(
                        width: box.maxHeight / 1.5,
                        height: box.maxHeight / 1.5,
                        child: Center(
                          child: Icon(
                            Icons.directions_run,
                            size: box.maxHeight / 3,
                            color: color_light_text_header,
                          )
                        ),
                      ),
                      onTap: () {
                        widget.navigator.setState(() {
                          widget.navigator.running = true;
                        });
                      },
                      radius: Radius.circular(box.maxHeight / 1.5),
                      gradient: light_gradient_main,
                      strokeWidth: 4,
                      inkWell: true,

                    ),
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}