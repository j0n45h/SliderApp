import 'package:flutter/material.dart';

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.indigo;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    
    var path = Path();
    path.moveTo(0, size.height/2);

    path.cubicTo(size.width/4, size.height/2, size.width/4, size.height, size.width/2, size.height);
    
    canvas.drawPath(path, paint);
  }
  
  void point(Path path, Size size, int x, int y) {
    // path.cubicTo(x1, y1, x2, y2, x3, y3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}