import 'dart:ui';

import 'package:flutter/material.dart';

class SineWavePainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(size.width, size.height);
    var paint = Paint();
    paint.color = Colors.grey[700] ?? Colors.grey;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1.0;
    // paint.style = PaintingStyle.fill;


    canvas.drawPath(SunPath.drawPath(size, false), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
  
}

class SineWaveClipper extends CustomClipper<Path> {
  bool invert;
  SineWaveClipper({required this.invert});

  @override
  Path getClip(Size size) {
    return SunPath.drawPath(size, this.invert);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }

}


class SunPath {
  static Path drawPath(Size size, bool invert) {
    var path = Path();
    path.moveTo(0, size.height);

    path.cubicTo(size.width/2 * 0.3642, size.height, size.width/2 * 0.6358, 0          , size.width/2, 0);
    path.cubicTo(size.width/2 * 1.3642, 0          , size.width/2 * 1.6358, size.height, size.width, size.height);

    if (invert) {
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      // path.close();
    }
    return path;
  }

  static Offset calculate(double value, Size size) {
    PathMetrics pathMetrics = drawPath(size, false).computeMetrics();
    PathMetric pathMetric = pathMetrics.elementAt(0);
    value = pathMetric.length * value;
    Tangent? pos = pathMetric.getTangentForOffset(value);
    return pos?.position ?? Offset(0, 0);
  }
}