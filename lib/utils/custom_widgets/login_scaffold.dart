import 'package:flutter/material.dart';
import 'package:jogr/utils/background_clipper.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

import '../constants.dart';
import '../oval_top_clipper.dart';
import 'custom_card.dart';

class LoginScaffold extends StatefulWidget {

  final lightMode;
  final Widget appBar;
  final Widget body;
  final bool bodyClipped;

  const LoginScaffold({Key key, this.appBar, this.body, this.lightMode, this.bodyClipped = false}) : super(key: key);

  @override
  _LoginScaffoldState createState() => _LoginScaffoldState();
}

class _LoginScaffoldState extends State<LoginScaffold> {

  bool gotScreenHeight = false;
  double screenHeight;

  @override
  Widget build(BuildContext context) {

    if(!gotScreenHeight) screenHeight = MediaQuery.of(context).size.height;
    gotScreenHeight = true;

    OvalTopClipper clipper = OvalTopClipper();
    UserPreferences prefs = UserPreferences(widget.lightMode);

    return LayoutBuilder(
      builder: (context, box) {

        double divisionHeight = screenHeight * 0.4;
        print(divisionHeight);

        return Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              color: prefs.color_background,
              child: Container(
                padding: EdgeInsets.only(top: widget.bodyClipped ? divisionHeight - screenHeight * OvalTopClipper.roundness : divisionHeight),
                child: widget.body,
              ),
            ),
            ClipPath(
                clipper: clipper,
                child: Container(
                  width: double.infinity,
                  height: divisionHeight,
                  decoration: BoxDecoration(
                    gradient: prefs.gradient_main,
                  ),
                  child: Container(
                    //padding: EdgeInsets.only(bottom: app_bar_height * box.maxHeight - divisionHeight),
                    child: widget.appBar,
                  ),
                )
            ),
          ],
        );
      },
    );
  }
}
