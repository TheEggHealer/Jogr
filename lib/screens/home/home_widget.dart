import 'package:flutter/material.dart';

import 'package:learningflutter2/utils/constants.dart';
import 'package:learningflutter2/utils/custom_icons.dart';
import 'package:learningflutter2/utils/models/userdata.dart';
import 'package:provider/provider.dart';

import '../../home_component.dart';


class HomeWidget extends StatefulWidget {

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  @override
  Widget build(BuildContext context) {

    UserData userData = Provider.of<UserData>(context);

    return  Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '• LAST RUN',
                style: textStyleDark
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeComponent(
                  icon: CustomIcons.distance,
                  data: userData.runs.length > 0 ? userData.lastRun.distanceString : '--',
                  label: 'km',
                ),
                HomeComponent(
                  icon: CustomIcons.timer,
                  data: userData.runs.length > 0 ? userData.lastRun.timeString : '--:--',
                  label: userData.runs.length > 0 ? (userData.lastRun.timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss') : 'mm:ss',
                ),
                HomeComponent(
                  icon: CustomIcons.burn,
                  data: userData.runs.length > 0 ? userData.lastRun.calories.toString() : '--',
                  label: 'cal',
                )
              ],
            ),

            SizedBox(height: 30),

            Text(
                '• NEXT RUN',
                style: textStyleDark
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                HomeComponent(
                  icon: null,
                  data: '2',
                  label: 'days left',
                ),
                HomeComponent(
                  icon: CustomIcons.distance,
                  data: '3,4',
                  label: 'km',
                ),
                OutlineButton(
                  onPressed: () {},
                  child: Text('SEE ROUTE'),
                  color: color_text_highlight,
                  highlightColor: color_text_highlight,
                  highlightedBorderColor: color_text_highlight,
                  focusColor: color_text_highlight,
                  hoverColor: color_text_highlight,
                  textColor: color_text_dark,
                  borderSide: BorderSide(color: color_text_highlight),
                )
              ],
            ),

            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,

              children: [
                Icon(Icons.cloud, color: color_text_highlight),

                SizedBox(width: 10),

                Text(
                  '18',
                  style: textStyleHeader,
                ),

                SizedBox(width: 10),

                Text(
                    'cloudy forecast',
                    style: textStyleDark
                ),
              ],
            ),

            SizedBox(height: 20),

            Center(
              child: OutlineButton(
                onPressed: () {},
                child: Text('CHANGE PLAN'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                borderSide: BorderSide(color: color_text_highlight),
              ),
            )
          ]
      ),
    );
  }
}
