import 'package:flutter/widgets.dart';

class RunningTlState with ChangeNotifier {
  int _shotsTaken = 0;
  Duration _currentInterval = Duration.zero;
  Duration _drivingTime = Duration.zero;
  final BuildContext? _internalContext;

  int get shotsTaken => _shotsTaken;
  Duration get currentInterval => _currentInterval;
  Duration get maxExposure => _currentInterval - _drivingTime;

  set rawLogAdd (String s) => _rawLog += s;
  String get log => _rawLog;
  String _rawLog = '';

  RunningTlState(this._internalContext);

  void updateValues() {
    final lines = _rawLog.split('\n');
    List<String> values = [];

    values.add(lines.lastWhere((element) => element.contains('sT'))); // shotsTaken
    values.add(lines.lastWhere((element) => element.contains('cI'))); // currentInterval
    values.add(lines.lastWhere((element) => element.contains('dT'))); // drivingTime

    values.forEach((item) {
      try {
        final keyValues = item.split(':');
        if (keyValues.length < 2)
          return;

        final key = keyValues[0].replaceAll('TLDependencies->', '').trim();
        final value = keyValues[1].trim();

        if (key.contains('sT')) {
          _shotsTaken = int.tryParse(value) ?? _shotsTaken;
        }
        else if (key.contains('cI')) {
          final seconds = double.tryParse(value) ?? 0;
          _currentInterval = Duration(
            milliseconds: (seconds * 1000).round()
          );
        }
        else if (key.contains('dT')) {
          final milliseconds = int.tryParse(value) ?? 0;
          _drivingTime = Duration(
            milliseconds: milliseconds,
          );
        }
      }
      catch (e) {
        print('Error while Parsing TL values: $e');
      }
    });

    notifyListeners();
  }

  String currentIntervalString() {
    var ret = _currentInterval.inSeconds.toString();
    ret += '.';
    ret += ((_currentInterval.inMilliseconds - _currentInterval.inSeconds * 1000)/10).round().toString();
    return ret;
  }

  String maxExposureString() {
    var ret = maxExposure.inSeconds.toString();
    ret += '.';
    ret += ((maxExposure.inMilliseconds - maxExposure.inSeconds * 1000)/10).round().toString();
    return ret;
  }

  void clearLog() {
    _rawLog = '';
    notifyListeners();
  }

  void resetAll() {
    _rawLog = '';
    _shotsTaken = 0;
    _currentInterval = Duration.zero;
    _drivingTime = Duration.zero;
  }
}