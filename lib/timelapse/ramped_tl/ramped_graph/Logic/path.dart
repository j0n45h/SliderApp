import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/utilities/colors.dart';


class PathClipper extends CustomClipper<Path> {
  final BuildContext context;
  final List<CubitRampingPoint> pointList;
  final int length;

  PathClipper({required this.context, required this.pointList, required this.length});

  @override
  Path getClip(Size size) {
    var path = RampPath.getPath(size, context, pointList, length, true);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // return true;
    return oldClipper != this;
  }

}

class PathPainter extends CustomPainter {
  final BuildContext context;
  final List<CubitRampingPoint> pointList;
  final int length;

  PathPainter(this.context, this.pointList, this.length);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = MyColors.slider;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

    canvas.drawPath(RampPath.getPath(size, context, pointList, length, false), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;

}



class RampPath {
  static Path getPath(Size size, BuildContext context, List<CubitRampingPoint> pointList, int length, bool close) {
    var path = Path();

    final intervalP0 = pointList[0].getIntervalValue(context, size);
    path.moveTo(0, intervalP0);
    path.lineTo(pointList[0].getEndValue(context, size), intervalP0);

    for (int i=1; i < length; i++){
      final currentInterval = pointList[i].getIntervalValue(context, size);
      final pointA = Point(pointList[i-1].getEndValue  (context, size), pointList[i-1].getIntervalValue(context, size));
      final pointB = Point(pointList[i  ].getStartValue(context, size), currentInterval);
      //print('at $i: pointA: $pointA; pointB: $pointB; size: $size');

      path = _pathBetween(path, pointA, pointB);
      path.lineTo(pointList[i].getEndValue(context, size), currentInterval);
    }

    path.lineTo(size.width, pointList[length-1].getIntervalValue(context, size));

    /// close Path
    if (close) {
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }
    return path;
  }

  static Path _pathBetween(Path path, Point pointA, Point pointB){
    path.cubicTo(
      pointA.x + (pointB.x - pointA.x) * 0.5,
      pointA.y.toDouble(),
      pointA.x + (pointB.x - pointA.x) * 0.5,
      pointB.y.toDouble(),
      pointB.x.toDouble(),
      pointB.y.toDouble(),
    );
    return path;
  }
}