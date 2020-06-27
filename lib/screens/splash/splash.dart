import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/authenticate.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/loading.dart';

class SplashScreen extends StatelessWidget {

  AuthService auth;

  SplashScreen({this.auth});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: color_background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Jogr',
              style: TextStyle(
                fontFamily: 'Quicksand',
                color: color_text_dark,
                fontSize: 35,
              )
            ),
            SizedBox(height: 30),
            Container(
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    left: 4.0,
                    top: 8.0,
                    child: Icon(CustomIcons.jogr, color: Colors.black54, size: 180),
                  ),
                  Icon(CustomIcons.jogr, color: Color(0xff2B2B2B), size: 180),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text(
                'Loading...',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  color: color_text_dark,
                  fontSize: 20,
                )
            ),
            SizedBox(height: 30),
            OutlineButton(
              onPressed: () async {
                dynamic result = await auth.signOut();
              },
              child: Text(
                  'LOGOUT',
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      color: color_text_dark
                  )
              ),
              disabledBorderColor: color_text_dark,
              color: color_text_highlight,
              splashColor: color_text_highlight,
              highlightColor: color_text_highlight,
              focusColor: color_text_highlight,
              textColor: color_text_dark,
              borderSide: BorderSide(color: color_text_highlight),
              highlightedBorderColor: color_text_highlight,
            ),
            //Loading(),
          ],
        ),
      ),
    );

  }
}
