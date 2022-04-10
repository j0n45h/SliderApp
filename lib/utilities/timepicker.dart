import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class TimePicker { // TODO make ios and Android different
  TimeOfDay? initialTime;
  final String helpText;
  final BuildContext context;
  final bool hintPickedNextDay;

  TimePicker({
    this.initialTime,
    required this.context,
    this.helpText = 'The Time you want the Timelapse to start at',
    this.hintPickedNextDay = false,
  });

  Future<DateTime?> show() async {
    initialTime ??= TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime!,
      helpText: helpText,
      builder: (context, widget) {
        return Theme(
          data: ThemeData(
              primarySwatch: Colors.lime,
              platform: TargetPlatform.iOS,
              timePickerTheme: TimePickerThemeData(
                  backgroundColor: Colors.white60,
                  dialBackgroundColor: Colors.white70,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  hourMinuteShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  dayPeriodShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  dayPeriodBorderSide: BorderSide().copyWith(width: 0.4, color: Colors.white30)
              )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: widget,
          ),
        );
      },
    );

    if (pickedTime == null)
      return null;

    return timeOfDayToDateTime(pickedTime);
  }

  void _showSnakeBar() {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      elevation: 40,
      behavior: SnackBarBehavior.fixed,
      content: Text(
        'Set Time is on next Day',
        style: MyTextStyle.fetStdSize(),
      ),
    ));
  }

  DateTime timeOfDayToDateTime(TimeOfDay t) {
    final now = DateTime.now();
    var dateTime = DateTime(now.year, now.month, now.day, t.hour, t.minute);

    if (dateTime.isBefore(now.subtract(Duration(minutes: 1)))) {
      // dateTime.add(Duration(days: 1)); // is not working
      dateTime = DateTime(now.year, now.month, now.day + 1, t.hour, t.minute);
      _showSnakeBar();
    }
    return dateTime;
  }
}