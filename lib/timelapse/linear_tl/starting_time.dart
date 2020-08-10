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
          (Timer t) => setState(() {
        calcTime();
      },),);

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void calcTime() {
    _startHoursTEC.text = DateTime.now().hour.toString();
    _startMinutesTEC.text = DateTime.now().minute.toString();

    var endTime = DateTime.now().add(TLDuration.duration);
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
              value: boolean,
              onChanged: (bool value) {
                print(value);
                setState(() {
                  boolean = !boolean;
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
                  hoursTEC: _startHoursTEC,
                  minutesTEC: _startMinutesTEC,
                  width: 95,
                  tfWidth: 25,
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
}
