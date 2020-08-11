import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/utilities/clickable_framed_text_field.dart';
import 'package:sliderappflutter/utilities/custom_text_editing_controller.dart';
import 'package:sliderappflutter/utilities/switch.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class StartingTime extends StatefulWidget {
  StartingTime(Key key) : super(key: key);
  @override
  StartingTimeState createState() => StartingTimeState();
}

class StartingTimeState extends State<StartingTime> {
  bool boolean = false;
  var _startHoursTEC = CustomTextEditingController();
  var _startMinutesTEC = CustomTextEditingController();
  var _endHoursTSC = CustomTextEditingController();
  var _endMMinutesTSC = CustomTextEditingController();
  Timer _timer;

  @override
  void initState() {
    calcTime();
    _timer = Timer.periodic(
      Duration(seconds: 10),
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
    DateTime sTime;
    if (StartTime.picked)
      sTime = StartTime.time;
    else
      sTime = DateTime.now();

    // Set fist TF
    _startHoursTEC.text = sTime.hour.toString();
    _startMinutesTEC.text = sTime.minute.toString();

    // Calc ending time and set second TF
    var endTime = sTime.add(TLDuration.duration);
    _endHoursTSC.text = endTime.hour.toString();
    _endMMinutesTSC.text = endTime.minute.toString();
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
              ClickableFramedTF(
                // TODO change to Text widget and add AM/PM
                hoursTEC: _startHoursTEC,
                minutesTEC: _startMinutesTEC,
                width: 95,
                tfWidth: 25,
                onTap: _showTimePicker,
              ),
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8),
                child: Text(
                  '-',
                  style: MyTextStyle.fet(fontSize: 12),
                ),
              ),
              ClickableFramedTF(
                hoursTEC: _endHoursTSC,
                minutesTEC: _endMMinutesTSC,
                width: 95,
                tfWidth: 25,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showTimePicker() async { // TODO make ios and Android different
    if (StartTime.time == null) StartTime.time = DateTime.now();

    final picked = await showTimePicker( // TODO change theme color to match design
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
