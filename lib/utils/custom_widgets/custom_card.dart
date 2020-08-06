import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/userdata.dart';

class CustomCard extends StatefulWidget {

  final UserData userData;
  final Widget child;

  const CustomCard({Key key, this.userData, this.child}) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {

  double radius = 20;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: Container(
        padding: EdgeInsets.all(radius/2),
        decoration: BoxDecoration(
          gradient: widget.userData.lightMode ? light_gradient_main : dark_gradient_main,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        child: widget.child,
      ),
    );
  }
}
