import 'package:flutter/material.dart';
import 'package:jogr/screens/wrapper.dart';
import 'package:jogr/services/auth.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
        theme: ThemeData(
          accentColor: color_text_dark
        ),
      ),
    );
  }
}


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff151515),

      body: Wrapper(),

      /** Firebase example
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('jogdev')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Card(
                          child: Column(
                            children: [
                              Text('${document['dist']}'),
                              Text('${document['test']}'),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
      */

      /**
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 60, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Welcome back, Jonathan',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Quicksand',
                  color: Color(0xffE3C36F),

                ),
              ),
            ),

            Divider(
              color: Color(0xff555555),
              endIndent: 20,
              indent: 20,
              height: 60,
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• LAST RUN',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      color: Color(0xff555555)
                    )
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeComponent(
                        icon: Icons.directions_run,
                        data: '3,4',
                        label: 'km',
                      ),
                      HomeComponent(
                        icon: Icons.timer,
                        data: '19:48',
                        label: 'mm:ss',
                      ),
                      HomeComponent(
                        icon: Icons.flash_on,
                        data: '137',
                        label: 'cal',
                      )
                    ],
                  ),

                  SizedBox(height: 30),

                  Text(
                      '• NEXT RUN',
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Roboto',
                          color: Color(0xff555555)
                      )
                  ),

                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      HomeComponent(
                        icon: null,
                        data: '2',
                        label: 'days left',
                      ),
                      HomeComponent(
                        icon: Icons.directions_walk,
                        data: '3,4',
                        label: 'km',
                      ),
                      OutlineButton(
                        onPressed: () {},
                        child: Text('SEE ROUTE'),
                        color: Color(0xffE3C36F),
                        highlightColor: Color(0xffE3C36F),
                        highlightedBorderColor: Color(0xffE3C36F),
                        focusColor: Color(0xffE3C36F),
                        hoverColor: Color(0xffE3C36F),
                        textColor: Color(0xff555555),
                        borderSide: BorderSide(color: Color(0xffE3C36F)),
                      )
                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.cloud, color: Color(0xffE3C36F)),
                      SizedBox(width: 10),
                      Text(
                        '18',
                        style: TextStyle(
                          fontSize: 28,
                          fontFamily: 'Quicksand',
                          color: Color(0xffE3C36F),
                        ),
                      ),

                      SizedBox(width: 10),

                      Text(
                          'cloudy forecast',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            color: Color(0xff555555),
                          )
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Center(
                    child: OutlineButton(
                      onPressed: () {},
                      child: Text('CHANGE PLAN'),
                      color: Color(0xffE3C36F),
                      highlightColor: Color(0xffE3C36F),
                      highlightedBorderColor: Color(0xffE3C36F),
                      focusColor: Color(0xffE3C36F),
                      hoverColor: Color(0xffE3C36F),
                      textColor: Color(0xff555555),
                      borderSide: BorderSide(color: Color(0xffE3C36F)),
                    ),
                  )
                ]
              ),
            ),

            Divider(
              color: Color(0xff555555),
              endIndent: 20,
              indent: 20,
              height: 60,
            ),

            Center(
              child: RawMaterialButton(
                elevation: 30,
                onPressed: () {},
                child: Container(
                  child: Icon(Icons.directions_run, color: Color(0xffE3C36F), size: 30),
                  padding: EdgeInsets.all(30),
                ),
                shape: CircleBorder(side: BorderSide(width: 2, color: Color(0xff61B25F))),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                hoverColor: Color(0xff61B25F),
                focusColor: Color(0xff61B25F),
                highlightColor: Color(0xff61B25F),
                splashColor: Color(0xff61B25F),
              ),
            ),

            SizedBox(height: 20),

            Divider(
              color: Color(0xff555555),
              endIndent: 20,
              indent: 20,
            ),
          ],
        ),
      ),
          */
    );
  }
}

_getNavBarItems() {
  return <BottomNavigationBarItem> [
    BottomNavigationBarItem(
        icon: Icon(Icons.aspect_ratio),
        title: Text('a'),
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.gps_fixed),
        title: Text('b')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text('c')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.disc_full),
        title: Text('d')
    ),
    BottomNavigationBarItem(
        icon: Icon(Icons.directions),
        title: Text('e')
    ),
  ];
}

_getNavBar(BuildContext context) {
  return Container(
    height: 55,
    child: Stack(
      children: <Widget>[
        Positioned(
          bottom: 30,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _getNavBarItem(Icons.directions),
              _getNavBarItem(Icons.disc_full),
              _getNavBarItem(Icons.home),
              _getNavBarItem(Icons.gps_fixed),
              _getNavBarItem(Icons.aspect_ratio),
            ],
          ),
        )
      ],
    ),
  );
}

_getNavBarItem(IconData icon) {
  return Icon(
    icon,
    color: Color(0xffE3C36F),
  );
}


