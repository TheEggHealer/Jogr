import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jogr/screens/navigator/profile/profile_item.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/custom_card.dart';
import 'package:jogr/utils/custom_widgets/custom_scaffold.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {

  AuthService _auth;

  Profile(this._auth);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<bool> isSelected = [true, false];
  String version = "---";

  DatabaseService db;
  UserData ud;

  void loadVersion() async {
    print('Loading version');
    version = await VERSION;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  @override
  Widget build(BuildContext context) {

    ud = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences(ud.lightMode);
    db = DatabaseService(uid: ud.uid);

    double logoutWidth = MediaQuery.of(context).size.width * 0.4;
    double logoutHeight = logoutWidth * 0.4;

    return CustomScaffold(
      userData: ud,
      appBar: Padding(
        padding: const EdgeInsets.only(left: 30.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Profile',
            style: prefs.text_header_invert_bold,
          ),
        ),
      ),
      body: ScrollConfiguration(
        behavior: NoScrollGlow(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Text(
                  ud.name,
                  style: prefs.text_header,
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomCard(
                      userData: ud,
                      onTap: notImplemented,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 80,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(CustomIcons.burn, color: prefs.color_highlight),
                              Text(ud.weight.toString(), style: prefs.text_highlight,),
                              Text('kg', style: prefs.text_label,)
                            ]
                          ),
                        ),
                      ),
                    ),
                    CustomCard(
                      userData: ud,
                      onTap: notImplemented,
                      child: Container(
                        constraints: BoxConstraints(
                          minWidth: 80,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                              children: [
                                Icon(CustomIcons.timer, color: prefs.color_highlight),
                                Text(ud.age.toString(), style: prefs.text_highlight,),
                                Text('age', style: prefs.text_label,)
                              ]
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: prefs.color_shadow,
                  height: 50,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: prefs.text_header,
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Night mode',
                            style: prefs.text_header_2,
                          ),
                          Switch(
                            activeColor: prefs.color_main,
                            inactiveThumbColor: prefs.color_main,
                            inactiveTrackColor: prefs.color_shadow,
                            onChanged: (val) async {
                              SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
                              setState(() {
                                ud.lightMode = !val;
                                db.mergeUserDataFields({'light_mode': ud.lightMode});
                                sharedPrefs.setBool('lightMode', ud.lightMode);
                                UserPreferences.prefsLightMode = ud.lightMode;
                                print('Prefs: ${sharedPrefs.getBool('lightMode')}');
                              });
                            },
                            value: !ud.lightMode,

                          )
                        ],
                      )
                    ],
                  ),
                ),
                Divider(
                  color: prefs.color_shadow,
                  height: 50,
                ),

                SizedBox(
                  width: logoutWidth,
                  height: logoutHeight,
                  child: button(
                    onTap: () async {
                      await widget._auth.signOut();
                    },
                    borderRadius: logoutHeight / 2,
                    text: 'Logout',
                    textColor: prefs.color_text_header,
                    borderColor: prefs.color_main
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: button(
                          onTap: notImplemented, //TODO implement
                          text: 'Clear Data',
                          borderColor: prefs.color_error,
                          textColor: prefs.color_text_header,
                        ),
                      ),
                      Spacer(flex: 1),
                      Expanded(
                        flex: 6,
                        child: button(
                          onTap: notImplemented, //TODO implement
                          text: 'Remove Account',
                          borderColor: prefs.color_error,
                          textColor: prefs.color_text_header,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 60),
                Center(
                  child: Column(
                    children: <Widget>[
                      Icon(CustomIcons.jogr, color: color_dark_text_dark, size: 40,),
                      Text(
                        version,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'RobotoLight',
                          color: color_dark_text_dark,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }


}
