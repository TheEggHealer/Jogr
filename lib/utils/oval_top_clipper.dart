import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';

class OvalTopClipper extends CustomClipper<Path> {

  static const double roundness = 0.1;


  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;
    print('Height: $height');

    Path path = Path();

    path.lineTo(0, height - height * roundness);
    path.quadraticBezierTo(width / 2, height + height * roundness, width, height - height * roundness);
    path.lineTo(width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }

}