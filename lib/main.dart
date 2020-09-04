import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/wrapper.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:provider/provider.dart';

void main() {
  Paint.enableDithering = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {

        if(snapshot.hasError) {
          print('============== ERROR INITIALIZING FIREBASE ================');
        }

        if(snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
              home: Wrapper(),
              theme: ThemeData(
                  accentColor: color_dark_text_dark
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}


