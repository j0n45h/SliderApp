import 'package:flutter/foundation.dart';

class VideoShotsState extends ChangeNotifier {
  /// FPS
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


  /// Video Length
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