import 'package:flutter/material.dart';
import 'package:jogr/screens/home/profile/profile_item.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<bool> isSelected = [true, false];

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
                      selectedColor: color_text_highlight,
                      disabledColor: color_text_dark,
                      highlightColor: color_text_dark,
                      borderColor: color_text_dark,
                      color: color_text_dark,
                      fillColor: Colors.transparent,
                      onPressed: (selected) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == selected;
                          }
                        });
                      },
                      selectedBorderColor: color_text_highlight,
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      'LOGOUT',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          color: color_text_dark
                      )
                  ),
                ),
                color: color_text_highlight,
                splashColor: color_text_highlight,
                highlightColor: color_text_highlight,
                focusColor: color_text_highlight,
                textColor: color_text_dark,
                borderSide: BorderSide(color: color_text_highlight),
                highlightedBorderColor: color_text_highlight,
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
                      color: color_error,
                      highlightColor: color_error,
                      highlightedBorderColor: color_error,
                      focusColor: color_error,
                      hoverColor: color_error,
                      textColor: color_text_dark,
                      splashColor: color_error,
                      borderSide: BorderSide(color: color_error),
                    ),
                    OutlineButton(
                      onPressed: () { },
                      child: Text('REMOVE ACCOUNT'),
                      color: color_error,
                      highlightColor: color_error,
                      highlightedBorderColor: color_error,
                      focusColor: color_error,
                      hoverColor: color_error,
                      textColor: color_text_dark,
                      splashColor: color_error,
                      borderSide: BorderSide(color: color_error),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 60),
              Center(
                child: Column(
                  children: <Widget>[
                    Icon(CustomIcons.jogr, color: color_text_dark, size: 40,),
                    Text(
                      'Version 1.6.30 (200627)',
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'RobotoLight',
                        color: color_text_dark,
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
