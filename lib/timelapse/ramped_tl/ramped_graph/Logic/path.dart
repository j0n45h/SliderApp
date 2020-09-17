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

    final intervalP0 = pointList[0].getIntervalValue(context, size);
    path.moveTo(0, intervalP0);
    path.lineTo(pointList[0].getEndValue(context, size), intervalP0);

    for (int i=1; i < pointList.length; i++){
      final currentInterval = pointList[i].getIntervalValue(context, size);
      final pointA = Point(pointList[i-1].getEndValue  (context, size), pointList[i-1].getIntervalValue(context, size));
      final pointB = Point(pointList[i  ].getStartValue(context, size), currentInterval);
      //print('at $i: pointA: $pointA; pointB: $pointB; size: $size');

      path = _pathBetween(path, pointA, pointB);
      path.lineTo(pointList[i].getEndValue(context, size), currentInterval);
    }

    path.lineTo(size.width, pointList.last.getIntervalValue(context, size));

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