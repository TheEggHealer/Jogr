import 'package:background_locator/location_dto.dart';
import 'package:jogr/utils/file_manager.dart';


class CallbackRepository {
  static CallbackRepository _instance = CallbackRepository._();

  CallbackRepository._();

  factory CallbackRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    DateTime date = DateTime.now();
    FileManager.write('${date.millisecondsSinceEpoch}\n');

  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
  }

  Future<void> callback(LocationDto locationDto) async {
    print('${locationDto.toString()}');
    FileManager.write('${locationDto.latitude}#${locationDto.longitude}\n');
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }
}