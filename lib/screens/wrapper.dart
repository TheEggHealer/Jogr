import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learningflutter2/screens/authenticate/authenticate.dart';
import 'package:learningflutter2/screens/home/main.dart';
import 'package:learningflutter2/screens/splash/splash.dart';
import 'package:learningflutter2/utils/models/user.dart';
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
        return Main();
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

