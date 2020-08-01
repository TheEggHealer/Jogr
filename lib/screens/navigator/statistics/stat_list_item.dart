import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';

class StatListItem extends StatelessWidget {

  String title, label, value;
  double spacing;

  StatListItem({ @required this.title, @required this.value, @required this.label, this.spacing = 10 });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Expanded(
              child: Text(
                  title,
                  style: textStyleDarkLightLarge
              ),
            ),
            SizedBox(width: 10),
            Text(
                value,
                style: textStyleHeader
            ),
            SizedBox(width: 5),
            Text(
              label,
              style: textStyleDark,
            ),
          ],
        ),
        SizedBox(height: spacing),
      ],
    );
  }
}
