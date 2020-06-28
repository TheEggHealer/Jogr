import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';

class ProfileItem extends StatefulWidget {
  String title, data, label;

  ProfileItem({ this.title, this.data, this.label });

  @override
  _ProfileItemState createState() => _ProfileItemState();
}

class _ProfileItemState extends State<ProfileItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.ideographic,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 4,
                child: Text(
                  widget.title,
                  style: textStyleDarkLightLarge,
                ),
              ),
              Text(
                widget.data,
                style: textStyleHeader,
              ),
              SizedBox(width: 5,),
              Text(
                widget.label,
                style: textStyleDark,
              ),
            ],
          ),
          OutlineButton(
            onPressed: () {},
            child: Text('CHANGE'),
            color: color_text_highlight,
            highlightColor: color_text_highlight,
            highlightedBorderColor: color_text_highlight,
            focusColor: color_text_highlight,
            hoverColor: color_text_highlight,
            textColor: color_text_dark,
            borderSide: BorderSide(color: color_text_highlight),
          )
        ],
      ),
    );
  }
}
