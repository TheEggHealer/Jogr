import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';

class DataDisplay extends StatefulWidget {

  final IconData icon;
  final String data;
  final String label;
  final bool lightMode;

  const DataDisplay({Key key, this.icon, this.data, this.label, this.lightMode = true}) : super(key: key);

  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {

  static const double _baselineHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.lightMode ? color_light_background : color_dark_text_highlight,
              size: 15,
            ),
            Text(
              widget.data,
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Quicksand',
                color: widget.lightMode ? color_light_background : color_dark_text_highlight,
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: _baselineHeight),
          child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Roboto',
                color: widget.lightMode ? color_light_text_background : color_dark_text_dark,
              )
          ),
        ),
      ],
    );
  }
}
