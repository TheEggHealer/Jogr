import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jogr/screens/home/route/map.dart';
import 'package:jogr/utils/constants.dart';

class RoutePlanner extends StatefulWidget {
  @override
  _RoutePlannerState createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Map(),
        OutlineButton(
          onPressed: () {},
          child: Text('STOP'),
          color: color_text_highlight,
          highlightColor: color_text_highlight,
          highlightedBorderColor: color_text_highlight,
          focusColor: color_text_highlight,
          hoverColor: color_text_highlight,
          textColor: color_text_dark,
          borderSide: BorderSide(color: color_text_highlight),
        )
      ],
    );
  }
}
