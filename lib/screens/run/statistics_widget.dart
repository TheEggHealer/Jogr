import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/home/home_component.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/models/run.dart';

class StatisticsWidget extends StatelessWidget {

  Run run;

  StatisticsWidget(this.run);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STATISTICS',
          style: textStyleDark,
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeComponent(
                      icon: CustomIcons.distance,
                      data: roundedString(run.distance / 1000, 1),
                      label: 'km',
                    ),
                    HomeComponent(
                      icon: CustomIcons.timer,
                      data: run.timeString,
                      label: 'mm:ss',
                    ),
                    HomeComponent(
                      icon: CustomIcons.jogr,
                      data: run.paceString,
                      label: 'min/km',
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeComponent(
                      icon: CustomIcons.burn,
                      data: '${run.calories}',
                      label: 'cal',
                    ),
                    HomeComponent(
                        icon: CustomIcons.speed,
                        data: roundedString(run.speed, 2),
                        label: 'm/s'
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
