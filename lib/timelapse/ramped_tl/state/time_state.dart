import 'dart:async';

import 'package:flutter/foundation.dart';

class TimeState extends ChangeNotifier {
  Timer timer;
  TimeState() {
    setup();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void setup() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isSet) {
        _startingTime = DateTime.now();
        notifyListeners();
      }
      else if (_startingTime.isBefore(DateTime.now())) {
        _startingTime = DateTime.now();
        notifyListeners();
      }
    });
  }


  /// Starting Time
  DateTime _startingTime;
  bool _isSet = false;
  set startingTime (DateTime t) {
    _startingTime = t;
    _isSet = true;
    notifyListeners();
  }
  DateTime get startingTime => _startingTime;


  /// Ending Time
  DateTime _endingTime;
  set endingTime (DateTime t) {
    _endingTime = t;
    notifyListeners();
  }
  DateTime get endingTime => _endingTime;

  Duration get duration {
    return _endingTime.difference(_startingTime);
  }
}









