import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info/package_info.dart';

const bool darkMode = true;

const Color color_background = darkMode ? Color(0xff151515) : Color(0xffffffff);
const Color color_card = darkMode ? Color(0xff1C1C1C): Color(0xffcccccc);
const Color color_text_highlight = darkMode ? Color(0xffE3C36F): Color(0xff1C1C1C);
const Color color_text_dark = darkMode ? Color(0xff555555) : Color(0xff444444);
const Color color_button_green = Color(0xff61B25F);
const Color color_error = Color(0xffAF3232);

const textStyleDark = TextStyle(
    fontSize: 12,
    fontFamily: 'Roboto',
    color: color_text_dark,
);
const textStyleDarkLight = TextStyle(
  color: color_text_dark,
  fontFamily: 'RobotoLight',
);
const textStyleDarkLightLarge = TextStyle(
  color: color_text_dark,
  fontFamily: 'Quicksand',
  fontSize: 20,
);
const textStyleHeader = TextStyle(
  fontSize: 28,
  fontFamily: 'Quicksand',
  color: color_text_highlight,
);
const textStyleHeaderLarge = TextStyle(
  fontSize: 35,
  fontFamily: 'Quicksand',
  color: color_text_highlight,
);
const textStyleHeaderSmall = TextStyle(
  fontSize: 20,
  fontFamily: 'Quicksand',
  color: color_text_highlight,
);

const Divider divider = Divider(
  color: Color(0xff555555),
  endIndent: 20,
  indent: 20,
  height: 60,
);

Future<String> get VERSION async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}


String roundedString(double value, int digits) {
  return rounded(value, digits).toString();
}

double rounded(double value, int digits) {
  return (value * pow(10, digits)).round().toDouble() / pow(10, digits);
}

String formatDate(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6, 8);
  String minute = date.length > 8 ? date.substring(8, 10) : '';
  String second = date.length > 8 ? date.substring(10, 12) : '';
  return '${date.length > 8 ? ' $minute:$second ' : ''}$year-$month-$day';
}

class NoScrollGlow extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

//Bitmap icon for markers
Future<BitmapDescriptor> getMarkerIcon(int clusterSize, Color clusterColor, Color textColor, int width) async {
  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final Paint paint = Paint()..color = clusterColor;
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );

  paint.strokeWidth = 10;
  paint.strokeCap = StrokeCap.butt;
  paint.strokeJoin = StrokeJoin.round;

  final double radius = width / 2;

  canvas.drawCircle(
    Offset(radius, radius),
    radius,
    paint,
  );


  Vertices vertices = Vertices(VertexMode.triangles, [Offset(radius/2, radius), Offset(radius, radius * 3), Offset(radius+radius/2, radius)]);
  canvas.drawVertices(vertices, BlendMode.color, paint);

  textPainter.text = TextSpan(
    text: clusterSize.toString(),
    style: TextStyle(
      fontSize: radius,
      fontWeight: FontWeight.bold,
      color: textColor,
    ),
  );

  textPainter.layout();
  textPainter.paint(
    canvas,
    Offset(
      radius - textPainter.width / 2,
      radius - textPainter.height / 2,
    ),
  );

  final image = await pictureRecorder.endRecording().toImage(
    radius.toInt() * 2,
    radius.toInt() * 3,
  );

  final data = await image.toByteData(format: ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
}
