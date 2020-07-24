import 'package:background_locator/location_dto.dart';
import 'package:jogr/utils/tracking/callback_repository.dart';

class CallbackHandler {

  static bool active = false;

  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    CallbackRepository myLocationCallbackRepository = CallbackRepository();
    await myLocationCallbackRepository.init(params);
  }

  static Future<void> disposeCallback() async {
    CallbackRepository myLocationCallbackRepository = CallbackRepository();
    await myLocationCallbackRepository.dispose();
  }

  static Future<void> callback(LocationDto locationDto) async {
    if(active) {
      CallbackRepository myLocationCallbackRepository = CallbackRepository();
      await myLocationCallbackRepository.callback(locationDto);
    }
  }

  static Future<void> notificationCallback() async {
    print('***notificationCallback');
  }
}