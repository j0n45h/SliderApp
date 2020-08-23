import 'package:flutter/foundation.dart';

class TimeState extends ChangeNotifier {
  TimeState() {
    setup();
  }

  void setup() {
    _startingTime = DateTime.now();
  }


  /// Starting Time
  DateTime _startingTime;
  set startingTime (DateTime t) {
    _startingTime = t;
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









