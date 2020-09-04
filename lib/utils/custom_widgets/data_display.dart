import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';
import 'package:jogr/utils/user_preferences.dart';

class DataDisplay extends StatefulWidget {

  final IconData icon;
  final String data;
  final String label;
  final UserPreferences prefs;

  const DataDisplay({Key key, this.icon, this.data, this.label, this.prefs}) : super(key: key);

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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: widget.icon != null,
              child: Icon(
                widget.icon,
                color: widget.prefs.color_highlight,
                size: 15,
              ),
            ),
            Text(
              widget.data,
              style: widget.prefs.text_highlight,
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsets.only(bottom: _baselineHeight),
          child: Text(
              widget.label,
              style: widget.prefs.text_label,
          ),
        ),
      ],
    );
  }
}
