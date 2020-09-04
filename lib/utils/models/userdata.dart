
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jogr/utils/models/route.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:flutter/material.dart' hide Route;
import 'package:shared_preferences/shared_preferences.dart';


import '../constants.dart';
import '../user_preferences.dart';

class UserData {

  String uid;
  Map<String, dynamic> raw;

  String name;
  DateTime birth;
  int age;
  double weight;
  Route lastRoute;
  List<Run> runs;
  List<Route> routes;
  bool lightMode = false;

  static const int _plotDetail = 8;

  UserData({ this.raw, this.uid });

  setupExisting() {
    if (raw.containsKey('name')) name = raw['name'];
    if (raw.containsKey('weight')) weight = raw['weight'];
    if (raw.containsKey('date_of_birth')) birth = DateTime.parse(raw['date_of_birth']);
    if (raw.containsKey('light_mode')) lightMode = raw['light_mode'];

    if(birth != null) age = (DateTime.now().difference(birth).inDays / 365).floor();

    addRuns(raw['previous_runs']);
    addRoutes(raw['saved_routes']);

    if (raw.containsKey('lastRoute')) lastRoute = routes[raw['lastRoute']];

    updateSharedPreferences();
  }

  void updateSharedPreferences() async {
    sharedPreferences.setBool('lightMode', lightMode);
    UserPreferences.prefsLightMode = lightMode;
    print('Setting userpref lightmode to $lightMode');
    print('UserPref lightmode is now: ${UserPreferences.prefsLightMode}');
    print('Reading shared: ${sharedPreferences.getBool('lightMode')}');
  }

  addRuns(Map<String, dynamic> runs) {
    List<Run> result = [];

    if (runs != null) {
      runs.forEach((key, value) {
        result.add(
            Run(
              date: key,
              distance: value['distance'],
              time: value['time'],
              calories: value['calories'],
            )
        );
      });
    }

    result.sort((a, b) => a.date.compareTo(b.date));

    this.runs = result;
  }

  addRoutes(Map<String, dynamic> routes) {
    List<Route> result = [];

    if(routes != null) {
      routes.forEach((key, value) {
        List<LatLng> waypoints = [];
        int distance = 0;
        int timesRan = 0;
        int totalDistanceRan = 0;
        int totalTime = 0;
        String name = key;

        value.forEach((key2, value2) {
          if(key2 == 'distance') distance = int.parse(value2);
          else if(key2 == 'timesRan') timesRan = int.parse(value2);
          else if(key2 == 'totalDistanceRan') totalDistanceRan = int.parse(value2);
          else if(key2 == 'totalTime') totalTime = int.parse(value2);
          else waypoints.add(LatLng(double.parse(value2.split('&')[0]), double.parse(value2.split('&')[1])));
        });

        result.add(
          Route(
            name: name,
            waypoints: waypoints,
            distance: distance,
            timesRan: timesRan,
            totalDistanceRan: totalDistanceRan,
            totalTime: totalTime,
          )
        );
      });
    }

    this.routes = result;
  }

  Run get lastRun => runs.length > 0 ? runs[runs.length - 1] : null;

  List<String> get stats {
    if (runs.length > 0) {
      double total = 0;
      int totalCalories = 0;
      double average = 0;
      double fastest = 0;
      runs.forEach((element) {
        if (element.speed > fastest) fastest = element.speed;
        average += element.speed;
        total += element.distance;
        totalCalories += element.calories;
      });
      average /= runs.length;

      return [
        roundedString(average, 2),
        roundedString(fastest, 2),
        roundedString(total / 1000, 1),
        totalCalories.toString(),
        runs.length.toString(),
        Run(time: (10000 / average).round()).timeString,
      ];
    } else {
      return [
        '--',
        '--',
        '--',
        '--',
        '--',
        '--'
      ];
    }
  }

