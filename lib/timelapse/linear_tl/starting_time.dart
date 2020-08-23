import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/utilities/clickable_framed_text_field.dart';
import 'package:sliderappflutter/utilities/switch.dart';
import 'package:sliderappflutter/utilities/text_style.dart';
import 'package:sliderappflutter/utilities/timepicker.dart';

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
    if (StartTime.picked) {
      if (StartTime.time.isBefore(DateTime.now()))
        StartTime.time = DateTime.now();
      _startTime = StartTime.time;
    }
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
    final timePicker = TimePicker(
      context: context,
      hintPickedNextDay: true,
      initialTime: StartTime.time != null
          ? TimeOfDay.fromDateTime(StartTime.time)
          : null,
    );

    final pickedTime = await timePicker.show();

    if (pickedTime == null)
      return;

    setState(() {
      StartTime.time = pickedTime;
      StartTime.picked = true;
      calcTime();
    });
  }

  DateTime timeOfDayToDateTime(TimeOfDay t) {
    final now = DateTime.now();
    var dateTime = DateTime(now.year, now.month, now.day, t.hour, t.minute);
    print(dateTime.toString());
    if (dateTime.isBefore(now)) {
      // dateTime.add(Duration(days: 1)); // is not working
      dateTime = DateTime(now.year, now.month, now.day + 1, t.hour, t.minute);
    }
    print(dateTime.toString());
    return dateTime;
  }
}
