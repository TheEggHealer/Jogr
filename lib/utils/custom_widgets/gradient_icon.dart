import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {

  double size;
  LinearGradient gradient;
  IconData icon;

  GradientIcon({this.icon, this.gradient, this.size});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}
