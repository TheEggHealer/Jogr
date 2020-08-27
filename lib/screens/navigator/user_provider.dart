import 'package:battery_optimization/battery_optimization.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';

import 'package:provider/provider.dart';

class UserProvider extends StatelessWidget {

  bool lightModePrefs;
  final AuthService _auth = AuthService();

  UserProvider({this.lightModePrefs}) {
    print('Userp $lightModePrefs');
  }

  bool tracking = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    BatteryOptimization.isIgnoringBatteryOptimizations().then((onValue) {
      if(!onValue) {
        //TODO: Display a dialog asking for permission.
        BatteryOptimization.openBatteryOptimizationSettings();
      }
    });

    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: user.uid).userDocument,
      child: ScreenNavigator(auth: _auth, lightModePrefs: lightModePrefs,)
    );
  }
}