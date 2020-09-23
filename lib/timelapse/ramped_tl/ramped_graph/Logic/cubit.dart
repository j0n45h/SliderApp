import 'dart:math';

import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:replay_cubit/replay_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';

class RampCurveCubit extends ReplayCubit<List<CubitRampingPoint>> {
  Size globalSize;
  bool isCreated = false;
  bool wasOpened = false;
  RampCurveCubit() : super(List.empty(growable: true));

  @override
  void onTransition(Transition<List<CubitRampingPoint>> transition) {
    // print("currentState Transition: ${transition.currentState}");
    // print("nextState Transition:    ${transition.nextState}");
    super.onTransition(transition);
  }

  void add(CubitRampingPoint newPoint) {
    var newState = [...state];
    newState.add(newPoint);
    emit(newState);
  }

  void addList(List<CubitRampingPoint> newPoints) {
    var newState = [...state];
    newState.addAll(newPoints);
    emit(newState);
  }

  void onDragInterval(int index, double delta, BuildContext context) {
    if (globalSize == null)
      return;
    var oldValue = state[index].getIntervalValue(context, globalSize);
    var newValue = oldValue + delta;

    var newState = [...state];
    newState[index].setIntervalValue(newValue, context, globalSize);
    emit(newState);
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


  int getShots() {
    if (state.length < 1 || globalSize == null)
      return 0;

    double shotsValue = 0;
    for (int i = 0; i < state.length - 1; i++) {

      final intervalAtPoint = state[i].interval.inMilliseconds / 1000;
      final pointA = Point<double>(state[i].end.inSeconds.toDouble(), intervalAtPoint);

      final pointB = Point<double>(state[i + 1].start.inSeconds.toDouble(), state[i + 1].interval.inMilliseconds / 1000);

      // linear part
      shotsValue += (state[i].end.inSeconds - state[i].start.inSeconds) / intervalAtPoint;

      final dt = pointB.x - pointA.x; // difference of x (time)
      final dT = pointB.y - pointA.y; // difference of y (interval)

      // ramp part
      final ramp =
          (dt * log(pointA.y * dt - pointA.x * dT + dT * pointB.x))/dT -
          (dt * log(pointA.y * dt - pointA.x * dT + dT * pointA.x))/dT; // integral of linearSpline
      // print('index: $i ramp: $ramp'); // Gets NaN when all on top
      shotsValue += ramp;
    }

    // last linear part
    shotsValue += (state.last.end.inSeconds - state.last.start.inSeconds) / (state.last.interval.inMilliseconds / 1000);

    if (shotsValue.isInfinite)
      shotsValue = double.maxFinite;
    else if (shotsValue.isNaN)
      shotsValue = 0;

    return shotsValue.round();
  }

  void recreatePoints(BuildContext context, {bool forceInclude = false}) {
    final timeState = Provider.of<TimeState>(context, listen: false);
    if (timeState.endingTime == null)
      return;

    bool excludeInterval = false;
    List<CubitRampingPoint> list = [];


    final rampPointsCount = Provider.of<RampingPointsState>(context, listen: false);
    if (rampPointsCount.rampingPoints == state.length && isCreated && !forceInclude)
      excludeInterval = true;

    // interval
    final intervalRangState = Provider.of<IntervalRangeState>(context, listen: false);
    final intervalDelta = intervalRangState.intervalRange.end - intervalRangState.intervalRange.start;

    // Time
    final midTimePoints = 2 * rampPointsCount.rampingPoints - 1;
    final timeStep = (timeState.duration.inSeconds / midTimePoints).round();
    int startTime = 0;

    for (int i=0; i < rampPointsCount.rampingPoints; i++) {
      int interval;
      if (excludeInterval) { // use prev interval
        interval = state[i].interval.inMilliseconds;
      }
      else { // create new interval
        interval = ((intervalRangState.intervalRange.start
            + intervalDelta * 0.3 * i % 2
            + intervalDelta * 0.7 * ((i + 1) % 2)) * 1000).round();
      }

      list.add(CubitRampingPoint(
        interval: Duration(milliseconds: interval),
        start: Duration(seconds: startTime),
        end: Duration(seconds: startTime + timeStep),
      ));

      startTime += 2 * timeStep;
    }

    state.clear();
    addList(list);
    isCreated = true;
  }

}