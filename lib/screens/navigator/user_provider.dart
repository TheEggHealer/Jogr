import 'package:background_locator/background_locator.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/screen_navigator.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';

import 'package:provider/provider.dart';
import 'home/home.dart';

class UserProvider extends StatelessWidget {

  final AuthService _auth = AuthService();

  bool tracking = false;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: user.uid).userDocument,
      child: ScreenNavigator(auth: _auth)
    );
  }
}