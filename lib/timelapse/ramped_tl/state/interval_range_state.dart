import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/niceScale.dart';

class IntervalRangeState extends ChangeNotifier {
  RangeValues _intervalRange = RangeValues(3, 15);
  NiceScale _niceScale;
  bool _upToDate = false;

  set intervalRange (RangeValues rangeValues) { // TODO: difference between min and max at least 3 Seconds
    _intervalRange = rangeValues;
    _upToDate = false;
    notifyListeners();
  }

  RangeValues get intervalRange => _intervalRange;


  /// Slider Handling
  set intervalRangeSlider (RangeValues rangeValues) {
    _intervalRange = RangeValues(
      _parseValueUp(rangeValues.start),
      _parseValueUp(rangeValues.end),
    );
    _upToDate = false;
    notifyListeners();
  }

  RangeValues get intervalRangeSlider {
    var start = _parseValeDown(_intervalRange.start) /* * 0.01 */;
    var end   = _parseValeDown(_intervalRange.end) /* * 0.01 */;

    return RangeValues(start, end);
  }

  double _parseValueUp(double newValue) {
    return 99 * (newValue * newValue) + 1;
  }

  double _parseValeDown(double value) {
    if (value > 100)
      value = 100;
    return sqrt((value - 1) / 99);
  }

  /// Nice  Scaling
  void _calcNiceValues() {
    _niceScale = NiceScale(_intervalRange.start, _intervalRange.end, 5);
    _upToDate = true;
  }

  NiceScale get niceScale {
    if (!_upToDate || _niceScale == null)
      _calcNiceValues();

    return _niceScale;
  }

}