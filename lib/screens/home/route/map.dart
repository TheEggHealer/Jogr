import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {

  static const String _isolateName = "JogrIsolator";
  ReceivePort port = ReceivePort();

  @override
  void initState() {
    super.initState();

    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) {
      print('Data: $data');
    });
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void callback(LocationDto locationDto) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  //Optional
  static void notificationCallback() {
    print('User clicked on the notification');
  }

  void startLocationService(){
    BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
        //Scroll down to see the different options
          notificationTitle: "Start Location Tracking example",
          notificationMsg: "Track location in background exapmle",
          wakeLockTime: 20,
          autoStop: false,
          interval: 1
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    LatLng position = LatLng(55.7096178,13.2328676);

    void onCreate(GoogleMapController controller) {

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
  }
}
