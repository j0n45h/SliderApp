import 'dart:async';

import 'package:flutter/foundation.dart';

class TimeState extends ChangeNotifier {
  Timer _timer;

  TimeState() {
    setup();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setup() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isSet) {
        _startingTime = DateTime.now();
        notifyListeners();
      } else if (_startingTime.isBefore(DateTime.now())) {
        _startingTime = DateTime.now();
        notifyListeners();
      }
    });
  }

  /// Starting Time
  DateTime _startingTime;
  bool _isSet = false;

  set startingTime(DateTime t) {
    _startingTime = t;
    _isSet = true;
    notifyListeners();
  }

  DateTime get startingTime => _startingTime;

  /// Ending Time
  Duration _duration;

  set endingTime(DateTime t) {
    int durationInMs =
        t.millisecondsSinceEpoch - _startingTime.millisecondsSinceEpoch;
    _duration = Duration(milliseconds: durationInMs);
    notifyListeners();
  }

  DateTime get endingTime {
    if (_duration == null) return null;
    return _startingTime.add(_duration);
  }

  set duration(Duration d) {
    _duration = d;
    notifyListeners();
  }

  Duration get duration {
    return _duration;
  }
}
