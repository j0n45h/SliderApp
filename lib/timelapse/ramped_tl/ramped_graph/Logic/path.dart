import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';


class PathClipper extends CustomClipper<Path> {
  final BuildContext context;
  final List<CubitRampingPoint> pointList;

  PathClipper({@required this.context, @required this.pointList});

  @override
  Path getClip(Size size) {
    var path = Path();

    path.moveTo(0, pointList[0].intervalValue);
    path.lineTo(pointList[0].endValue, pointList[0].intervalValue);

    for (int i=1; i < pointList.length; i++){
      final pointA = Point(pointList[i-1].endValue  , pointList[i-1].intervalValue);
      final pointB = Point(pointList[i  ].startValue, pointList[i  ].intervalValue);
      //print('at $i: pointA: $pointA; pointB: $pointB; size: $size');

      path = _pathBetween(path, pointA, pointB);
      path.lineTo(pointList[i].endValue, pointList[i].intervalValue);
    }

    path.lineTo(size.width, pointList.last.intervalValue);

    /// close Path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  Path _pathBetween(Path path, Point pointA, Point pointB){
    path.cubicTo(
      pointA.x + (pointB.x - pointA.x) * 0.5,
      pointA.y,
      pointA.x + (pointB.x - pointA.x) * 0.5,
      pointB.y,
      pointB.x,
      pointB.y,
    );
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

  PathPainter({@required this.context, @required this.pointList});

  @override
  Path paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.grey[700];
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;

    var path = Path();

    path.moveTo(0, pointList[0].intervalValue);

    for (int i=1; i < pointList.length; i++){
      final pointA = Point(pointList[i-1].intervalValue, pointList[i-1].endValue);
      final pointB = Point(pointList[i  ].intervalValue, pointList[i].startValue);

      path = _pathBetween(path, pointA, pointB);
    }

    path.lineTo(pointList.last.intervalValue, size.width);

    /// close Path
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    return path;
  }

  Path _pathBetween(Path path, Point pointA, Point pointB){
    path.cubicTo(
      pointA.x + (pointB.x - pointA.x) * 0.5,
      pointA.y,
      pointA.x + (pointB.x - pointA.x) * 0.5,
      pointB.y,
      pointB.x,
      pointB.y,
    );
    return path;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}