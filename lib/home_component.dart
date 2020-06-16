import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'utils/constants.dart';

class HomeComponent extends StatefulWidget {

  final IconData icon;
  final String data;
  final String label;

  const HomeComponent({Key key, this.icon, this.data, this.label}) : super(key: key);

  @override
  _HomeComponentState createState() => _HomeComponentState();
}

class _HomeComponentState extends State<HomeComponent> {

  static const double _baselineHeight = 4.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: color_text_highlight,
              size: 20,
            ),
            Text(
              widget.data,
              style: TextStyle(
                fontSize: 28,
                fontFamily: 'Quicksand',
                color: color_text_highlight,
              ),
            ),
          ],
        ),

        SizedBox(width: 5),

        Padding(
          padding: const EdgeInsets.only(bottom: _baselineHeight),
          child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'Roboto',
                color: color_text_dark,
              )
          ),
        ),
      ],
    );
  }
}
