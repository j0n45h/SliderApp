import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/ramping_point.dart';

class CubitRampingPoint {
  bool initialized = false;
  bool processed = false;
  bool touched = false;
  double intervalValue;
  double startValue;
  double endValue;

  RampingPoint _notInitializedPoint;

  CubitRampingPoint(
      {@required RampingPoint newRampingPoint,
      BuildContext context,
      Size size}) {

    _notInitializedPoint = newRampingPoint;

    if (!(size == null && context == null)) {
      initializePoint(context, size);
    }
  }

  void initializePoint(BuildContext context, Size size) {

    final intervalProvider =
    Provider.of<IntervalRangeState>(context, listen: false);
    this.intervalValue = map(
      _notInitializedPoint.interval,
      intervalProvider.getNiceValues().niceMin,
      intervalProvider.getNiceValues().niceMax,
      size.height,
      0,
    );

    final timeProvider = Provider.of<TimeState>(context, listen: false);
    this.startValue = map(
      _notInitializedPoint.startTime.millisecondsSinceEpoch.toDouble(),
      timeProvider.startingTime.millisecondsSinceEpoch.toDouble(),
      timeProvider.endingTime.millisecondsSinceEpoch.toDouble(),
      0,
      size.width,
    );

    this.endValue = map(
      _notInitializedPoint.endTime.millisecondsSinceEpoch.toDouble(),
      timeProvider.startingTime.millisecondsSinceEpoch.toDouble(),
      timeProvider.endingTime.millisecondsSinceEpoch.toDouble(),
      0,
      size.width,
    );

    initialized = true;
  }

  double getInterval(BuildContext context, Size size) {
    final provider = Provider.of<IntervalRangeState>(context, listen: false);
    return map(
      intervalValue,
      0,
      size.height,
      provider.getNiceValues().niceMax,
      provider.getNiceValues().niceMin,
    );
  }

  DateTime getStartTime(BuildContext context, Size size) {
    return _getTime(context, size, startValue);
  }

  DateTime getEndTime(BuildContext context, Size size) {
    return _getTime(context, size, endValue);
  }

  DateTime _getTime(BuildContext context, Size size, double time) {
    final provider = Provider.of<TimeState>(context);
    final timeSinceEpoch = map(
      time,
      0,
      size.width,
      provider.startingTime.millisecondsSinceEpoch.toDouble(),
      provider.endingTime.millisecondsSinceEpoch.toDouble(),
    ).round();
    return DateTime.fromMillisecondsSinceEpoch(timeSinceEpoch);
  }
}
