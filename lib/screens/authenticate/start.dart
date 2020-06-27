import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/authenticate.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';

class Start extends StatefulWidget {

  final Function toggleView;

  Start({ this.toggleView });

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Title
            Column(
              children: [
                SizedBox(height: 100),
                Icon(CustomIcons.jogr, color: color_text_highlight, size: 60),
                Text(
                  'JOGR',
                  style: TextStyle(
                    fontSize: 90,
                    fontFamily: 'Dosis',
                    color: color_text_dark,
                  ),
                ),
              ],
            ),


            //Buttons
            Column(
              children: [
                SizedBox(height: 60),
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: OutlineButton(
                    onPressed: () async {
                      dynamic result = await _auth.signInGoogle();
                      if(result == null) {
                        print('error signing in');
                      } else {
                        print('signed in');
                        print(result.uid);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(image: AssetImage('assets/google_logo.png'), width: 40, height: 40),
                          Text(
                              'CONTINUE WITH GOOGLE',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  color: color_text_dark
                              )
                          ),
                        ],
                      ),
                    ),
                    color: color_text_highlight,
                    splashColor: color_text_highlight,
                    highlightColor: color_text_highlight,
                    focusColor: color_text_highlight,
                    textColor: color_text_dark,
                    borderSide: BorderSide(color: color_text_highlight),
                    highlightedBorderColor: color_text_highlight,
                  ),
                ),

                SizedBox(height:10),


                Text(
                    'OR',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: color_text_dark
                    )
                ),




                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlineButton(
                          onPressed: () {
                            widget.toggleView(STATE.LOGIN);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        color: color_text_dark
                                    )
                                ),
                              ],
                            ),
                          ),
                          color: color_text_highlight,
                          splashColor: color_text_highlight,
                          highlightColor: color_text_highlight,
                          focusColor: color_text_highlight,
                          textColor: color_text_dark,
                          borderSide: BorderSide(color: color_text_highlight),
                          highlightedBorderColor: color_text_highlight,
                        ),
                      ),
                      SizedBox(width: 30,),
                      Expanded(
                        child: OutlineButton(
                          onPressed: () async {
                            widget.toggleView(STATE.REGISTER);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    'REGISTER',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        color: color_text_dark
                                    )
                                ),
                              ],
                            ),
                          ),
                          color: color_text_highlight,
                          splashColor: color_text_highlight,
                          highlightColor: color_text_highlight,
                          focusColor: color_text_highlight,
                          textColor: color_text_dark,
                          borderSide: BorderSide(color: color_text_highlight),
                          highlightedBorderColor: color_text_highlight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //Copyright
            Column(
              children: [
                Text(
                  '© Copyright Jonathan Runeke 2020',
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'RobotoLight',
                    color: color_text_dark,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      )
    );
  }
}
