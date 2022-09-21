import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class TimeState extends ChangeNotifier {
  Timer? _timer;

  TimeState() {
    setup();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void setup() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isSet) {
        _startingTime = DateTime.now();
        notifyListeners();
      } else if (!_isInPast && _startingTime.isBefore(DateTime.now())) {
        // _startingTime = DateTime.now();
        _isInPast = true;
        notifyListeners();
      }
    });
  }

  /// Starting Time
  DateTime _startingTime = DateTime.now();
  bool _isSet = false;
  bool _isInPast = false;
  bool get isInPast => _isInPast;

  set startingTime(DateTime t) {
    _startingTime = t;
    _isSet = true;
    _isInPast = false;
    notifyListeners();
  }

  DateTime get startingTime => _startingTime;

  Duration get startIn {
    var start = _startingTime.difference(DateTime.now());
    if (start.isNegative)
      start = Duration(seconds: 0);
    return start;
  }

  /// Ending Time
  Duration? _duration;

  set endingTime(DateTime? t) {
    if (t == null) {
      _duration = null;
      notifyListeners();
      return;
    }
    int durationInMs = t.millisecondsSinceEpoch - _startingTime.millisecondsSinceEpoch;
    _duration = Duration(milliseconds: durationInMs);
    notifyListeners();
  }

  DateTime? get endingTime {
    if (_duration == null)
      return null;
    return _startingTime.add(_duration!);
  }

  set duration(Duration? d) {
    _duration = d;
    notifyListeners();
  }

  Duration? get duration {
    return _duration;
  }
}
