import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:package_info/package_info.dart';


const double app_bar_height = 0.25; // % of screen height


//DARK MODE COLORS -------------------OLD---------------------
const Color color_dark_background = Color(0xff151515);
const Color color_dark_card_old = Color(0xff1C1C1C);
const Color color_dark_text_highlight = Color(0xffE3C36F);
const Color color_dark_text_dark = Color(0xff555555);
const Color color_dark_button_green = Color(0xff61B25F);
//const Color color_dark_error = Color(0xffAF3232);


//LIGHT MODE COLORS
const Color color_light_gradient_main_1 = Color(0xff69C6BB);
const Color color_light_gradient_main_2 = Color(0xff28AFCD);
const Color color_light_main = Color(0xff55BFC0);
const Color color_light_background = Color(0xfffBfBfB);
const Color color_light_text_header = Color(0xff535353);
const Color color_light_text_background = Color(0x99ffffff);
const Color color_light_highlight = Color(0xffF5F5F5);
const Color color_light_secondary_highlight = Color(0xff69F877);
const Color color_light_shadow = Color(0x33000000);
const Color color_light_splash = Color(0x33ffffff);
const Color color_light_card = Color(0x00222222);
const Color color_light_error = Color(0xffD13039);

//DARK MODE COLORS
const Color color_dark_gradient_main_1 = Color(0xff141414);
const Color color_dark_gradient_main_2 = Color(0xff141414);
const Color color_dark_main = Color(0xffE3C36F);
const Color color_dark_background_temp = Color(0xff0E0E0E);
const Color color_dark_text_header = Color(0xff535353);
const Color color_dark_text_background = Color(0xff444444);
const Color color_dark_highlight = Color(0xffE3C36F);
const Color color_dark_secondary_highlight = Color(0xff69F877);
const Color color_dark_shadow = Color(0x11ffffff);
const Color color_dark_splash = Color(0x11ffffff);
const Color color_dark_card = Color(0xff1C1C1C);
const Color color_dark_error = Color(0xffD13039);

const light_gradient_main = LinearGradient(
    begin: Alignment(-0.5, 0.3),
    end: Alignment(1.5, 0.7),
    colors: [
      color_light_gradient_main_1,
      color_light_gradient_main_2,
    ]
);
const light_gradient_run_button = LinearGradient(
    begin: Alignment(-0.5, 0.3),
    end: Alignment(1.5, 0.7),
    colors: [
      color_light_gradient_main_1,
      color_light_gradient_main_2,
    ]
);

const textLightHeader = TextStyle(
    fontSize: 22,
    color: color_light_text_header,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.bold
);
const textLightHeader2 = TextStyle(
    fontSize: 20,
    color: color_light_text_header,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textLightHeaderInvertBold = TextStyle(
    fontSize: 28,
    color: color_light_background,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.bold
);
const textLightHeaderInvert = TextStyle(
    fontSize: 28,
    color: color_light_background,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textLightHeaderInvert2 = TextStyle(
    fontSize: 20,
    color: color_light_background,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textLightBackground = TextStyle(
    fontSize: 20,
    color: color_light_text_background,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textLightLabel = TextStyle(
  fontSize: 12,
  color: color_light_text_background,
  fontFamily: 'Roboto',
);
const textLightGoal = TextStyle(
    fontSize: 18,
    color: color_light_background,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);


//DARK MODE COLORS

const dark_gradient_main = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(1, 1),
    colors: [
      color_dark_gradient_main_1,
      color_dark_gradient_main_2,
    ]
);
const dark_gradient_run_button = LinearGradient(
    begin: Alignment(0, 0),
    end: Alignment(1, 1),
    colors: [
      color_dark_secondary_highlight,
      color_dark_secondary_highlight,
    ]
);

const textDarkHeader = TextStyle(
    fontSize: 22,
    color: color_dark_text_header,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.bold
);
const textDarkHeader2 = TextStyle(
    fontSize: 20,
    color: color_dark_text_header,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textDarkHeaderInvertBold = TextStyle(
    fontSize: 28,
    color: color_dark_text_header,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.bold
);
const textDarkHeaderInvert = TextStyle(
    fontSize: 28,
    color: color_dark_highlight,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textDarkHeaderInvert2 = TextStyle(
    fontSize: 20,
    color: color_dark_highlight,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textDarkBackground = TextStyle(
    fontSize: 20,
    color: color_dark_text_background,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);
const textDarkLabel = TextStyle(
  fontSize: 12,
  color: color_dark_text_background,
  fontFamily: 'Roboto',
);
const textDarkGoal = TextStyle(
    fontSize: 18,
    color: color_dark_highlight,
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w300
);




String map_theme_light = '';
String map_theme_dark = '';

loadMapThemes() async {
  if(map_theme_light.isEmpty) {
    String file = 'assets/map_theme_light.json';
    rootBundle.loadString(file).then((string) {
      map_theme_light = string;
    });
  }

  if(map_theme_dark.isEmpty) {
    String file = 'assets/map_theme.json';
    rootBundle.loadString(file).then((string) {
      map_theme_dark = string;
    });
  }
}




FlatButton button({String text, Color borderColor, Color textColor, Color splashColor, Function onTap, double borderRadius = 18.0}) {
  if(splashColor == null) splashColor = borderColor;
  return FlatButton(
    onPressed: onTap,
    child: Text(text,),
    color: Colors.transparent,
    highlightColor: splashColor,
    focusColor: splashColor,
    hoverColor: splashColor,
    textColor: textColor,
    splashColor: splashColor,
    shape: RoundedRectangleBorder(
      side: BorderSide(width: 1, color: borderColor),
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
    ),
  );
}










// -------------------OLD---------------------

const textStyleDark = TextStyle(
    fontSize: 12,
    fontFamily: 'Roboto',
    color: color_dark_text_dark,
);
const textStyleDarkLight = TextStyle(
  color: color_dark_text_dark,
  fontFamily: 'RobotoLight',
);
const textStyleDarkLightLarge = TextStyle(
  color: color_dark_text_dark,
  fontFamily: 'Quicksand',
  fontSize: 20,
);
const textStyleHeader = TextStyle(
  fontSize: 28,
  fontFamily: 'Quicksand',
  color: color_dark_text_highlight,
);
const textStyleHeaderLarge = TextStyle(
  fontSize: 35,
  fontFamily: 'Quicksand',
  color: color_dark_text_highlight,
);
const textStyleHeaderSmall = TextStyle(
  fontSize: 20,
  fontFamily: 'Quicksand',
  color: color_dark_text_highlight,
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
  return '$year-$month-$day${date.length > 8 ? ' $minute:$second' : ''}';
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
