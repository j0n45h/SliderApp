import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/niceScale.dart';

class IntervalRangeState extends ChangeNotifier {
  RangeValues _intervalRange = RangeValues(3, 15);

  set intervalRange (RangeValues rangeValues) {
    _intervalRange = rangeValues;
    notifyListeners();
  }

  RangeValues get intervalRange => _intervalRange;


  /// Slider Handling
  set intervalRangeSlider (RangeValues rangeValues) {
    _intervalRange = RangeValues(
      parseValueUp(rangeValues.start),
      parseValueUp(rangeValues.end),
    );
    notifyListeners();
  }

  RangeValues get intervalRangeSlider {
    var start = _parseValeDown(_intervalRange.start) /* * 0.01 */;
    var end   = _parseValeDown(_intervalRange.end) /* * 0.01 */;

    return RangeValues(start, end);
  }

  double parseValueUp(double newValue) {
    return 99 * (newValue * newValue) + 1;
  }

  double _parseValeDown(double value) {
    if (value > 100)
      value = 100;
    return sqrt((value - 1) / 99);
  }

  /// Nice  Scaling
  NiceScale getNiceValues() {
    return NiceScale(_intervalRange.start, _intervalRange.end, 5);
  }

}