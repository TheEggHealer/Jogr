import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/statistics/previous_runs.dart';
import 'package:jogr/screens/navigator/statistics/stat_list_item.dart';
import 'package:jogr/services/database.dart';
import 'package:jogr/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:jogr/utils/models/user.dart';
import 'package:jogr/utils/models/userdata.dart';
import 'dart:math';

class Statistics extends StatelessWidget {

  final UserData userData;
  final User user;
  DatabaseService db;
  Random rng;

  List<String> _stats;
  LineChartData _speedChart, _distanceChart;

  Statistics({ this.userData, this.user }) {
    db = DatabaseService(uid: user.uid);
    rng = Random();

    _stats = userData.stats;
    _speedChart = userData.getSpeedToDistanceChart();
    _distanceChart = userData.getDistanceChart();
  }

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 60),
        child: Column(
            children: [
              Center(
                child: Text(
                  'Statistics',
                  style: textStyleHeader,
                ),
              ),
              divider,
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: OutlineButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (con) => PreviousRuns(user, userData)));
                    //await db.mergeUserDataFields({
                    //  'previous_runs': userData.raw['previous_runs'].putIfAbsent('', () => {'20200714': {'distance': 2843 + rng.nextInt(1000),'time':900 + rng.nextInt(150),'calories':90 + rng.nextInt(50)}})
                    //});
                  },
                  child: Text(
                      'SEE ALL PREVIOUS RUNS',
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          color: color_dark_text_dark
                      )
                  ),
                  color: color_dark_text_highlight,
                  splashColor: color_dark_text_highlight,
                  highlightColor: color_dark_text_highlight,
                  focusColor: color_dark_text_highlight,
                  textColor: color_dark_text_dark,
                  borderSide: BorderSide(color: color_dark_text_highlight),
                  highlightedBorderColor: color_dark_text_highlight,
                ),
              ),
              divider,
              Text(
                  'Your running speed over time:',
                  style: textStyleHeaderSmall
              ),
              SizedBox(height: 25),
              _speedChart == null ? Text('Not enough data, go for more runs!', style: textStyleDarkLight,) : LineChart(
                _speedChart,
              ),
              SizedBox(height: 50),
              Text(
                  'Your running distance over time:',
                  style: textStyleHeaderSmall
              ),
              SizedBox(height: 25),
              _distanceChart == null ? Text('Not enough data, go for more runs!', style: textStyleDarkLight,) : LineChart(
                userData.getDistanceChart(),
              ),
              divider,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    StatListItem(title: 'Average running speed:', value: _stats[0], label: 'm/s',),
                    StatListItem(title: 'Fastest running speed:', value: _stats[1], label: 'm/s',),
                    StatListItem(title: 'Average time / 10km:', value: _stats[5], label: _stats[5].split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',),
                    StatListItem(title: 'Total distance ran:', value: _stats[2], label: 'km',),
                    StatListItem(title: 'Total calories burned:', value: _stats[3], label: 'cal',),
                    StatListItem(title: 'Total amount of runs:', value: _stats[4], label: 'runs', spacing: 40,),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }


  testData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        drawHorizontalLine: false,
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
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle: textStyleDarkLight,
          getTitles: (value) {
            switch (value.toInt()) {
              case 2:
                return 'MAR';
              case 5:
                return 'JUN';
              case 8:
                return 'SEP';
              case 15:
                return 'NOW';
            }
            return '';
          },
          margin: 8,
        ),
        leftTitles: SideTitles(
          showTitles: true,
          textStyle: textStyleDarkLight,
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: false, border: Border.all(color: color_dark_text_dark, width: 1)),
      minX: 0,
      maxX: 5,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(1, 2),
            FlSpot(2, 5),
            FlSpot(3, 3.1),
            FlSpot(4, 4),
            FlSpot(5, 3),
          ],
          isCurved: true,
          colors: [color_dark_error, color_dark_button_green],
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: [color_dark_error, color_dark_button_green].map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }




}
