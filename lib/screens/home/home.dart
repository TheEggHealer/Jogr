import 'package:cool_nav/cool_nav.dart';
import 'package:flutter/material.dart';
import 'package:learningflutter2/screens/home/route/route_planner.dart';
import 'package:learningflutter2/screens/home/setup.dart';
import 'package:learningflutter2/screens/home/statistics/statistics.dart';
import 'package:learningflutter2/screens/splash/splash.dart';
import 'package:learningflutter2/services/auth.dart';
import 'package:learningflutter2/utils/constants.dart';
import 'package:learningflutter2/utils/custom_icons.dart';
import 'package:learningflutter2/utils/models/user.dart';
import 'package:learningflutter2/utils/models/userdata.dart';
import 'package:provider/provider.dart';

import 'home_widget.dart';

class Home extends StatefulWidget {
  final AuthService auth;

  Home({ this.auth });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int selectedPage = 0;
  PageController controller = PageController(
    initialPage: 0,
  );

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
    } else {
        return  Scaffold(
          backgroundColor: color_background,
          body: PageView(
            controller: controller,
            physics: NeverScrollableScrollPhysics(),
            children: [
              RoutePlanner(),
              SplashScreen(auth: widget.auth,),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Welcome back, ${userData.name}',
                        style: textStyleHeader,
                      ),
                    ),

                    Divider(
                      color: Color(0xff555555),
                      endIndent: 20,
                      indent: 20,
                      height: 60,
                    ),

                    HomeWidget(),

                    Divider(
                      color: Color(0xff555555),
                      endIndent: 20,
                      indent: 20,
                      height: 60,
                    ),

                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(
                        child: RawMaterialButton(
                          elevation: 30,
                          onPressed: () {},
                          child: Container(
                            child: Icon(Icons.directions_run, color: color_text_highlight, size: 30),
                            padding: EdgeInsets.all(30),
                          ),
                          shape: CircleBorder(side: BorderSide(width: 2, color: color_button_green)),
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          hoverColor: color_button_green,
                          focusColor: color_button_green,
                          highlightColor: color_button_green,
                          splashColor: color_button_green,
                        ),
                      ),
                    ),


                    /**                      //Sign out button
                        Center(
                        child: OutlineButton(
                        onPressed: () async {
                        await widget.auth.signOut();
                        },
                        child: Text('SIGN OUT'),
                        color: color_text_highlight,
                        splashColor: color_text_highlight,
                        highlightColor: color_text_highlight,
                        focusColor: color_text_highlight,
                        textColor: color_text_dark,
                        borderSide: BorderSide(color: color_text_highlight),
                        highlightedBorderColor: color_text_highlight,
                        ),
                        )    */

                    ],
                  ),
              ),
              Statistics(userData: userData, user: user),
              SplashScreen(auth: widget.auth,),
            ],
          ),
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
      );
    }

  }
}
