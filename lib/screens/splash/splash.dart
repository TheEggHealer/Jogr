import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/gradient_icon.dart';
import 'package:jogr/utils/user_preferences.dart';

class SplashScreen extends StatelessWidget {

  AuthService auth;
  bool lightMode;

  SplashScreen({this.auth, this.lightMode});

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences(lightMode);

    return Scaffold(
      backgroundColor: prefs.color_background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GradientIcon(
              icon: CustomIcons.jogr,
              gradient: prefs.gradient_title,
              size: 80,
            ),
            GradientText(
              'JOGR',
              gradient: prefs.gradient_title,
              style: prefs.text_title,
            )
          ],
        ),
      ),
    );

  }
}
