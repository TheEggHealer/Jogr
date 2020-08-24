import 'package:flutter/material.dart';
import 'package:jogr/utils/background_clipper.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

import '../constants.dart';
import 'custom_card.dart';

class CustomScaffold extends StatefulWidget {

  final UserData userData;
  final Widget appBar;
  final Widget body;

  const CustomScaffold({Key key, this.appBar, this.body, this.userData}) : super(key: key);

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

class _CustomScaffoldState extends State<CustomScaffold> {


  @override
  Widget build(BuildContext context) {

    BackgroundClipper clipper = BackgroundClipper();
    UserPreferences prefs = UserPreferences(widget.userData);

    return LayoutBuilder(
      builder: (context, box) {

        double divisionHeight = clipper.divisionHeight(box.maxWidth, app_bar_height * box.maxHeight);

        return Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: double.infinity,
              color: prefs.color_background,
              child: Container(
                padding: EdgeInsets.only(top: divisionHeight),
                child: widget.body,
              ),
            ),
            ClipPath(
                clipper: clipper,
                child: Container(
                  width: double.infinity,
                  height: app_bar_height * box.maxHeight,
                  decoration: BoxDecoration(
                    gradient: prefs.gradient_main,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: app_bar_height * box.maxHeight - divisionHeight),
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
