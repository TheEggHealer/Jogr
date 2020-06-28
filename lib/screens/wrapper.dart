import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/authenticate.dart';
import 'package:jogr/screens/home/main.dart';
import 'package:jogr/screens/splash/splash.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool splash = true;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    if(splash) {
      _timer = new Timer(Duration(seconds: 1), () =>
          setState(() {
            print('Splash end');
            splash = false;
            _timer.cancel();
          }));
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    if(!splash) {
      if (user == null)
        return Authenticate();
      else
        return MediaQuery.of(context).size.width > 100 ? Main() : SplashScreen();
    } else {
      return SplashScreen();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

