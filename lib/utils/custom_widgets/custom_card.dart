import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

class CustomCard extends StatefulWidget {

  final UserData userData;
  final Widget child;
  final Function onTap;
  final double paddingFactor;

  const CustomCard({Key key, this.userData, this.child, this.onTap, this.paddingFactor = 2}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {

  double radius = 20;

  @override
  Widget build(BuildContext context) {

    UserPreferences prefs = UserPreferences(widget.userData.lightMode);

    List<Widget> content = [
      Container(
        child: Card(
          color: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Container(
            padding: EdgeInsets.all(radius/widget.paddingFactor),
            decoration: BoxDecoration(
              gradient: prefs.gradient_main,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
            child: widget.child,
          ),
        ),
      ),
    ];

    if(widget.onTap != null) {
      content.add(Positioned.fill(
        child: Padding(
          padding: EdgeInsets.all(4), //TODO: Funkar detta?
          child: Material(
            color: Colors.transparent,

            child: InkWell(
              onTap: widget.onTap,
              splashColor: prefs.color_splash,
              hoverColor: prefs.color_splash,
              highlightColor: prefs.color_splash,
              focusColor: prefs.color_splash,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
        ),
      ));
    }

    return Stack(
      children: content
    );
  }
}
