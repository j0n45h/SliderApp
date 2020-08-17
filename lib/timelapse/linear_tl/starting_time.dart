import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/utilities/clickable_framed_text_field.dart';
import 'package:sliderappflutter/utilities/switch.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class StartingTime extends StatefulWidget {
  StartingTime(Key key) : super(key: key);

  @override
  StartingTimeState createState() => StartingTimeState();
}

class StartingTimeState extends State<StartingTime> {
  Timer _timer;
  DateTime _startTime, _endTime;

  @override
  void initState() {
    calcTime();
    _timer = Timer.periodic(
      Duration(seconds: 2),
      (Timer t) => setState(
        () {
          if (!StartTime.picked) calcTime();
        },
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void calcTime() {
    // if time is not picked use current time
    if (StartTime.picked)
      _startTime = StartTime.time;
    else
      _startTime = DateTime.now();

    // Calc ending time and set second TF
    _endTime = _startTime.add(TLDuration.duration);
  }

  @override
  Widget build(BuildContext context) {
    calcTime();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            MySwitch(
              value: StartTime.picked,
              onChanged: (bool value) {
                print(value);
                setState(() {
                  StartTime.picked = !StartTime.picked;
                });
              },
            ),
            const SizedBox(width: 0),
            Text(
              'STARTING TIME',
              style: MyTextStyle.normal(fontSize: 12, letterSpacing: 1.3),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Row(
            children: <Widget>[
              ClickableFramedTimeField(
                time: _startTime,
                onTap: () => _showTimePicker(context),
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '-',
                  style: MyTextStyle.fet(fontSize: 12),
                ),
              ),
              ClickableFramedTimeField(
                time: _endTime,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    // TODO make ios and Android different
    if (StartTime.time == null) StartTime.time = DateTime.now();

    final picked = await showTimePicker(
      // TODO change theme color to match design
      builder: (context, widget) {
        return Theme(
          data: ThemeData(
            primarySwatch: Colors.lime,
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
      context: context,
      initialTime: TimeOfDay.fromDateTime(StartTime.time),
      helpText: 'The Time you want the Timelapse to start at',
    );
    if (picked != null) {
      setState(() {
        StartTime.time = timeOfDayToDateTime(picked);
        calcTime();
        StartTime.picked = true;
      });
    }
  }

  DateTime timeOfDayToDateTime(TimeOfDay t) {
    final now = DateTime.now();
    var dateTime = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    if (dateTime.isBefore(now)) dateTime.add(Duration(days: 1));
    return dateTime;
  }
}
