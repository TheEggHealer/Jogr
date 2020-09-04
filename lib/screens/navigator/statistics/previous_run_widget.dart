import 'package:flutter/material.dart';
import 'package:jogr/utils/custom_icons.dart';
import 'package:jogr/utils/custom_widgets/data_display.dart';
import 'package:jogr/utils/models/run.dart';
import 'package:jogr/utils/constants.dart';

class PreviousRunWidget extends StatelessWidget {

  Run _run;

  PreviousRunWidget(@required Run run) {
    this._run = run;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        elevation: 5,
        color: color_dark_card,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DataDisplay(
                    icon: CustomIcons.distance,
                    data: _run.distanceString,
                    label: 'km',
                  ),
                  DataDisplay(
                    icon: CustomIcons.timer,
                    data: _run.timeString,
                    label: _run.timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',
                  ),
                  DataDisplay(
                    icon: CustomIcons.burn,
                    data: _run.calories.toString(),
                    label: 'cal',
                  )
                ],
              ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DataDisplay(
                    icon: CustomIcons.gps,
                    data: roundedString(_run.speed, 2),
                    label: 'km',
                  ),

                  DataDisplay(
                    icon: CustomIcons.timer,
                    data: Run(time: (10000 / _run.speed).round()).timeString,
                    label: _run.timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',
                  ),
                ],
              ),
              Divider(
                color: Color(0xff555555),
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDate(_run.date),
                    style: textStyleDarkLightLarge,
                  ),
                  OutlineButton(
                    onPressed: () {},
                    child: Text('REMOVE'),
                    color: color_dark_error,
                    highlightColor: color_dark_error,
                    highlightedBorderColor: color_dark_error,
                    focusColor: color_dark_error,
                    hoverColor: color_dark_error,
                    textColor: color_dark_text_dark,
                    splashColor: color_dark_error,
                    borderSide: BorderSide(color: color_dark_error),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
