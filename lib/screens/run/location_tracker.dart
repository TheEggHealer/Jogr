import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:latlong/latlong.dart';

import 'map_dialog.dart';

class LocationTracker {

  static const String _isolateName = "JogrIsolator";
  ReceivePort port = ReceivePort();
  List<LocationDto> positions = [];
  double totalDistance = 0;
  static const int stepSize = 1;

  bool initializedTracking = false;
  bool tracking = false;

  MapDialog map;
  LocationTracker(this.map);

  void init() {
    print('Initializing');
    IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    port.listen((dynamic data) {
      if(tracking) {
        print('$data');

        Distance distance = Distance();

        if (positions.length > 0 && distance.as(
            LengthUnit.Meter,
            LatLng(data.latitude, data.longitude),
            LatLng(positions.last.latitude, positions.last.longitude)
        ) >= stepSize) {
          totalDistance += distance.as(
              LengthUnit.Meter,
              LatLng(data.latitude, data.longitude),
              LatLng(positions.last.latitude, positions.last.longitude)
          );;
          positions.add(data);
        } else if (positions.isEmpty) {
          positions.add(data);
        }
      }
    });
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  static void callback(LocationDto loc) async {
    final SendPort send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(loc);
  }

  void setTracking(bool tracking) {
    this.tracking = tracking;
  }

  void startLocationService(){
    BackgroundLocator.registerLocationUpdate(
      callback,
      //optional
      androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
        //Scroll down to see the different options
          notificationTitle: "Start Location Tracking",
          notificationMsg: "Track location in background",
          wakeLockTime: 20,
          autoStop: false,
          interval: 5,
      ),
    );
    initializedTracking = true;
  }

  void stopLocationService() {
    BackgroundLocator.unRegisterLocationUpdate();
    initializedTracking = false;
  }

  void dispose() {
    stopLocationService();
    tracking = false;
    IsolateNameServer.removePortNameMapping(_isolateName);
    print('disposed backgounr locator');
  }

}