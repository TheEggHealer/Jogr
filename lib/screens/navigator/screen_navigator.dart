import 'package:background_locator/background_locator.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_item.dart';
import 'package:ff_navigation_bar/ff_navigation_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/home/home.dart';
import 'package:jogr/screens/navigator/profile/profile.dart';
import 'package:jogr/screens/navigator/route/route_planner.dart';
import 'package:jogr/screens/navigator/setup.dart';
import 'package:jogr/screens/navigator/statistics/statistics.dart';
import 'package:jogr/screens/run/run.dart';
import 'package:jogr/screens/splash/splash.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/file_manager.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'home/home_widget.dart';

class ScreenNavigator extends StatefulWidget {

  final AuthService auth;
  bool lightModePrefs;

  ScreenNavigator({this.auth, this.lightModePrefs}){
    print(lightModePrefs);
  }

  @override
  ScreenNavigatorState createState() => ScreenNavigatorState();
}

class ScreenNavigatorState extends State<ScreenNavigator> {

  bool running = false;

  int selectedPage = 2;
  PersistentTabController controller;

  Future<int> isTracking() async {
    await BackgroundLocator.initialize();
    bool tracking = await BackgroundLocator.isRegisterLocationUpdate();

    String fileContent = await FileManager.read();
    bool background = fileContent.isNotEmpty;

    if(tracking && background) return 1;
    else if(tracking && !background) return 2;
    else if(!tracking && background) return 3;
    else return 0;
  }

  @override
  void initState() {
    super.initState();
    isTracking().then((value) {
      if(value != 0) {
        setState(() {
          running = true;
        });
      } else {
        setState(() {
          running = false;
        });
      }
    });

    controller = PersistentTabController(
      initialIndex: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    UserData userData = Provider.of<UserData>(context);
    UserPreferences prefs = UserPreferences(userData != null ? userData.lightMode : false); //TODO: Handle loading screen when userData == null.
    bool setup = userData == null ? false : userData.raw['setup'];
    print(user.uid);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if(running) {
        //pushNewScreen(context, screen: RunScreen(userData, this, DatabaseService(uid: user.uid)));
        Navigator.push(context, MaterialPageRoute(builder: (context) => RunScreen(userData, this, DatabaseService(uid: user.uid))));
      }
    });

    if(userData == null) {
      return SplashScreen(auth: widget.auth, lightMode: widget.lightModePrefs,);
    } else if(!setup) {
      return Setup();
    } else {
      return PersistentTabView(
        controller: controller,
        screens: [
          RoutePlanner(user),
          SplashScreen(auth: widget.auth, lightMode: userData.lightMode,),
          Home(userData, this),
          Statistics(userData: userData, user: user),
          Profile(widget.auth),
        ],
        items: [
          PersistentBottomNavBarItem(icon: Icon(CustomIcons.map),
              title: 'Planner',
              inactiveColor: prefs.color_text_header,
              activeColor: prefs.color_main),
          PersistentBottomNavBarItem(icon: Icon(CustomIcons.goal),
              title: 'Goals',
              inactiveColor: prefs.color_text_header,
              activeColor: prefs.color_main),
          PersistentBottomNavBarItem(icon: Icon(CustomIcons.home),
              title: 'Home',
              inactiveColor: prefs.color_text_header,
              activeColor: prefs.color_main),
          PersistentBottomNavBarItem(icon: Icon(CustomIcons.stats),
              title: 'Statistics',
              inactiveColor: prefs.color_text_header,
              activeColor: prefs.color_main),
          PersistentBottomNavBarItem(icon: Icon(CustomIcons.profile),
              title: 'Profile',
              inactiveColor: prefs.color_text_header,
              activeColor: prefs.color_main),
        ],
        backgroundColor: prefs.color_background,

        confineInSafeArea: true,
        navBarStyle: NavBarStyle.style13,
      );
    }

  }

}
