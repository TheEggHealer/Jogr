import 'package:flutter/material.dart';
import 'package:jogr/screens/home/route/route_planner.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/loading.dart';

class WideRoutePanel extends StatefulWidget {
  RoutePlanner planner;

  WideRoutePanel(RoutePlanner planner) {
    this.planner = planner;
  }

  @override
  _WideRoutePanelState createState() => _WideRoutePanelState();
}

class _WideRoutePanelState extends State<WideRoutePanel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: color_background,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlineButton(
                onPressed: () { showDialog(context: context, builder: widget.planner.state.helpDialog); },
                child: Text('HELP'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    widget.planner.state.loading = true;
                  });
                  widget.planner.state.generateRoute();
                },
                child: Text('GENERATE ROUTE'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),
              OutlineButton(
                onPressed: () { widget.planner.state.clearRoute(); },
                child: Text('CLEAR'),
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
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlineButton(
                onPressed: () {
                  widget.planner.state.map.state.setState(() {
                    widget.planner.state.map.state.showMarkes = !widget.planner.state.map.state.showMarkes;
                  });
                  setState(() {});
                },
                child: Text(widget.planner.state.map.state.showMarkes ? 'HIDE MARKERS' : 'SHOW MARKERS'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),
              OutlineButton(
                onPressed: () { showDialog(context: context, builder: widget.planner.state.loadDialog); },
                child: Text('LOAD'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(context: context, builder: widget.planner.state.saveDialog);
                },
                child: Text('SAVE'),
                color: color_button_green,
                highlightColor: color_button_green,
                highlightedBorderColor: color_button_green,
                focusColor: color_button_green,
                hoverColor: color_button_green,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_button_green),
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
                    '${widget.planner.state.totalDistance}',
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
                  opacity: widget.planner.state.loading ? 1.0 : 0.0,
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

  RoutePlanner planner;

  NarrowRoutePanel(RoutePlanner planner) {
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
          color: color_background,
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
                onPressed: () { showDialog(context: context, builder: widget.planner.state.helpDialog); },
                child: Text('HELP'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  setState(() {
                    widget.planner.state.loading = true;
                  });
                  widget.planner.state.generateRoute();
                },
                child: Text('GENERATE ROUTE'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: () { widget.planner.state.clearRoute(); },
                child: Text('CLEAR'),
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
                onPressed: () {
                  widget.planner.state.map.state.setState(() {
                    widget.planner.state.map.state.showMarkes = !widget.planner.state.map.state.showMarkes;
                  });
                  setState(() {});
                },
                child: Text(widget.planner.state.map.state.showMarkes ? 'HIDE MARKERS' : 'SHOW MARKERS'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlineButton(
                onPressed: () { showDialog(context: context, builder: widget.planner.state.loadDialog); },
                child: Text('LOAD'),
                color: color_text_highlight,
                highlightColor: color_text_highlight,
                highlightedBorderColor: color_text_highlight,
                focusColor: color_text_highlight,
                hoverColor: color_text_highlight,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_text_highlight),
              ),
              OutlineButton(
                onPressed: () {
                  showDialog(context: context, builder: widget.planner.state.saveDialog);
                },
                child: Text('SAVE'),
                color: color_button_green,
                highlightColor: color_button_green,
                highlightedBorderColor: color_button_green,
                focusColor: color_button_green,
                hoverColor: color_button_green,
                textColor: color_text_dark,
                splashColor: color_text_highlight,
                borderSide: BorderSide(color: color_button_green),
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
                    '${widget.planner.state.totalDistance}',
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
                  opacity: widget.planner.state.loading ? 1.0 : 0.0,
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