  LineChartData getSpeedToDistanceChart() {
    if (runs.length > 1) {
      List<FlSpot> spots = [];
      double fastest = 0;
      double slowest = double.infinity;
      int size = runs.length;

      if (size > _plotDetail+1) {
        int interval = (size / _plotDetail).floor();
        bool addLast = interval * _plotDetail < size;

        for (int i = 0; i < _plotDetail; i++) {
          double total = 0;
          for (int j = interval * i; j < interval * (i + 1); j++) {
            total += runs[j].speed;
          }
          total /= interval;

          if (total > fastest) fastest = total;
          else if (total < slowest) slowest = total;
          spots.add(FlSpot(i.toDouble(), total));
        }

        if (addLast) {
          double total = 0;
          for (int i = interval * _plotDetail; i < size; i++) {
            total += runs[i].speed;
          }
          total /= (size - interval * _plotDetail);

          if (total > fastest) fastest = total;
          else if (total < slowest) slowest = total;
          spots.add(FlSpot(_plotDetail.toDouble(), total));
        }
      } else {
        for (int i = 0; i < size; i++) {
          if (runs[i].speed > fastest) fastest = runs[i].speed;
          if (runs[i].speed < slowest) slowest = runs[i].speed;
          spots.add(FlSpot(i.toDouble(), runs[i].speed));
        }
      }

      return LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: color_dark_text_dark,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: color_dark_text_dark,
              strokeWidth: 1,
            );
          },
        ),

        lineTouchData: LineTouchData(
          enabled: false,
        ),

        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            textStyle: textStyleDarkLight,
            getTitles: (value) {
              if (value == 0)
                return 'START';
              else if (value == spots.length - 1) return 'NOW';
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: textStyleDarkLight,
            getTitles: (value) {
              if (value == fastest.ceil())
                return '${fastest.ceil()} m/s';
              else
              if (value == slowest.floor()) return '${slowest.floor()} m/s';
              return '';
            },
            reservedSize: 28,
            margin: 12,
          ),
        ),

        borderData:
        FlBorderData(show: false,
            border: Border.fromBorderSide(
                BorderSide(color: color_dark_text_dark, width: 1))),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: slowest.floor().toDouble(),
        maxY: fastest.ceil().toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            colors: [Color(0xff62ECFF), Color(0xff62ECFF)],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradientFrom: Offset(0, 0),
              gradientTo: Offset(0, 1),
              colors: [Color(0xff62ECFF), color_dark_background].map((color) =>
                  color.withOpacity(0.2)).toList(),
            ),
          ),
        ],
      );
    } else {
      return null;
    }
  }

  LineChartData getDistanceChart() {
    if (runs.length > 1) {
      List<FlSpot> spots = [];
      double longest = 0;
      double shortest = double.infinity;
      int size = runs.length;

      if(size > _plotDetail + 1) {
        int interval = (size / _plotDetail).floor();
        bool addLast = interval * _plotDetail < size;

        for(int i = 0; i < _plotDetail; i++) {
          double average = 0;
          for(int j = interval * i; j < interval * (i+1); j++) {
            average += runs[j].distance;
          }
          average /= interval;

          if (average > longest) longest = average;
          else if (average < shortest) shortest = average;
          spots.add(FlSpot(i.toDouble(), rounded(average / 1000, 1)));
        }

        if(addLast) {
          double average = 0;
          for(int i = interval * _plotDetail; i < size; i++) {
            average += runs[i].distance;
          }
          average /= (size - interval * _plotDetail);

          if (average > longest) longest = average;
          else if (average < shortest) shortest = average;
          spots.add(FlSpot(_plotDetail.toDouble(), rounded(average / 1000, 1)));
        }
      } else {
        for (int i = 0; i < size; i++) {
          if (runs[i].distance > longest) longest = runs[i].distance.toDouble();
          if (runs[i].distance < shortest) shortest = runs[i].distance.toDouble();
          spots.add(FlSpot(i.toDouble(), rounded(runs[i].distance.toDouble() / 1000, 1)));
        }
      }

      longest = rounded(longest / 1000, 1);
      shortest = rounded(shortest / 1000, 1);

      return LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          drawHorizontalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: color_dark_text_dark,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: color_dark_text_dark,
              strokeWidth: 1,
            );
          },
        ),

        lineTouchData: LineTouchData(
          enabled: false,
        ),

        titlesData: FlTitlesData(
          show: true,
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 22,
            textStyle: textStyleDarkLight,
            getTitles: (value) {
              if (value == 0)
                return 'START';
              else if (value == spots.length - 1) return 'NOW';
              return '';
            },
            margin: 8,
          ),
          leftTitles: SideTitles(
            showTitles: true,
            textStyle: textStyleDarkLight,
            getTitles: (value) {
              if (value == longest.ceil()) return '${longest.ceil()} km';
              else if (value == shortest.floor()) return '${shortest.floor()} km';
              return '';
            },
            reservedSize: 28,
            margin: 12,
          ),
        ),

        borderData:
        FlBorderData(show: false,
            border: Border.fromBorderSide(
                BorderSide(color: color_dark_text_dark, width: 1))),
        minX: 0,
        maxX: (spots.length - 1).toDouble(),
        minY: shortest.floor().toDouble(),
        maxY: longest.ceil().toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            colors: [Color(0xff62FFA1), Color(0xff62FFA1)],
            barWidth: 5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: false,
            ),
            belowBarData: BarAreaData(
              show: true,
              gradientFrom: Offset(0, 0),
              gradientTo: Offset(0, 1),
              colors: [Color(0xff62FFA1), color_dark_background].map((color) =>
                  color.withOpacity(0.2)).toList(),
            ),
          ),
        ],
      );
    } else {
      return null;
    }
  }

}