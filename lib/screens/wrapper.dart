import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/authenticate.dart';
import 'package:jogr/screens/splash/splash.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:provider/provider.dart';

import 'navigator/user_provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool splash = true;
  bool lightMode = true;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    loadEssentials();

    if(splash) {
      _timer = new Timer(Duration(seconds: 1), () =>
        setState(() {
          print('Splash end');
          splash = false;
          _timer.cancel();
        })
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(!splash) {
      if (user == null) {
        return Authenticate(lightMode: (sharedPreferences.getBool('lightMode') ?? true));
      }
      else {
        print('Loading dir from shared: ${sharedPreferences.getBool('lightMode')}');
        return UserProvider(lightModePrefs: (sharedPreferences.getBool('lightMode') ?? true),);
      }
    } else {
      return SplashScreen(lightMode: sharedPreferences == null ? true : (sharedPreferences.getBool('lightMode') ?? true),);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

