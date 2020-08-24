import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/route/route_planner.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/loading.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'package:jogr/utils/user_preferences.dart';

class WideRoutePanel extends StatefulWidget {
  RoutePlannerState planner;
  UserData userData;

  WideRoutePanel(this.planner, this.userData);

  @override
  _WideRoutePanelState createState() => _WideRoutePanelState(userData);
}

class _WideRoutePanelState extends State<WideRoutePanel> {

  UserPreferences prefs;

  _WideRoutePanelState(UserData userData) {
    prefs = UserPreferences(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: prefs.color_background,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: prefs.color_shadow,
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Add waypoints to the map',
              style: textStyleHeaderSmall,
            ),
          ),
          Divider(
            color: Color(0xff555555),
            endIndent: 20,
            indent: 20,
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlineButton(
                onPressed: () { showDialog(context: context, builder: widget.planner.helpDialog); },
                child: Text('HELP'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    widget.planner.loading = true;
                  });
                  //widget.planner.generateRoute();
                },
                child: Text('GENERATE ROUTE'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),
              OutlineButton(
                onPressed: () { widget.planner.clearRoute(); },
                child: Text('CLEAR'),
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlineButton(
                onPressed: () {
                  widget.planner.map.state.setState(() {
                    widget.planner.map.state.showMarkes = !widget.planner.map.state.showMarkes;
                  });
                  setState(() {});
                },
                child: Text(widget.planner.map.state.showMarkes ? 'HIDE MARKERS' : 'SHOW MARKERS'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(context: context, builder: widget.planner.loadDialog);
                },
                child: Text('LOAD'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(context: context, builder: widget.planner.saveDialog);
                },
                child: Text('SAVE'),
                color: color_dark_button_green,
                highlightColor: color_dark_button_green,
                highlightedBorderColor: color_dark_button_green,
                focusColor: color_dark_button_green,
                hoverColor: color_dark_button_green,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_button_green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Distance:',
                    style: textStyleDarkLightLarge,
                  ),
                  SizedBox(width: 15,),
                  Text(
                    '${widget.planner.totalDistance}',
                    style: textStyleHeader,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    'm',
                    style: textStyleDark,
                  )
                ],
              ),
              Positioned(
                right: 30,
                child: AnimatedOpacity(
                  opacity: widget.planner.loading ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Loading(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NarrowRoutePanel extends StatefulWidget {

  RoutePlannerState planner;

  NarrowRoutePanel(RoutePlannerState planner) {
    this.planner = planner;
  }

  @override
  _NarrowRoutePanelState createState() => _NarrowRoutePanelState();
}

class _NarrowRoutePanelState extends State<NarrowRoutePanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: color_dark_background,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Colors.black,
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Add waypoints to the map',
              style: textStyleHeaderSmall,
            ),
          ),
          Divider(
            color: Color(0xff555555),
            endIndent: 20,
            indent: 20,
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: () { showDialog(context: context, builder: widget.planner.helpDialog); },
                child: Text('HELP'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    widget.planner.loading = true;
                  });
                  //widget.planner.generateRoute();
                },
                child: Text('GENERATE ROUTE'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: () { widget.planner.clearRoute(); },
                child: Text('CLEAR'),
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
                onPressed: () {
                  widget.planner.map.state.setState(() {
                    widget.planner.map.state.showMarkes = !widget.planner.map.state.showMarkes;
                  });
                  setState(() {});
                },
                child: Text(widget.planner.map.state.showMarkes ? 'HIDE MARKERS' : 'SHOW MARKERS'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: () { showDialog(context: context, builder: widget.planner.loadDialog); },
                child: Text('LOAD'),
                color: color_dark_text_highlight,
                highlightColor: color_dark_text_highlight,
                highlightedBorderColor: color_dark_text_highlight,
                focusColor: color_dark_text_highlight,
                hoverColor: color_dark_text_highlight,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(context: context, builder: widget.planner.saveDialog);
                },
                child: Text('SAVE'),
                color: color_dark_button_green,
                highlightColor: color_dark_button_green,
                highlightedBorderColor: color_dark_button_green,
                focusColor: color_dark_button_green,
                hoverColor: color_dark_button_green,
                textColor: color_dark_text_dark,
                splashColor: color_dark_text_highlight,
                borderSide: BorderSide(color: color_dark_button_green),
              ),
            ],
          ),
          SizedBox(height: 20),
          Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Distance:',
                    style: textStyleDarkLightLarge,
                  ),
                  SizedBox(width: 15,),
                  Text(
                    '${widget.planner.totalDistance}',
                    style: textStyleHeader,
                  ),
                  SizedBox(width: 5,),
                  Text(
                    'm',
                    style: textStyleDark,
                  )
                ],
              ),
              Positioned(
                right: 30,
                child: AnimatedOpacity(
                  opacity: widget.planner.loading ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Loading(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
