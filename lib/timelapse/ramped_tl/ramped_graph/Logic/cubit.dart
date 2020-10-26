import 'dart:math';

import 'package:cubit/cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:replay_cubit/replay_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';

class RampCurveCubit extends ReplayCubit<List<CubitRampingPoint>> {
  Size globalSize;
  bool isCreated = false;
  bool wasOpened = false;
  List<int> _revert = [0];

  RampCurveCubit() : super(List.empty(growable: true));

  static List<CubitRampingPoint> init(){ // TODO: check if necessary
    List<CubitRampingPoint> list = [];

    for (int i=0; i < 5; i++) {
      list.add(null);
//      list.add(CubitRampingPoint(
//        interval: Duration(milliseconds: 0),
//        start: Duration(seconds: 0),
//        end: Duration(seconds: 0),
//      ));
    }

    return list;
  }

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
    final oldValue = state[index].getIntervalValue(context, globalSize);
    final newValue = oldValue + delta;

    var newState = [...state];
    newState[index].setIntervalValue(newValue, context, globalSize);
    emit(newState);
  }

  void onDragStartTime(int index, double delta, BuildContext context) {
    if (globalSize == null)
      return;
    final oldValue = state[index].getStartValue(context, globalSize);
    var newValue = oldValue + delta;

    final previousPointValue = state[index-1].getEndValue(context, globalSize);
    final nextPointValue = state[index].getEndValue(context, globalSize);
    if (newValue - 70 < previousPointValue) // prevent this point to be before previous Point
      newValue = previousPointValue + 70;
    else if (newValue + 70 > nextPointValue) // prevent this point to be after next Point
      newValue =  nextPointValue - 70;

    var newState = [...state];
    newState[index].setStartValue(newValue, context, globalSize);
    emit(newState);
  }

  void onDragEndTime(int index, double delta, BuildContext context) {
    if (globalSize == null)
      return;
    final oldValue = state[index].getEndValue(context, globalSize);
    var newValue = oldValue + delta;

    final previousPointValue = state[index].getStartValue(context, globalSize);
    final nextPointValue = state[index+1].getStartValue(context, globalSize);
    if (newValue - 70 < previousPointValue) // prevent this point to be before previous Point
      newValue = previousPointValue + 70;
    else if (newValue + 70 > nextPointValue) // prevent this point to be after next Point
      newValue =  nextPointValue - 70;

    var newState = [...state];
    newState[index].setEndValue(newValue, context, globalSize);
    emit(newState);
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

    final points = getPointsAsShots(context);

    return points.last.end;
  }


  List<Points> getPointsAsShots(BuildContext context) {
    final rampPointsCount = Provider.of<RampingPointsState>(context, listen: false).rampingPoints;

    List<Points> points = List(rampPointsCount);

    double shotsValue = 0;
    for (int i=0; i < rampPointsCount; i++) {
      final intervalAtPoint = state[i].interval.inMilliseconds / 1000;
      final start = shotsValue;

      // linear part
      shotsValue += (state[i].end.inSeconds - state[i].start.inSeconds) / intervalAtPoint;

      points[i] = Points(interval: intervalAtPoint, start: start.round(), end: shotsValue.round());

      if (i == rampPointsCount -1) // last point there is no ramping to next point
        break;

      final pointA = Point<double>(state[i].end.inSeconds.toDouble(), intervalAtPoint);

      final pointB = Point<double>(state[i + 1].start.inSeconds.toDouble(), state[i + 1].interval.inMilliseconds / 1000);


      final dt = pointB.x - pointA.x; // difference of x (time)
      final dT = pointB.y - pointA.y; // difference of y (interval)

      // ramp to next point
      if (dT == 0) { // avoid div by 0 when dT is 0
        shotsValue += (pointB.x - pointA.x) / intervalAtPoint;
      }
      else {
        final ramp =
            (dt * log(pointA.y * dt - pointA.x * dT + dT * pointB.x)) / dT -
                (dt * log(pointA.y * dt - pointA.x * dT + dT * pointA.x)) / dT; // integral of linearSpline
        shotsValue += ramp;
      }
    }
    return points;
  }

  void recreatePoints(BuildContext context) {
    final timeState = Provider.of<TimeState>(context, listen: false);
    if (timeState.endingTime == null)
      return;

    List<CubitRampingPoint> list = [];

    final rampPointsCount = Provider.of<RampingPointsState>(context, listen: false).rampingPoints;

    // interval
    final intervalRange = Provider.of<IntervalRangeState>(context, listen: false).intervalRange;
    final intervalDelta = intervalRange.end - intervalRange.start;

    // Time
    final midTimePoints = 2 * rampPointsCount - 1;
    final timeStep = (timeState.duration.inSeconds / midTimePoints).round();
    int startTime = 0;

    for (int i=0; i < rampPointsCount; i++) {
      int interval;
      if (i < state.length) { // use prev interval
        interval = state[i].interval.inMilliseconds;
      }
      else { // create new interval
        interval = ((intervalRange.start
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

  void updatePoints(BuildContext context) {
    final timeState = Provider.of<TimeState>(context, listen: false);
    if (timeState.endingTime == null)
      return;

    List<CubitRampingPoint> list = [...state];

    final rampPointsCount = Provider.of<RampingPointsState>(context, listen: false).rampingPoints;

    // interval
    final intervalRange = Provider.of<IntervalRangeState>(context, listen: false).intervalRange;
    final intervalDelta = intervalRange.end - intervalRange.start;

    // Time
    final midTimePoints = 2 * rampPointsCount - 1;
    final timeStep = (timeState.duration.inSeconds / midTimePoints).round();
    int startTime = 0;

    while(list.length < rampPointsCount) {
      list.add(CubitRampingPoint(
        interval: null,
        start: null,
        end: null,
      ));

    }

    for (int i=0; i < rampPointsCount; i++) {
      if (list[i].interval == null)
        list[i].interval = Duration(milliseconds:
            ((intervalRange.start + intervalDelta * 0.3 * i % 2
            + intervalDelta * 0.7 * ((i + 1) % 2)) * 1000).round());


      list[i].start = Duration(seconds: startTime);
      list[i].end = Duration(seconds: startTime + timeStep);

      startTime += 2 * timeStep;
    }

    state.clear();
    addList(list);
    isCreated = true;
  }

  void trimPoints(BuildContext context) {
    List<CubitRampingPoint> list = [...state];
    final rampPointsCount = Provider.of<RampingPointsState>(context, listen: false).rampingPoints;
    final intervalRange = Provider.of<IntervalRangeState>(context, listen: false).intervalRange;

    for (int i=0; i < rampPointsCount; i++) {
      if (list[i].interval.inMilliseconds/1000 < intervalRange.start)
        list[i].interval = Duration(milliseconds: (intervalRange.start * 1000).ceil());
      else  if (list[i].interval.inMilliseconds/1000 > intervalRange.end)
        list[i].interval = Duration(milliseconds: (intervalRange.end * 1000).floor());
    }
    state.clear();
    addList(list);
  }

 /* void incrementList(BuildContext context) {
    List<CubitRampingPoint> list = [...state];
    final rampPointsCount = Provider.of<RampingPointsState>(context, listen: false);
    final timeState = Provider.of<TimeState>(context, listen: false);

    // Time
    final midTimePoints = 2 * rampPointsCount.rampingPoints - 1;
    final timeStep = (timeState.duration.inSeconds / midTimePoints).round();
    int startTime = 0;

    for (int i=0; i<list.length; i++) { // rearrange time of points
      list[i].start = Duration(seconds: startTime);
      list[i].end = Duration(seconds: startTime + timeStep);

      startTime += 2 * timeStep;
    }

    // Add point
    final intervalRangState = Provider.of<IntervalRangeState>(context, listen: false);
    final intervalDelta = intervalRangState.intervalRange.end - intervalRangState.intervalRange.start;
    final interval = ((intervalRangState.intervalRange.start
        + intervalDelta * 0.3 * list.length % 2
        + intervalDelta * 0.7 * ((list.length + 1) % 2)) * 1000).round();

    list.add(CubitRampingPoint(
      interval: Duration(milliseconds: interval),
      start: Duration(seconds: startTime),
      end: Duration(seconds: startTime + timeStep),
    ));

    state.clear();
    addList(list);
    isCreated = true;
  }*/

  @override
  void emit(List<CubitRampingPoint> state) {
    _revert.last++;
    super.emit(state);
  }

  void newEvent() {
    _revert.add(0);
  }

  void myUndo() {
    for (int i=0; i<_revert.last*2; i++)
      undo();
    _revert.removeLast();
  }

}