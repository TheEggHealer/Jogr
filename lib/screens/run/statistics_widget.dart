import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

class StatisticsWidget extends StatelessWidget {

  Run run;
  UserData userData;
  UserPreferences prefs;

  StatisticsWidget(this.run, this.userData, this.prefs);

  @override
  Widget build(BuildContext context) {

    UserPreferences prefs = UserPreferences(userData.lightMode);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DataDisplay(
                    prefs: prefs,
                    icon: CustomIcons.distance,
                    data: roundedString(run.distance / 1000, 1),
                    label: 'km',
                  ),
                  DataDisplay(
                    prefs: prefs,
                    icon: CustomIcons.timer,
                    data: run.timeString,
                    label: 'mm:ss',
                  ),
                  DataDisplay(
                    prefs: prefs,
                    icon: CustomIcons.burn,
                    data: run.calories.toString(),
                    label: 'cal',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DataDisplay(
                    prefs: prefs,
                    icon: CustomIcons.jogr,
                    data: run.paceString,
                    label: 'time/km',
                  ),
                  DataDisplay(
                    prefs: prefs,
                    icon: CustomIcons.speed,
                    data: roundedString(run.speed, 2),
                    label: 'm/s',
                  ),
                ],
              ),
            ],
          ),
        )

        /**
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.distance,
                      data: roundedString(run.distance / 1000, 1),
                      label: 'km',
                    ),
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.timer,
                      data: run.timeString,
                      label: 'mm:ss',
                    ),
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.jogr,
                      data: run.paceString,
                      label: 'min/km',
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.burn,
                      data: '${run.calories}',
                      label: 'cal',
                    ),
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.speed,
                      data: roundedString(run.speed, 2),
                      label: 'm/s'
                    )
                  ],
                )
              ],
            ),
          ),
        )
            */
      ],
    );
  }
}
