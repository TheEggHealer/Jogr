import 'package:flutter/material.dart';
import 'package:learningflutter2/services/auth.dart';
import 'package:learningflutter2/services/database.dart';
import 'package:learningflutter2/utils/models/user.dart';
import 'package:learningflutter2/utils/models/userdata.dart';

import 'package:provider/provider.dart';
import 'home.dart';

class Main extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamProvider<UserData>.value(
      value: DatabaseService(uid: user.uid).userDocument,
      child: Home(auth: _auth)
    );
  }
}