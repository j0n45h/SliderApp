import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

double map(double x, double inMin, double inMax, double outMin, double outMax) {
  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}

String timeToString(BuildContext context, DateTime time) {
  if (time == null)
    return '-- : --';
  if (MediaQuery.of(context).alwaysUse24HourFormat)
    return DateFormat.Hm().format(time);
  else
    return DateFormat.jm().format(time);
}