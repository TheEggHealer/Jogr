import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/profile/profile_item.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';

class Profile extends StatefulWidget {

  AuthService _auth;

  Profile(this._auth);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<bool> isSelected = [true, false];
  String version = "---";

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

    return ScrollConfiguration(
      behavior: NoScrollGlow(),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 60),
          child: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Profile',
                  style: textStyleHeader,
                ),
              ),
              divider,
              ProfileItem(
                  title: 'Name:',
                  data: 'Jonathan',
                  label: ''
              ),
              ProfileItem(
                  title: 'Weight:',
                  data: '59,6',
                  label: 'kg'
              ),
              ProfileItem(
                  title: 'Age:',
                  data: '20',
                  label: 'years'
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Settings',
                  style: textStyleHeader,
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Distance unit:',
                      style: textStyleDarkLightLarge,
                    ),
                    SizedBox(width: 30),
                    ToggleButtons(
                      isSelected: isSelected,
                      borderRadius: BorderRadius.circular(5),
                      selectedColor: color_dark_text_highlight,
                      disabledColor: color_dark_text_dark,
                      highlightColor: color_dark_text_dark,
                      borderColor: color_dark_text_dark,
                      color: color_dark_text_dark,
                      fillColor: Colors.transparent,
                      onPressed: (selected) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == selected;
                          }
                        });
                      },
                      selectedBorderColor: color_dark_text_highlight,
                      borderWidth: 1,
                      children: [
                        Text('km'),
                        Text('mi'),
                      ],
                    )
                  ],
                ),
              ),
              divider,
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
                color: color_dark_text_highlight,
                splashColor: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                borderSide: BorderSide(color: color_dark_text_highlight),
                highlightedBorderColor: color_dark_text_highlight,
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
              SizedBox(height:20),
            ],
          ),
        ),
      ),
    );
  }
}
