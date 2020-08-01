import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'home_widget.dart';

class Home extends StatefulWidget {

  UserData userData;
  ScreenNavigatorState navigator;

  Home(this.userData, this.navigator);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Welcome back, ${widget.userData.name}',
                  style: textStyleHeader,
                ),
              ),

              Divider(
                color: Color(0xff555555),
                endIndent: 20,
                indent: 20,
                height: 60,
              ),

              HomeWidget(),

              SizedBox(height: 10),

              Divider(
                color: Color(0xff555555),
                endIndent: 20,
                indent: 20,
                height: 0,
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return RawMaterialButton(
                    elevation: 0,
                    onPressed: () {
                      widget.navigator.setState(() {
                        widget.navigator.running = true;
                      });
                    },
                    child: Container(
                      child: Icon(Icons.directions_run, color: color_text_highlight, size: constraints.maxHeight / 5),
                      padding: EdgeInsets.all(constraints.maxHeight / 5),
                    ),
                    shape: CircleBorder(side: BorderSide(width: 2, color: color_button_green)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    hoverColor: color_button_green,
                    focusColor: color_button_green,
                    highlightColor: color_button_green,
                    splashColor: color_button_green,
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}



/**


    Padding(
    padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
    Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Center(
    child: Text(
    'Welcome back, ${userData.name}',
    style: textStyleHeader,
    ),
    ),

    Divider(
    color: Color(0xff555555),
    endIndent: 20,
    indent: 20,
    height: 60,
    ),

    HomeWidget(),

    SizedBox(height: 10),

    Divider(
    color: Color(0xff555555),
    endIndent: 20,
    indent: 20,
    height: 0,
    ),
    ],
    ),
    Expanded(
    child: Center(
    child: LayoutBuilder(
    builder: (context, constraints) {
    return RawMaterialButton(
    elevation: 0,
    onPressed: () {
    setState(() {
    running = true;
    });
    },
    child: Container(
    child: Icon(Icons.directions_run, color: color_text_highlight, size: constraints.maxHeight / 5),
    padding: EdgeInsets.all(constraints.maxHeight / 5),
    ),
    shape: CircleBorder(side: BorderSide(width: 2, color: color_button_green)),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    hoverColor: color_button_green,
    focusColor: color_button_green,
    highlightColor: color_button_green,
    splashColor: color_button_green,
    );
    }
    ),
    ),
    ),
    ],
    ),
    ),


*/