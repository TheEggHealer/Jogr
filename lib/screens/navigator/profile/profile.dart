import 'package:flutter/material.dart';
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
    // TODO: implement initState
    super.initState();
    loadVersion();
  }

  @override
  Widget build(BuildContext context) {

    ud = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences(ud);
    db = DatabaseService(uid: ud.uid);

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
                      onTap: () {},
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
                      onTap: () {},
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
                              setState(() {
                                ud.lightMode = !val;
                                db.mergeUserDataFields({'light_mode': ud.lightMode});
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

                OutlineButton(
                  onPressed: () async {
                    await widget._auth.signOut();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                        'LOGOUT',
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            color: color_dark_text_dark
                        )
                    ),
                  ),
                  color: prefs.color_main,
                  splashColor: prefs.color_main,
                  highlightColor: prefs.color_main,
                  focusColor: prefs.color_main,
                  textColor: prefs.color_text_header,
                  borderSide: BorderSide(color: prefs.color_main),
                  highlightedBorderColor: prefs.color_main,
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                    OutlineButton(
                        onPressed: () { },
                        child: Text('RESET ACCOUNT'),
                        color: color_dark_error,
                        highlightColor: color_dark_error,
                        highlightedBorderColor: color_dark_error,
                        focusColor: color_dark_error,
                        hoverColor: color_dark_error,
                        textColor: color_dark_text_dark,
                        splashColor: color_dark_error,
                        borderSide: BorderSide(color: color_dark_error),
                      ),
                      OutlineButton(
                        onPressed: () { },
                        child: Text('REMOVE ACCOUNT'),
                        color: color_dark_error,
                        highlightColor: color_dark_error,
                        highlightedBorderColor: color_dark_error,
                        focusColor: color_dark_error,
                        hoverColor: color_dark_error,
                        textColor: color_dark_text_dark,
                        splashColor: color_dark_error,
                        borderSide: BorderSide(color: color_dark_error),
                      ),
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
