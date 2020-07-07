import 'dart:math';

import 'package:flutter/material.dart';

const bool darkMode = true;

const Color color_background = darkMode ? Color(0xff151515) : Color(0xffffffff);
const Color color_card = darkMode ? Color(0xff1C1C1C): Color(0xffcccccc);
const Color color_text_highlight = darkMode ? Color(0xffE3C36F): Color(0xff1C1C1C);
const Color color_text_dark = darkMode ? Color(0xff555555) : Color(0xff444444);
const Color color_button_green = Color(0xff61B25F);
const Color color_error = Color(0xffAF3232);

const textStyleDark = TextStyle(
    fontSize: 12,
    fontFamily: 'Roboto',
    color: color_text_dark,
);
const textStyleDarkLight = TextStyle(
  color: color_text_dark,
  fontFamily: 'RobotoLight',
);
const textStyleDarkLightLarge = TextStyle(
  color: color_text_dark,
  fontFamily: 'Quicksand',
  fontSize: 20,
);
const textStyleHeader = TextStyle(
  fontSize: 28,
  fontFamily: 'Quicksand',
  color: color_text_highlight,
);
const textStyleHeaderLarge = TextStyle(
  fontSize: 35,
  fontFamily: 'Quicksand',
  color: color_text_highlight,
);
const textStyleHeaderSmall = TextStyle(
  fontSize: 20,
  fontFamily: 'Quicksand',
  color: color_text_highlight,
);

const Divider divider = Divider(
  color: Color(0xff555555),
  endIndent: 20,
  indent: 20,
  height: 60,
);



String roundedString(double value, int digits) {
  return rounded(value, digits).toString();
}

double rounded(double value, int digits) {
  return (value * pow(10, digits)).round().toDouble() / pow(10, digits);
}

String formatDate(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6, 8);
  return '$year-$month-$day';
}

class NoScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
