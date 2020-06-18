import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'constants.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: color_background,
      child: SpinKitChasingDots(
        color: color_text_dark,
        size: 30,
      ),
    );
  }
}
