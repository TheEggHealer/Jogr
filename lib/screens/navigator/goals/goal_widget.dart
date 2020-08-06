import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Goal extends StatelessWidget {

  UserData userData;
  String header;
  String pre, post;
  DataDisplay a, b;
  bool fraction;
  Widget content;
  bool completed;

  Goal({ @required this.userData, this.header = 'THIS WEEK', this.pre = '', this.post = '', this.a, this.b, this.fraction = false, this.content, this.completed = false });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      userData: userData,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            header,
            style: textLightLabel
          ),
          CircularPercentIndicator(
            radius: 80,
            lineWidth: 4,
            percent: 0.7,
            progressColor: color_light_highlight_green,
            backgroundColor: color_light_shadow,
          ),
        ],
      ),
    );
  }
}
