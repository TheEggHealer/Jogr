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
import 'package:provider/provider.dart';

import 'home/home_widget.dart';

class ScreenNavigator extends StatefulWidget {

  final AuthService auth;

  ScreenNavigator({this.auth});

  @override
  ScreenNavigatorState createState() => ScreenNavigatorState();
}

class ScreenNavigatorState extends State<ScreenNavigator> {

  bool running = false;

  int selectedPage = 2;
  PageController controller = PageController(
    initialPage: 2,
  );

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
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    UserData userData = Provider.of<UserData>(context);
    bool setup = userData == null ? false : userData.raw['setup'];
    print(user.uid);

    if(userData == null) {
      return SplashScreen(auth: widget.auth,);
    } else if(!setup) {
      return Setup();
    } else if(running) {
      return RunScreen(userData, this, DatabaseService(uid: user.uid));
    } else {
      return  Scaffold(
        backgroundColor: color_background,
        resizeToAvoidBottomPadding: false,
        body: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            RoutePlanner(user),
            SplashScreen(auth: widget.auth,),
            Home(userData, this),
            Statistics(userData: userData, user: user),
            Profile(widget.auth),
          ],
        ),
        bottomNavigationBar: FFNavigationBar(

          theme: FFNavigationBarTheme(
            barBackgroundColor: color_background,
            selectedItemBorderColor: color_card,
            selectedItemBackgroundColor: color_background,
            selectedItemIconColor: color_text_highlight,
            selectedItemLabelColor: color_text_highlight,
            unselectedItemIconColor: color_text_dark,
            unselectedItemLabelColor: color_text_dark,
            selectedItemTextStyle: TextStyle(
                fontFamily: 'Quicksand'
            ),
            showSelectedItemShadow: false,
          ),
          selectedIndex: selectedPage,
          items: [
            FFNavigationBarItem(iconData: CustomIcons.route, label: 'Planner'),
            FFNavigationBarItem(iconData: CustomIcons.goal, label: 'Goals'),
            FFNavigationBarItem(iconData: CustomIcons.home, label: 'Home'),
            FFNavigationBarItem(iconData: CustomIcons.stats, label: 'Statistics'),
            FFNavigationBarItem(iconData: CustomIcons.profile, label: 'Profile'),
          ],
          onSelectTab: (index) {
            setState(() {
              selectedPage = index;
              controller.jumpToPage(index);
            });
          },
        ),
        /**
            bottomNavigationBar: SpotlightBottomNavigationBar(
            items: [
            SpotlightBottomNavigationBarItem(icon: CustomIcons.route),
            SpotlightBottomNavigationBarItem(icon: CustomIcons.gps),
            SpotlightBottomNavigationBarItem(icon: CustomIcons.home),
            SpotlightBottomNavigationBarItem(icon: CustomIcons.stats),
            SpotlightBottomNavigationBarItem(icon: CustomIcons.profile),
            ],
            iconSize: 30,
            unselectedItemColor: color_text_dark,
            currentIndex: selectedPage,
            selectedItemColor: color_text_highlight,
            backgroundColor: Colors.transparent,
            onTap: (index) {
            setState(() {
            selectedPage = index;
            controller.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
            },
            ),
         */
      );
    }

  }

}
