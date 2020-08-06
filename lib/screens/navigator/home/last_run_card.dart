import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/userdata.dart';

class LastRunCard extends StatelessWidget {

  final UserData userData;

  const LastRunCard({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Run last = userData.lastRun;

    return CustomCard(
      userData: userData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'LAST RUN',
            style: textLightLabel,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DataDisplay(
                      icon: CustomIcons.distance,
                      data: roundedString(last.distance / 1000, 2),
                      label: 'km',
                    ),
                    DataDisplay(
                      icon: CustomIcons.timer,
                      data: last.timeString,
                      label: 'mm:ss',
                    ),
                    DataDisplay(
                      icon: CustomIcons.burn,
                      data: last.calories.toString(),
                      label: 'cal',
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    DataDisplay(
                      icon: CustomIcons.jogr,
                      data: last.paceString,
                      label: 'time/km',
                    ),
                    DataDisplay(
                      icon: CustomIcons.speed,
                      data: roundedString(last.speed, 2),
                      label: 'm/s',
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
