import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/map.dart';

class CubitRampingPoint {
  bool processed = false;
  bool touched = false;
  double intervalValue;
  double startValue;
  double endValue;

  CubitRampingPoint(
      {double interval,
      DateTime startT,
      DateTime endT,
      BuildContext context,
      Size size}) {
    final intervalProvider =
        Provider.of<IntervalRangeState>(context, listen: false);
    this.intervalValue = map(
      interval,
      intervalProvider.getNiceValues().niceMin,
      intervalProvider.getNiceValues().niceMax,
      size.height,
      0,
    );

    final timeProvider = Provider.of<TimeState>(context, listen: false);
    this.startValue = map(
      startT.millisecondsSinceEpoch.toDouble(),
      timeProvider.startingTime.millisecondsSinceEpoch.toDouble(),
      timeProvider.endingTime.millisecondsSinceEpoch.toDouble(),
      0,
      size.width,
    );

    this.endValue = map(
      endT.millisecondsSinceEpoch.toDouble(),
      timeProvider.startingTime.millisecondsSinceEpoch.toDouble(),
      timeProvider.endingTime.millisecondsSinceEpoch.toDouble(),
      0,
      size.width,
    );
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
