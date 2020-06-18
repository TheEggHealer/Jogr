import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/home/route_test/map.dart';
import 'package:jogr/utils/constants.dart';
import 'package:latlong/latlong.dart';

class RoutePlanner extends StatefulWidget {
  @override
  _RoutePlannerState createState() => _RoutePlannerState();
}

class _RoutePlannerState extends State<RoutePlanner> {

  Map map = Map();
  double dist = 0;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        map,
        OutlineButton(
          onPressed: () {
            IsolateNameServer.removePortNameMapping("JogrIsolator");
            BackgroundLocator.unRegisterLocationUpdate();

            Distance distance = Distance();
            double d = 0;
            List<LatLng> pos = map.positions.map((e) => LatLng(e.latitude, e.longitude)).toList();
            for(int i = 0; i < map.positions.length - 1; i++) {
              d += distance.as(LengthUnit.Meter, pos[i], pos[i+1]);
            }

            setState(() {
              dist = d;
            });
            print(d);
          },
          child: Text('STOP'),
          color: color_text_highlight,
          highlightColor: color_text_highlight,
          highlightedBorderColor: color_text_highlight,
          focusColor: color_text_highlight,
          hoverColor: color_text_highlight,
          textColor: color_text_dark,
          borderSide: BorderSide(color: color_text_highlight),
        ),
        Text(
          'Distance: $dist m',
          style: textStyleHeaderLarge,
        ),
      ],
    );
  }
}
