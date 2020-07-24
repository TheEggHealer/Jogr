import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/tracking/callback_handler.dart';
import 'package:jogr/utils/tracking/callback_repository.dart';
import 'package:latlong/latlong.dart';
import 'package:path_provider/path_provider.dart';

import 'map_dialog.dart';

class LocationTracker {

  static const String _isolateName = "JogrIsolator";
  ReceivePort port = ReceivePort();
  List<LocationDto> positions = [];
  double totalDistance = 0;
  static const int stepSize = 1;

  bool initializedTracking = false;
  bool tracking = false;
  bool isRunning = false;

  MapDialog map;
  static DatabaseService db;
  LocationTracker(this.map, DatabaseService _d) {
    db = DatabaseService(uid: 'IsT9DEc5gGVulFDWRRR9ubdDaw73');
  }

  void init() {
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    await BackgroundLocator.initialize();
    isRunning = await BackgroundLocator.isRegisterLocationUpdate();
  }

  void setTracking(bool tracking) {
    this.tracking = tracking;
  }

  void startLocationService(){
    BackgroundLocator.registerLocationUpdate(
      CallbackHandler.callback,
      initCallback: CallbackHandler.initCallback,
      disposeCallback: CallbackHandler.disposeCallback,
      androidNotificationCallback: CallbackHandler.notificationCallback,

      settings: LocationSettings(
          notificationChannelName: "Jogr tracking service",
          notificationTitle: "Start Location Tracking",
          notificationMsg: "Track location in background",
          wakeLockTime: 120,
          autoStop: false,
          interval: 1,
      ),
    );
    initializedTracking = true;
  }

  void stopLocationService() {
    BackgroundLocator.unRegisterLocationUpdate();
    IsolateNameServer.removePortNameMapping(_isolateName);
    initializedTracking = false;
  }

  void dispose() {
    //stopLocationService();
    //tracking = false;
    //IsolateNameServer.removePortNameMapping(_isolateName);
    port.close();
    print('disposed backgounr locator');
  }

}