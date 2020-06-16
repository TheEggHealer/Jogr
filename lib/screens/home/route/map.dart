import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_background_location/flutter_background_location.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {


  @override
  Widget build(BuildContext context) {

                                                LatLng position = LatLng(55.7096178, 13.2328676);

                                                void onCreate(GoogleMapController controller) {
                                                  FlutterBackgroundLocation.startLocationService();
                                                  FlutterBackgroundLocation.getLocationUpdates((loc) => {
                                                    controller.animateCamera(
                                                      CameraUpdate.newCameraPosition(CameraPosition(
                                                        target: LatLng(loc.latitude, loc.longitude),
                                                        zoom: 18
                                                      ))
                                                    )
                                                  });
    }

    return Container(
      height: MediaQuery.of(context).size.height / 1.7,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(target: position, zoom: 18),
        myLocationEnabled: true,
        buildingsEnabled: true,
        mapType: MapType.hybrid,
        onMapCreated: onCreate,
        onTap: (loc) {
          print(loc);
        },
        markers: {
          Marker(markerId: MarkerId("first"), position: position)
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    FlutterBackgroundLocation.stopLocationService();
  }
}
