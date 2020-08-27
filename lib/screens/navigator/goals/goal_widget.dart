import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Goal extends StatelessWidget {

  UserData userData;
  UserPreferences prefs;
  String header;
  double a, b;
  String aString, bString;
  String label;
  double percent;


  Goal({ @required this.userData, this.header = 'WEEKLY', this.a, this.b, this.label }) {
    percent = (a / b).clamp(0.0, 1.0);
    aString = a % 1 == 0 ? a.toInt().toString() : a.toString();
    bString = b % 1 == 0 ? b.toInt().toString() : b.toString();

    prefs = UserPreferences(userData.lightMode);
  }

  Widget get center {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(aString, style: prefs.text_goal,),
        Divider(
          height: 0,
          thickness: 0.5,
          color: prefs.color_highlight,
          indent: 25,
          endIndent: 25,
        ),
        Text(bString, style: prefs.text_goal,),
        Text(label, style: prefs.text_label,),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      userData: userData,
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            header,
            style: prefs.text_label
          ),
          CircularPercentIndicator(
            radius: 90,
            lineWidth: 4,
            percent: percent,
            center: center,
            progressColor: prefs.color_secondary_highlight,
            backgroundColor: prefs.color_shadow,
          ),
        ],
      ),
    );
  }
}
