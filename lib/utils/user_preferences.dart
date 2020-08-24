import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/userdata.dart';

class UserPreferences {

  UserData _userData;

  UserPreferences(this._userData);

  //--------------------Colors

  Color get color_background {
    if(_userData.lightMode) return color_light_background;
    else return color_dark_background_temp;
  }

  Color get color_main {
    if(_userData.lightMode) return color_light_main;
    else return color_dark_main;
  }

  Color get color_text_header {
    if(_userData.lightMode) return color_light_text_header;
    else return color_dark_text_header;
  }

  Color get color_text_background {
    if(_userData.lightMode) return color_light_text_background;
    else return color_dark_text_background;
  }

  Color get color_highlight {
    if(_userData.lightMode) return color_light_highlight;
    else return color_dark_highlight;
  }

  Color get color_secondary_highlight {
    if(_userData.lightMode) return color_light_secondary_highlight;
    else return color_dark_secondary_highlight;
  }

  Color get color_shadow {
    if(_userData.lightMode) return color_light_shadow;
    else return color_dark_shadow;
  }

  Color get color_splash {
    if(_userData.lightMode) return color_light_splash;
    else return color_dark_splash;
  }

  Color get color_card {
    if(_userData.lightMode) return color_light_card;
    else return color_dark_card;
  }

  Color get color_error {
    if(_userData.lightMode) return color_light_error;
    else return color_dark_error;
  }

  //--------------------Text Styles

  TextStyle get text_header {
    if(_userData.lightMode) return textLightHeader;
    else return textDarkHeader;
  }

  TextStyle get text_header_2 {
    if(_userData.lightMode) return textLightHeader2;
    else return textDarkHeader2;
  }

  TextStyle get text_header_invert_bold {
    if(_userData.lightMode) return textLightHeaderInvertBold;
    else return textDarkHeaderInvertBold;
  }

  TextStyle get text_header_invert_2 {
    if(_userData.lightMode) return textLightHeaderInvert2;
    else return textDarkHeaderInvert2;
  }

  TextStyle get text_highlight {
    if(_userData.lightMode) return textLightHeaderInvert;
    else return textDarkHeaderInvert;
  }

  TextStyle get text_background {
    if(_userData.lightMode) return textLightBackground;
    else return textDarkBackground;
  }

  TextStyle get text_label {
    if(_userData.lightMode) return textLightLabel;
    else return textDarkLabel;
  }

  TextStyle get text_goal {
    if(_userData.lightMode) return textLightGoal;
    else return textDarkGoal;
  }

  //--------------------Gradients

  LinearGradient get gradient_main {
    if(_userData.lightMode) return light_gradient_main;
    else return dark_gradient_main;
  }

  LinearGradient get gradient_run_button {
    if(_userData.lightMode) return light_gradient_run_button;
    else return dark_gradient_run_button;
  }

  //--------------------Map Styles

  String get map_theme {
    if(_userData.lightMode) return map_theme_light;
    else return map_theme_dark;
  }


}