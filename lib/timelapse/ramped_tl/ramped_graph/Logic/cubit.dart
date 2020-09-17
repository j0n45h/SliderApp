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

  void onDragInterval(int index, double delta, BuildContext context) {
    if (globalSize == null)
      return;
    var oldValue = state[index].getIntervalValue(context, globalSize);
    var newValue = oldValue + delta;
    state[index].setIntervalValue(newValue, context, globalSize);
  }

  void onDragStartTime(int index, double delta, BuildContext context) {
    if (globalSize == null)
      return;
    var oldValue = state[index].getStartValue(context, globalSize);
    var newValue = oldValue + delta;
    state[index].setStartValue(newValue, context, globalSize);
  }

  void onDragEndTime(int index, double delta, BuildContext context) {
    if (globalSize == null)
      return;
    var oldValue = state[index].getEndValue(context, globalSize);
    var newValue = oldValue + delta;
    state[index].setEndValue(newValue, context, globalSize);
  }

  void onTouchedDown(int index) {
    state[index].touched = true;
  }

  void onTouchedUp(int index) {
    state[index].touched = false;
  }

  int getShots(BuildContext context) {
    if (state.length < 1 || globalSize == null)
      return 0;

    double shotsValue = 0;
    final startT = state[0].getStartTime(context, globalSize);
    for (int i = 0; i < state.length - 1; i++) {
      print('shotsvalue top: $shotsValue');

      final intervalAtPoint = state[i].interval.inSeconds;
      final pointA = Point(state[i].end.inSeconds, intervalAtPoint);

      final pointB = Point(state[i + 1].start.inSeconds, state[i + 1].interval.inSeconds);

      // linear part
      shotsValue += (state[i].end.inSeconds - state[i].start.inSeconds) / intervalAtPoint;

      print('shotsvalue after lin: $shotsValue');
      print('pointA: $pointA; pointB: $pointB');

      final dt = pointB.x - pointA.x; // difference of x (time)
      final dT = pointB.y - pointA.y; // difference of y (interval)
      print('dt value: $dt');
      print('dT value: $dT');

      // ramp part
      final ramp =
          (dt * log(pointA.y * dt - pointA.x * dT + dT * pointB.x))/dT -
          (dt * log(pointA.y * dt - pointA.x * dT + dT * pointA.x))/dT; // integral of linearSpline

      print('ramp value: $ramp');
      shotsValue += ramp;
    }

    // last linear part
    shotsValue += (state.last.end.inSeconds - state.last.start.inSeconds) / state.last.interval.inSeconds;

    return shotsValue.round();
  }
}