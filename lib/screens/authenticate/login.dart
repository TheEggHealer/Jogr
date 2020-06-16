import 'package:flutter/material.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/loading.dart';

import 'authenticate.dart';

class Login extends StatefulWidget {

  final Function toggleView;

  Login({ this.toggleView });

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email, password;
  String error = '';

  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: color_background,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Center(
                    child: Text(
                      'Login',
                      style: textStyleHeaderLarge,
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '• EMAIL',
                                style: textStyleDark
                            ),
                            SizedBox(height: 5,),
                            TextFormField(
                              validator: (val) =>  !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                              cursorColor: color_text_highlight,
                              decoration: InputDecoration(
                                filled: false,
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_text_dark)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_text_highlight)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: color_text_dark)),
                              ),
                              style: textStyleDarkLight,
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '• PASSWORD',
                                style: textStyleDark
                            ),
                            SizedBox(height: 5,),
                            TextFormField(
                              validator: (val) => val.length < 6 ? 'Password must be atleast 6 characters long.' : null,
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                              obscureText: true,
                              cursorColor: color_text_highlight,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_text_dark)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_text_highlight)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: color_text_dark)),
                              ),
                              style: textStyleDarkLight,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  AnimatedOpacity(
                    opacity: loading ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: Loading(),
                  ),

                  Column(
                    children: [
                      Text(
                        error,
                        style: TextStyle(
                          fontFamily: 'RobotoLight',
                          color: color_error,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 60,
                              child: OutlineButton(
                                onPressed: () {
                                  widget.toggleView(STATE.START);
                                },
                                child: Icon(
                                  CustomIcons.back,
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
                            ),
                          ),
                          SizedBox(width: 20,),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 60,
                              child: OutlineButton(
                                onPressed: () async {
                                  if(_formKey.currentState.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth.loginEmailPassword(email, password);
                                    if(result is String) {
                                      setState(() {
                                        error = result;
                                        loading = false;
                                      });
                                    }
                                  }
                                },
                                child: Text(
                                    'LOGIN',
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

}
