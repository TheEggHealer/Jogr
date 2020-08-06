import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';

class BackgroundClipper extends CustomClipper<Path> {

  static const double _roundnessFactor = 1/8;

  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double roundness = width * _roundnessFactor;
    double divisionHeight = height - roundness;

    Path path = Path();

    path.lineTo(0, divisionHeight + roundness);
    path.quadraticBezierTo(0, divisionHeight, roundness, divisionHeight);
    path.lineTo(width - roundness, divisionHeight);
    path.quadraticBezierTo(width, divisionHeight, width, divisionHeight - roundness);
    path.lineTo(width, 0);

    path.close();
    return path;
  }

  double divisionHeight(double width, double height) {
    double roundness = width * _roundnessFactor;
    double divisionHeight = height - roundness;
    return divisionHeight;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }

}