import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  final Offset pointB;

  CurvePainter(this.pointB);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.indigo;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

    var path = Path();
    var pointA = Offset(0, size.height / 2);

    path.moveTo(pointA.dx, pointA.dy);

    path.cubicTo(
      pointA.dx + (pointB.dx - pointA.dx) * 0.5,
      pointA.dy,
      pointA.dx + (pointB.dx - pointA.dx) * 0.5,
      pointB.dy,
      pointB.dx,
      pointB.dy,
    );


    canvas.drawPath(path, paint);
  }

  void point(Path path, Size size, int x, int y) {
    // path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
