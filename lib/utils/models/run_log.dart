import 'package:latlong/latlong.dart';

class RunLog {

  bool empty = false;
  bool running = false;
  List<List<LatLng>> locations;
  List<double> speed;
  double distance;

  List<int> times = [];
  int startTime;
  int endTime;

  RunLog(String log) {
    if(log.isNotEmpty) {
      List<String> data = log.split('\n');
      running = true;
      startTime = int.parse(data[0]);
      times.add(startTime);
      locations = [];
      locations.add([]);
      distance = 0;
      int part = 0;
      int index = 0;
      int size = 0;
      while(index++ < data.length - 1) {
        print('Added position ${index}');
        if(data[index] == '*') {
          part++;
          locations.add([]);
        }
        else if(data[index].isNotEmpty && data[index].contains('#')){
          List<String> position = data[index].split('#');
          locations[part].add(LatLng(double.parse(position[0]), double.parse(position[1])));
          size++;
        } else {

        }
      }
      findDistance();
    } else {
      empty = true;
      locations = [];
      speed = [];
      startTime = 0;
      distance = 0;
    }
  }

  void findDistance() {
    Distance dist = Distance();
    for(int i = 0; i < locations.length; i++) {
      if(locations[i].length > 1) {
        for (int j = 1; j < locations[i].length; j++) {
          distance += dist.as(LengthUnit.Meter, locations[i][j-1], locations[i][j]);
        }
      }
    }
  }

}