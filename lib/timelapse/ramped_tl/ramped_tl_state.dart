import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliderappflutter/utilities/custom_text_editing_controller.dart';

class RampedTLState extends ChangeNotifier {
  RampedTLState() {
    setup();
  }

  void setup() {
    startingTime = DateTime.now();
  }

  /// Time
  DateTime startingTime;
  DateTime endingTime;
  Duration get duration {
    return endingTime.difference(startingTime);
  }

  /// Ramping
  int rampingPoints;
  List<int> intervalRange = [5, 15];

  /// Video Length
  static int _fpsIndex = 0;
  static const List<int> _fpsArray = [24, 25, 30, 50, 60, 100, 120];
  int get fps {
    return _fpsArray[_fpsIndex];
  }
  void toggleFPS() {
    _fpsIndex++;
    _fpsIndex %= _fpsArray.length;
    notifyListeners();
  }
  int get videoLength {
    return (shots/fps).round();
  }

  /// Shots
  int _shots;
  set shots(s) {
    _shots = s;
  }
  int get shots {
    return _shots; /// iterate through ramping points or integral of curve
  }
}