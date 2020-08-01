import 'dart:async';

import 'package:flutter/cupertino.dart' hide Route, Path;
import 'package:flutter/material.dart' hide Route, Path;
import 'package:jogr/screens/run/map_widget.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapDialog extends StatefulWidget {
  bool showMarkers = true;
  bool showRoute = true;

  MapWidget map = MapWidget();

  @override
  _MapDialogState createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SlidingUpPanel(
            parallaxOffset: 0.4,
            parallaxEnabled: true,
            renderPanelSheet: false,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
            maxHeight: constraints.maxWidth > 400 ? MediaQuery.of(context).size.height/3.2 : MediaQuery.of(context).size.height/3.2,
            minHeight: 100,

            collapsed: Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  color: color_background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                        Icons.drag_handle,
                        size: 30,
                        color: color_text_dark
                    ),
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Center(
                          child: Text(
                            'Map',
                            style: textStyleHeaderSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IconButton(
                            icon: Icon(CustomIcons.back, size: 30, color: color_text_highlight),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
            panel: Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: color_background,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Center(
                          child: Text(
                            'Map',
                            style: textStyleHeaderSmall,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: IconButton(
                            icon: Icon(CustomIcons.back, size: 30, color: color_text_highlight),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
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
                          onPressed: () { setState(() {
                            widget.map.showMarkers = !widget.map.showMarkers;
                          }); },
                          child: Text(widget.map.showMarkers ? 'HIDE MARKERS' : 'SHOW MARKERS'),
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
                          onPressed: () { setState(() {
                            widget.map.showRoute = !widget.map.showRoute;
                          }); },
                          child: Text(widget.map.showRoute ? 'HIDE ROUTE' : 'SHOW ROUTE'),
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
                    )
                  ],
                )
            ),
            body: widget.map,
          );
        },
      ),
    );
  }
}
