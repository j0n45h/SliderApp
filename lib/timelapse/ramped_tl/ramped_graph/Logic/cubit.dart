import 'dart:math';

import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:replay_cubit/replay_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/utilities/map.dart';

class RampCurveCubit extends ReplayCubit<List<CubitRampingPoint>> {
  Size globalSize;
  RampCurveCubit() : super(List.empty(growable: true));

  @override
  void onTransition(Transition<List<CubitRampingPoint>> transition) {
    print("Transition: $transition");
    super.onTransition(transition);
  }

  void add(CubitRampingPoint newPoint) {
    state.add(newPoint);
  }

  void addList(List<CubitRampingPoint> newPoints) {
    state.addAll(newPoints);
  }

  void initializeAllPoints(BuildContext context, Size size) {
    state.forEach((point) {
      if (!point.initialized) point.initializePoint(context, size);
    });
  }

  void onDragInterval(int index, double delta) {
    state[index].intervalValue += delta;
  }

  void onDragStartTime(int index, double delta) {
    state[index].startValue += delta;
  }

  void onDragEndTime(int index, double delta) {
    state[index].endValue += delta;
  }

  void onTouchedDown(int index) {
    state[index].touched = true;
  }

  void onTouchedUp(int index) {
    state[index].touched = false;
  }

  int getShots(BuildContext context, Size size) {
    if (state.length < 1 || size == null)
      return 0;

    double shotsValue = 0;
    final startT = state[0].getStartTime(context, size);
    for (int i = 0; i < state.length - 1; i++) {
      print('shotsvalue top: $shotsValue');

      var intervalAtPoint = state[i].getInterval(context, size);
      final pointA = Point(
          state[i].getEndTime(context, size).difference(startT).inMilliseconds /
              1000, intervalAtPoint);

      final pointB = Point(
          state[i + 1].getStartTime(context, size).difference(startT)
                  .inMilliseconds / 1000,
          state[i].getInterval(context, size));

      shotsValue += (state[i].getStartTime(context, size).difference(startT)
                  .inMilliseconds / 1000) / intervalAtPoint;

      print('shotsvalue after lin: $shotsValue');
      print('pointA: $pointA; pointB: $pointB');

      final dt = pointB.x - pointA.x; // difference of x
      final dT = pointB.y - pointA.y; // difference of y
      print('dt value: $dt');
      print('dT value: $dT');

      final top = dt * dT / 2; // top triangle of graph
      print('top value: $top');
      final bottom = pointA.y * dt; // bottom square part
      print('bottom: $bottom');
      shotsValue += bottom + top;
    }

    final intervalAtPoint = state.last.getInterval(context, size);
    shotsValue += (startT.difference(state.last.getStartTime(context, size))
        .inMilliseconds / 1000) / intervalAtPoint;

    return shotsValue.round();
  }
}