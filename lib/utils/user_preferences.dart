import 'dart:core';
import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/userdata.dart';

class UserPreferences {

  UserData userData;
  bool lightMode;

  static bool prefsLightMode = true;

  UserPreferences(this.lightMode);

  //--------------------Colors

  Color get color_background {
    if(lightMode) return color_light_background;
    else return color_dark_background_temp;
  }

  Color get color_main {
    if(lightMode) return color_light_main;
    else return color_dark_main;
  }

  Color get color_text_header {
    if(lightMode) return color_light_text_header;
    else return color_dark_text_header;
  }

  Color get color_text_background {
    if(lightMode) return color_light_text_background;
    else return color_dark_text_background;
  }

  Color get color_highlight {
    if(lightMode) return color_light_highlight;
    else return color_dark_highlight;
  }

  Color get color_secondary_highlight {
    if(lightMode) return color_light_secondary_highlight;
    else return color_dark_secondary_highlight;
  }

  Color get color_shadow {
    if(lightMode) return color_light_shadow;
    else return color_dark_shadow;
  }

  Color get color_splash {
    if(lightMode) return color_light_splash;
    else return color_dark_splash;
  }

  Color get color_card {
    if(lightMode) return color_light_card;
    else return color_dark_card;
  }

  Color get color_error {
    if(lightMode) return color_light_error;
    else return color_dark_error;
  }

  //--------------------Text Styles

  TextStyle get text_header {
    if(lightMode) return textLightHeader;
    else return textDarkHeader;
  }

  TextStyle get text_header_2 {
    if(lightMode) return textLightHeader2;
    else return textDarkHeader2;
  }

  TextStyle get text_header_invert_bold {
    if(lightMode) return textLightHeaderInvertBold;
    else return textDarkHeaderInvertBold;
  }

  TextStyle get text_header_invert_2 {
    if(lightMode) return textLightHeaderInvert2;
    else return textDarkHeaderInvert2;
  }

  TextStyle get text_highlight {
    if(lightMode) return textLightHeaderInvert;
    else return textDarkHeaderInvert;
  }

  TextStyle get text_background {
    if(lightMode) return textLightBackground;
    else return textDarkBackground;
  }

  TextStyle get text_label {
    if(lightMode) return textLightLabel;
    else return textDarkLabel;
  }

  TextStyle get text_goal {
    if(lightMode) return textLightGoal;
    else return textDarkGoal;
  }

  TextStyle get text_title {
    if(lightMode) return textLightTitle;
    else return textDarkTitle;
  }

  //--------------------Gradients

  LinearGradient get gradient_main {
    if(lightMode) return light_gradient_main;
    else return dark_gradient_main;
  }

  LinearGradient get gradient_run_button {
    if(lightMode) return light_gradient_run_button;
    else return dark_gradient_run_button;
  }

  LinearGradient get gradient_title {
    if(lightMode) return light_gradient_main;
    else return dark_gradient_title;
  }

  //--------------------Map Styles

  String get map_theme {
    if(lightMode) return map_theme_light;
    else return map_theme_dark;
  }


}