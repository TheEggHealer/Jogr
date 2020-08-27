import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/login_scaffold.dart';
import 'package:jogr/utils/loading.dart';
import 'package:jogr/utils/user_preferences.dart';

import 'authenticate.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  bool lightMode;

  Register({ this.toggleView, this.lightMode });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  String email, password, confirm;
  String error = '';

  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500)
    );
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    UserPreferences prefs = UserPreferences(widget.lightMode);

    return Scaffold(
      body: LoginScaffold(
        lightMode: widget.lightMode,
        bodyClipped: true,
        appBar: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
                children: [
                  Center(
                    child: Icon(
                        CustomIcons.jogr,
                        color: prefs.color_highlight,
                        size: 70
                    ),
                  ),
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(-1, 0),
                      end: Offset(0, 0),
                    ).animate(CurvedAnimation(
                      parent: _controller,
                      curve: Curves.ease,
                    )),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: IconButton(
                        onPressed: (){
                          widget.toggleView(STATE.START);
                        },
                        icon: Icon(CustomIcons.back, color: prefs.color_highlight,),
                        iconSize: 30,
                      ),
                    ),
                  )
                ]
            ),
            Text(
              'JOGR',
              style: prefs.text_title,
            ),
          ],
        ),
          body: ScrollConfiguration(
            behavior: NoScrollGlow(),
            child: SingleChildScrollView(
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, 0.2),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 80),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: Text(
                            'Register',
                            style: prefs.text_header,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: textField(
                                validator: (val) => !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                  });
                                },
                                textColor: prefs.color_text_header,
                                activeColor: prefs.color_main,
                                borderColor: prefs.color_shadow,
                                errorColor: prefs.color_error,
                                helperText: 'Email',
                                icon: Icon(CustomIcons.mail, color: prefs.color_shadow),
                                textStyle: prefs.text_header_2,
                                borderRadius: 30
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: textField(
                                validator: (val) =>  val.length < 6 ? 'Password must be atleast 6 characters long.' : null,
                                onChanged: (val) {
                                  setState(() {
                                    password = val;
                                  });
                                },
                                textColor: prefs.color_text_header,
                                activeColor: prefs.color_main,
                                borderColor: prefs.color_shadow,
                                errorColor: prefs.color_error,
                                helperText: 'Password',
                                icon: Icon(CustomIcons.password, color: prefs.color_shadow),
                                textStyle: prefs.text_header_2,
                                borderRadius: 30
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: textField(
                                validator: (val) => password != val ? 'Passwords don\'t match.' : null,
                                onChanged: (val) {
                                  setState(() {
                                    confirm = val;
                                  });
                                },
                                textColor: prefs.color_text_header,
                                activeColor: prefs.color_main,
                                borderColor: prefs.color_shadow,
                                errorColor: prefs.color_error,
                                helperText: 'Repeat password',
                                icon: Icon(CustomIcons.password, color: prefs.color_shadow),
                                textStyle: prefs.text_header_2,
                                borderRadius: 30
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        SpinKitChasingDots(
                          color: loading ? prefs.color_shadow : Colors.transparent,
                          size: 20,
                        ),
                        Center(
                          child: Text(
                            error,
                            style: TextStyle(
                              fontFamily: 'RobotoLight',
                              color: color_dark_error,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: button(
                              onTap: () async {
                                if(_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth.registerEmailPassword(email, password);
                                  if(result is String) {
                                    setState(() {
                                      error = result;
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              text: 'Sign in',
                              textColor: prefs.color_text_header,
                              borderColor: prefs.color_main,
                              borderRadius: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
    );

    /**
    return Scaffold(
      backgroundColor: color_dark_background,
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
                    'Register',
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'Quicksand',
                      color: color_dark_text_highlight,
                    ),
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
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  color: color_dark_text_dark
                              )
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            validator: (val) => !(val.isNotEmpty && val.contains('@') && val.split('@')[1].contains('.')) ? 'Enter a valid email.' : null,
                            onChanged: (val) {
                              setState(() {
                                email = val;
                              });
                            },
                            cursorColor: color_dark_text_highlight,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_highlight)),
                              border: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
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
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  color: color_dark_text_dark
                              )
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
                            cursorColor: color_dark_text_highlight,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_highlight)),
                              border: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
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
                              '• REPEAT PASSWORD',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Roboto',
                                  color: color_dark_text_dark
                              )
                          ),
                          SizedBox(height: 5,),
                          TextFormField(
                            validator: (val) => password != val ? 'Passwords don\'t match.' : null,
                            onChanged: (val) {
                              setState(() {
                                confirm = val;
                              });
                            },
                            obscureText: true,
                            cursorColor: color_dark_text_highlight,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
                              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_highlight)),
                              border: OutlineInputBorder(borderSide: BorderSide(color: color_dark_text_dark)),
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
                        color: color_dark_error,
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
                              disabledBorderColor: color_dark_text_dark,
                              color: color_dark_text_highlight,
                              splashColor: color_dark_text_highlight,
                              highlightColor: color_dark_text_highlight,
                              focusColor: color_dark_text_highlight,
                              textColor: color_dark_text_dark,
                              borderSide: BorderSide(color: color_dark_text_highlight),
                              highlightedBorderColor: color_dark_text_highlight,
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
                                  dynamic result = await _auth.registerEmailPassword(email, password);
                                  if(result is String) {
                                    setState(() {
                                      error = result;
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                  'REGISTER',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: 'Roboto',
                                      color: color_dark_text_dark
                                  )
                              ),
                              disabledBorderColor: color_dark_text_dark,
                              color: color_dark_text_highlight,
                              splashColor: color_dark_text_highlight,
                              highlightColor: color_dark_text_highlight,
                              focusColor: color_dark_text_highlight,
                              textColor: color_dark_text_dark,
                              borderSide: BorderSide(color: color_dark_text_highlight),
                              highlightedBorderColor: color_dark_text_highlight,
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
        */
  }

}
