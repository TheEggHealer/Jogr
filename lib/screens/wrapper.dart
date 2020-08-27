import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jogr/screens/authenticate/authenticate.dart';
import 'package:jogr/screens/splash/splash.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'navigator/user_provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool splash = true;
  bool lightMode = true;
  SharedPreferences sharedPreferences;

  Timer _timer;

  @override
  void initState() {
    super.initState();
    loadMapThemes();

    if(splash) {
      _timer = new Timer(Duration(seconds: 1), () =>
        setState(() {
          print('Splash end');
          splash = false;
          _timer.cancel();
        })
      );
    }

    readPrefs();
  }

  Future<void> readPrefs() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      UserPreferences.prefsLightMode = (sharedPreferences.getBool('lightMode') ?? true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    print('prefs li: ${UserPreferences.prefsLightMode}');

    if(!splash) {
      if (user == null) {
        return Authenticate(lightMode: (sharedPreferences.getBool('lightMode') ?? true));
      }
      else {
        return MediaQuery.of(context).size.width > 100 ? UserProvider(lightModePrefs: (sharedPreferences.getBool('lightMode') ?? true),) : SplashScreen(lightMode: (sharedPreferences.getBool('lightMode') ?? true),);
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

