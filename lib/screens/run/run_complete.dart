import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/utils/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RunComplete extends StatefulWidget {
  @override
  _RunCompleteState createState() => _RunCompleteState();
}

class _RunCompleteState extends State<RunComplete> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SlidingUpPanel(
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
            ),

            panel: Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                color: color_background,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0), ),
              ),
              body: GoogleMap(
                initialCameraPosition: CameraPosition(target: position, zoom: 18),
                myLocationEnabled: true,
                buildingsEnabled: true,
                onMapCreated: onCreate,
                markers: widget.showMarkers ? widget.markers : {},
                polylines: widget.showRoute ? widget._polylines : widget._polylines.where((element) => element.zIndex == 1).toSet(),
              ),
            )
          );
        },
      ),
    );
  }
}
