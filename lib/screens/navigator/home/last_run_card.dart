import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

class LastRunCard extends StatelessWidget {

  final UserData userData;

  const LastRunCard({Key key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Run last = userData.lastRun;
    bool exists = last != null;
    UserPreferences prefs = UserPreferences(userData);

    return CustomCard(
      userData: userData,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            'LAST RUN • ${DateFormat('EEEE, MMMM dd yyyy, HH:mm').format(DateTime.parse(formatDate(last.date)))}', //TODO Fix this
            style: prefs.text_label,
          ),
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
                      data: exists ? roundedString(last.distance / 1000, 2) : '--',
                      label: 'km',
                    ),
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.timer,
                      data: exists ? last.timeString : '--:--',
                      label: 'mm:ss',
                    ),
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.burn,
                      data: exists ? last.calories.toString() : '--',
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
                      data: exists ? last.paceString : '--:--',
                      label: 'time/km',
                    ),
                    DataDisplay(
                      prefs: prefs,
                      icon: CustomIcons.speed,
                      data: exists ? roundedString(last.speed, 2) : '--',
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
