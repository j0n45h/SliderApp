import 'dart:ui';

import 'package:flutter/material.dart';

class SineWavePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(size.width, size.height);
    var paint = Paint();
    paint.color = Colors.grey[700];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;
    // paint.style = PaintingStyle.fill;


    canvas.drawPath(SunPath.drawPath(size: size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  
}

class SineWaveClipper extends CustomClipper<Path> {
  bool invert;
  SineWaveClipper({this.invert});
  @override
  Path getClip(Size size) {
    return SunPath.drawPath(size: size, invert: this.invert);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}


class SunPath {
  static Path drawPath({Size size, bool invert = false}) {
    var path = Path();
    path.moveTo(0, size.height);
    path.quadraticBezierTo(size.width * 1/8, size.height, size.width * 2/8, size.height/2);
    path.quadraticBezierTo(size.width * 3/8, 0, size.width* 4/8, 0);
    path.quadraticBezierTo(size.width * 5/8, 0, size.width * 6/8, size.height/2);
    path.quadraticBezierTo(size.width * 7/8, size.height, size.width * 8/8, size.height);
    if (invert) {
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      // path.close();
    }
    return path;
  }

  static Offset calculate(value, Size size) {
    PathMetrics pathMetrics = drawPath(size: size).computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent pos = pathMetric.getTangentForOffset(value);
    return pos.position;
  }
}