import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/authenticate.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/gradient_icon.dart';
import 'package:jogr/utils/custom_widgets/login_scaffold.dart';
import 'package:jogr/utils/user_preferences.dart';

class Start extends StatefulWidget {

  final Function toggleView;
  bool lightMode;

  Start({ this.toggleView, this.lightMode });

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> with SingleTickerProviderStateMixin {

  final AuthService _auth = AuthService();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences(widget.lightMode);

    return Scaffold(
      body: LoginScaffold(
        lightMode: widget.lightMode,
        appBar: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CustomIcons.jogr,
              color: prefs.color_highlight,
              size: 70
            ),
            Text(
              'JOGR',
              style: prefs.text_title,
            ),
          ],
        ),
        body: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 0.1),
            end: Offset(0, 0),
          ).animate(CurvedAnimation(
              parent: _controller,
              curve: Curves.ease
          )),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0,
              end: 1,
            ).animate(CurvedAnimation(
              parent: _controller,
              curve: Curves.ease,
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Spacer(flex: 5),
                Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome,',
                          style: prefs.text_header,
                        ),
                        Text(
                          'Sign in to continue',
                          style: prefs.text_header_2,
                        ),
                      ],
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: button(
                        onTap: () async {
                          dynamic result = await _auth.signInGoogle();
                          if(result == null) {
                            print('error signing in');
                          } else {
                            print('signed in');
                            print(result.uid);
                          }
                        },
                        image: Image(image: AssetImage('assets/google_logo.png'), width: 30, height: 30),
                        text: 'Continue with Google',
                        textColor: prefs.color_text_header,
                        borderColor: prefs.color_main,
                        borderRadius: 30,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Flexible(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: button(
                        onTap: () {
                          widget.toggleView(STATE.LOGIN);
                        },
                        text: 'Sing in',
                        textColor: prefs.color_text_header,
                        borderColor: prefs.color_main,
                        borderRadius: 30,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: prefs.color_shadow,
                        endIndent: 10,
                        indent: 20,
                      ),
                    ),
                    Center(
                      child: Text(
                        'Or',
                        style: prefs.text_header_2,
                      ),
                    ),
                    Expanded(

                      child: Divider(
                        color: prefs.color_shadow,
                        indent: 10,
                        endIndent: 20,
                      ),
                    ),
                  ],
                ),
                Spacer(flex: 1),
                Flexible(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: button(
                        onTap: () async {
                          widget.toggleView(STATE.REGISTER);
                        },
                        text: 'Register',
                        textColor: prefs.color_text_header,
                        borderColor: prefs.color_main,
                        borderRadius: 30,
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 8),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      '© Copyright Jonathan Runeke 2020',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'RobotoLight',
                        color: color_dark_text_dark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );

    /**
    return Scaffold(
      backgroundColor: color_dark_background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Title
            Column(
              children: [
                SizedBox(height: 100),
                Icon(CustomIcons.jogr, color: color_dark_text_highlight, size: 60),
                Text(
                  'JOGR',
                  style: TextStyle(
                    fontSize: 90,
                    fontFamily: 'Dosis',
                    color: color_dark_text_dark,
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
                                  color: color_dark_text_dark
                              )
                          ),
                        ],
                      ),
                    ),
                    color: color_dark_text_highlight,
                    splashColor: color_dark_text_highlight,
                    highlightColor: color_dark_text_highlight,
                    focusColor: color_dark_text_highlight,
                    textColor: color_dark_text_dark,
                    borderSide: BorderSide(color: color_dark_text_highlight),
                    highlightedBorderColor: color_dark_text_highlight,
                  ),
                ),

                SizedBox(height:10),


                Text(
                    'OR',
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Roboto',
                        color: color_dark_text_dark
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
                                        color: color_dark_text_dark
                                    )
                                ),
                              ],
                            ),
                          ),
                          color: color_dark_text_highlight,
                          splashColor: color_dark_text_highlight,
                          highlightColor: color_dark_text_highlight,
                          focusColor: color_dark_text_highlight,
                          textColor: color_dark_text_dark,
                          borderSide: BorderSide(color: color_dark_text_highlight),
                          highlightedBorderColor: color_dark_text_highlight,
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
                                        color: color_dark_text_dark
                                    )
                                ),
                              ],
                            ),
                          ),
                          color: color_dark_text_highlight,
                          splashColor: color_dark_text_highlight,
                          highlightColor: color_dark_text_highlight,
                          focusColor: color_dark_text_highlight,
                          textColor: color_dark_text_dark,
                          borderSide: BorderSide(color: color_dark_text_highlight),
                          highlightedBorderColor: color_dark_text_highlight,
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
                    color: color_dark_text_dark,
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
        */
  }
}
