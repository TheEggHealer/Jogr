import 'package:flutter/material.dart';
import 'package:jogr/screens/navigator/home/home_component.dart';
import 'package:jogr/utils/constants.dart';

class Goal extends StatelessWidget {

  String header;
  String pre, post;
  HomeComponent a, b;
  bool fraction;
  Widget content;
  bool completed;

  Goal({ this.header = 'THIS WEEK', this.pre = '', this.post = '', this.a, this.b, this.fraction = false, this.content, this.completed = false });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              header,
              style: textStyleDark,
            ),
            Icon(
              Icons.check,
              size: 15,
              color: completed ? color_button_green : color_background
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            pre.isNotEmpty ? Text(pre, style: textStyleHeader,) : SizedBox(width: 0,),
            SizedBox(width: pre.isNotEmpty ? 10 : 0,),
            (fraction && a != null && b != null) ? Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                a,
                SizedBox(width: 10,),
                Text('/', style: textStyleHeader,),
                SizedBox(width: 10,),
                b
              ],
            ) : content,
            SizedBox(width: post.isNotEmpty ? 10 : 0,),
            post.isNotEmpty ? Text(post, style: textStyleHeader,) : SizedBox(width: 0,),
          ],
        )
      ],
    );
  }
}
