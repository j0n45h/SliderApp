import 'package:flutter_cubit/flutter_cubit.dart';
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
      interval.inMilliseconds/1000,
      provider.niceScale.niceMin,
      provider.niceScale.niceMax,
      size.height,
      0,
    );
  }

  void setIntervalValue(double intervalValue, BuildContext context, Size size) {
    final provider = Provider.of<IntervalRangeState>(context, listen: false);
    interval = Duration(seconds: map(
        intervalValue,
        size.height,
        0,
        provider.niceScale.niceMin,
        provider.niceScale.niceMax,
    ).round());
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
    start = Duration(seconds: map(
      startValue,
      0,
      size.width,
      provider.startingTime.millisecondsSinceEpoch / 1000,
      (provider.endingTime.millisecondsSinceEpoch - provider.startingTime.millisecondsSinceEpoch) / 1000
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
    end = Duration(seconds: map(
      endValue,
      0,
      size.width,
      provider.startingTime.millisecondsSinceEpoch / 1000,
      (provider.endingTime.millisecondsSinceEpoch - provider.startingTime.millisecondsSinceEpoch) / 1000
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
}
