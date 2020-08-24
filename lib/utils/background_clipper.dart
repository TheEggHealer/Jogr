import 'package:flutter/material.dart';
import 'package:jogr/utils/constants.dart';

class BackgroundClipper extends CustomClipper<Path> {

  static const double _roundnessFactor = 1/12; // 1/8

  double divisionHeight(double width, double height) {
    double roundness = width * _roundnessFactor;
    double divisionHeight = height - roundness;
    return divisionHeight * 0.8;
  }

  @override
  getClip(Size size) {
    double width = size.width;
    double height = size.height;
    double roundness = width * _roundnessFactor;
    double dh = divisionHeight(width, height);

    Path path = Path();

    path.lineTo(0, dh + roundness);
    path.quadraticBezierTo(0, dh, roundness, dh);
    path.lineTo(width - roundness, dh);
    path.quadraticBezierTo(width, dh, width, dh - roundness);
    path.lineTo(width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }

}