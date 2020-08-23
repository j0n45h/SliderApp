import 'package:flutter/foundation.dart';

class RampingPointsState extends ChangeNotifier {
  int _rampingPoints = 3;

  set rampingPoints (int i) {
    _rampingPoints = i;
    notifyListeners();
  }

  int get rampingPoints => _rampingPoints;
}