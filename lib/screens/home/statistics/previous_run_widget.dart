import 'package:flutter/material.dart';
import 'package:learningflutter2/utils/custom_icons.dart';
import 'package:learningflutter2/utils/models/run.dart';
import 'package:learningflutter2/utils/constants.dart';

import '../../../home_component.dart';

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
        color: color_card,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeComponent(
                    icon: CustomIcons.distance,
                    data: _run.distanceString,
                    label: 'km',
                  ),
                  HomeComponent(
                    icon: CustomIcons.timer,
                    data: _run.timeString,
                    label: _run.timeString.split(':').length > 2 ? 'hh:mm:ss' : 'mm:ss',
                  ),
                  HomeComponent(
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
                  HomeComponent(
                    icon: CustomIcons.gps,
                    data: roundedString(_run.speed, 2),
                    label: 'km',
                  ),

                  HomeComponent(
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    formatDate(_run.date),
                    style: textStyleDarkLightLarge,
                  ),
                  OutlineButton(
                    onPressed: () {},
                    child: Text('SEE ROUTE'),
                    color: color_text_highlight,
                    highlightColor: color_text_highlight,
                    highlightedBorderColor: color_text_highlight,
                    focusColor: color_text_highlight,
                    hoverColor: color_text_highlight,
                    textColor: color_text_dark,
                    splashColor: color_text_highlight,
                    borderSide: BorderSide(color: color_text_highlight),
                  ),
                  OutlineButton(
                    onPressed: () {},
                    child: Text('DELETE'),
                    color: color_error,
                    highlightColor: color_error,
                    highlightedBorderColor: color_error,
                    focusColor: color_error,
                    hoverColor: color_error,
                    textColor: color_text_dark,
                    splashColor: color_error,
                    borderSide: BorderSide(color: color_error),
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
