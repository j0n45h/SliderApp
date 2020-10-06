import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/map.dart';

class CubitRampingPoint {
  bool processed = false;
  bool touched = false;
  Duration interval;
  Duration start;
  Duration end;

  CubitRampingPoint(
      {@required this.interval,
      @required this.start,
      @required this.end,
      });

  double getIntervalValue(BuildContext context, Size size) {
    final provider = Provider.of<IntervalRangeState>(context, listen: false);
    return map(
      interval.inMicroseconds/1000000,
      provider.niceScale.niceMin,
      provider.niceScale.niceMax,
      size.height,
      0,
    );
  }

  void setIntervalValue(double intervalValue, BuildContext context, Size size) {
    // keep values in screen size
    if (intervalValue < 0)
      intervalValue = 0;
    else if (intervalValue > size.height)
      intervalValue = size.height;

    final provider = Provider.of<IntervalRangeState>(context, listen: false);
    interval = Duration(microseconds: (map(
        intervalValue,
        size.height,
        0,
        provider.niceScale.niceMin,
        provider.niceScale.niceMax,
    ) * 1000000).round());

    if (interval.inMilliseconds < 300)
      interval = Duration(milliseconds: 300);
  }


  double getStartValue(BuildContext context, Size size) {
    final provider = Provider.of<TimeState>(context, listen: false);
    return map(
        start.inSeconds.toDouble(),
        0,
        (provider.endingTime.millisecondsSinceEpoch - provider.startingTime.millisecondsSinceEpoch) / 1000,
        0,
        size.width,
    );
  }

  void setStartValue(double startValue, BuildContext context, Size size) {
    final provider = Provider.of<TimeState>(context, listen: false);
    start = Duration(milliseconds: map(
      startValue,
      0,
      size.width,
      0,
      (provider.endingTime.millisecondsSinceEpoch - provider.startingTime.millisecondsSinceEpoch).toDouble()
    ).round());
  }


  double getEndValue(BuildContext context, Size size) {
    final provider = Provider.of<TimeState>(context, listen: false);
    return map(
        end.inSeconds.toDouble(),
        0,
        (provider.endingTime.millisecondsSinceEpoch - provider.startingTime.millisecondsSinceEpoch) / 1000,
        0,
        size.width,
    );
  }

  void setEndValue(double endValue, BuildContext context, Size size) {
    final provider = Provider.of<TimeState>(context, listen: false);
    end = Duration(milliseconds: map(
      endValue,
      0,
      size.width,
      0,
      (provider.endingTime.millisecondsSinceEpoch - provider.startingTime.millisecondsSinceEpoch).toDouble()
    ).round());
  }

  DateTime getStartTime(BuildContext context, Size size) {
    final provider = Provider.of<TimeState>(context, listen: false);
    return provider.startingTime.add(start);
  }

  DateTime getEndTime(BuildContext context, Size size) {
    final provider = Provider.of<TimeState>(context, listen: false);
    return provider.startingTime.add(end);
  }

  @override
  String toString () {
    return 'interval: $interval';
  }
}
