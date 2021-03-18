import 'dart:math';

class NiceScale {
  double _niceMin = 1, _niceMax = 1;
  double _tickSpacing = 1;

  double get tickSpacing { return _tickSpacing; }
  double get niceMin { return _niceMin; }
  double get niceMax { return _niceMax; }

  double _minPoint = 1, _maxPoint = 1;
  double _maxTicks = 1;
  double _range = 1;

  NiceScale(double minP, double maxP, double maxTicks) {
    _minPoint = minP;
    _maxPoint = maxP;
    _maxTicks = maxTicks;

    if (_maxTicks < 2)
      _maxTicks = 2;

    _calculate();
  }

  void _calculate(){
    _range = _niceNum(_maxPoint - _minPoint, false);
    _tickSpacing = _niceNum(_range / (_maxTicks - 1), true);
    if (_tickSpacing == 0)
      _tickSpacing = 1;

    _niceMin = _calcMin();
    _niceMax = _calcMax();
  }

  double _calcMin() {
    int floored = (_minPoint / _tickSpacing).floor();
    return floored * _tickSpacing;
  }

  double _calcMax() {
    int ceiled = (_maxPoint / _tickSpacing).ceil();
    return ceiled * _tickSpacing;
  }

  double _niceNum(double range, bool round){
    double exponent; /** exponent of range */
    double fraction; /** fractional part of range */
    double niceFraction; /** nice, rounded fraction */

    exponent = (log(range)/ln10).floor().toDouble();
    fraction = range / pow(10, exponent);

    if (round)
    {
      if (fraction < 1.5)
        niceFraction = 1;
      else if (fraction < 3)
        niceFraction = 2;
      else if (fraction < 7)
        niceFraction = 5;
      else
        niceFraction = 10;
    }
    else
    {
      if (fraction <= 1)
        niceFraction = 1;
      else if (fraction <= 2)
        niceFraction = 2;
      else if (fraction <= 5)
        niceFraction = 5;
      else
        niceFraction = 10;
    }

    return niceFraction * pow(10, exponent);
  }
}
