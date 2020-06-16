import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/start.dart';
import 'register.dart';
import 'login.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

enum STATE {
 START, LOGIN, REGISTER
}

class _AuthenticateState extends State<Authenticate> {

  STATE state = STATE.START;

  void toggleView(STATE state) {
    setState(() {
      this.state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(state == STATE.START) return Container(child: Start(toggleView: toggleView));
    else if(state == STATE.LOGIN) return Container(child: Login(toggleView: toggleView));
    else return Container(child: Register(toggleView: toggleView));
  }
}
