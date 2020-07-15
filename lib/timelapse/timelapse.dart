import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/starting_time.dart';
import 'package:sliderappflutter/utilities/box_decoraation_frame.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';
import 'dart:math';
import '../drawer.dart';

class TimelapseScreen extends StatefulWidget {
  static const routeName = '/timelapse-screen';

  @override
  _TimelapseScreenState createState() => _TimelapseScreenState();
}

class _TimelapseScreenState extends State<TimelapseScreen> {
  double interval; // in sec
  int videoLength; // in sec
  Duration duration = Duration(seconds: 10000);
  int shots;
  int fpsIndex = 0;
  List<int> fps = [24, 25, 30, 50, 60, 100, 120];

  static double tfHeight = 30;

  double intervalSliderValue;
  double durationSliderValue;
  final intervalTFController = TextEditingController();
  final videoLengthTFController = TextEditingController();
  final durationHoursTFController = TextEditingController();
  final durationMinutesTFController = TextEditingController();
  final shotsTFController = TextEditingController();

  FramedTF intervalLock = FramedTF.open;
  FramedTF durationLock = FramedTF.locked;
  FramedTF shotsLock = FramedTF.open;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 1.0,
          title: const Text(
            'Timelapse',
            style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
          ),
          centerTitle: true,
          backgroundColor: MyColors.AppBar,
        ),
        drawer: MyDrawer(),
        body: Stack(
          children: <Widget>[
//            Container(
//              decoration: BoxDecoration(
//                gradient: MyColors.bgRadialGradient(1),
//              ),
//            ),
            ListView(
              children: <Widget>[
                const Divider(
                  color: Colors.white,
                  thickness: 0.15,
                  height: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 25, 20, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'INTERVAL',
                            style: MyTextStyle.normal(
                                fontSize: 12.0, letterSpacing: 1.3),
                          ),
                          const SizedBox(width: 18),
                          FramedTextField(
                            width: 90,
                            height: tfHeight,
                            lock: intervalLock,
                            onLockLongPress: (FramedTF lock) {
                              setState(() {
                                intervalLock = lock;
                              });
                            },
                            textField: MyTextField(
                              fontSize: 12,
                              textController: intervalTFController,
                              unit: 's',
                              onEditingComplete: () {
                                setState(() {
                                  if (int.parse(intervalTFController.text) < 1)
                                    intervalTFController.text = '1';
                                  onIntervalSliderChanged(
                                      intervalTFController.text);
                                });
                              },
                              onTap: () {
                                intervalTFController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                    offset: intervalTFController.text.length,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 3, 44),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  fpsIndex++;
                                  if (fpsIndex >= fps.length) fpsIndex = 0;
                                  onIntervalChanged();
                                });
                              },
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                alignment: Alignment.center,
                                width: 40,
                                height: 10,
//                              padding: EdgeInsets.fromLTRB(0, 0, 0, 44),
                                //                             margin: EdgeInsets.fromLTRB(9, 0, 5, 0),
                                child: Text(
                                  (fps[fpsIndex]).toString() + 'fps',
                                  style: MyTextStyle.normal(fontSize: 10),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                'VIDEO',
                                style: MyTextStyle.normal(
                                  fontSize: 12.0,
                                  letterSpacing: 1.3,
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                borderRadius: BorderRadius.circular(22),
                                onTap: () {
                                  setState(() {
                                    fpsIndex++;
                                    if (fpsIndex >= fps.length) fpsIndex = 0;
                                    onIntervalChanged();
                                  });
                                },
                                child: FramedTextField(
                                  width: 90,
                                  height: tfHeight,
                                  textField: MyTextField(
                                    fontSize: 12,
                                    textController: videoLengthTFController,
                                    unit: 's',
                                    enabled: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Slider(
                    /// Interval Slider
                    onChanged: (double value) {
                      setState(() {
                        updateIntervalTF(value);
                      });
                    },
                    onChangeStart: (_) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    activeColor: MyColors.slider,
                    inactiveColor: Colors.grey,
                    value: this.intervalSliderValue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            'DURATION',
                            style: MyTextStyle.normal(
                                fontSize: 12.0, letterSpacing: 1.3),
                          ),
                          const SizedBox(width: 10),
                          FramedTextField(
                            width: 128,
                            height: tfHeight,
                            lock: durationLock,
                            onLockLongPress: (FramedTF lock) =>
                                durationLock = lock,
                            textField: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 36,
                                  child: MyTextField(
                                    fontSize: 12,
                                    textController: durationHoursTFController,
                                    unit: 'h',
                                    onEditingComplete: () {
                                      setState(() {
                                        if (int.parse(this
                                                .durationHoursTFController
                                                .text) <
                                            0)
                                          this.durationHoursTFController.text =
                                              '0';
                                        duration = Duration(
                                          hours: int.parse(
                                              durationHoursTFController.text),
                                          minutes: int.parse(
                                              durationMinutesTFController.text),
                                        );
                                        updateDurationSlider();
                                      });
                                    },
                                    onTap: () {
                                      durationHoursTFController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: durationHoursTFController
                                                .text.length),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  width: 52,
                                  child: MyTextField(
                                    fontSize: 12,
                                    textController: durationMinutesTFController,
                                    unit: 'min',
                                    onChanged: (String text) {
                                      // this.updateSliderValue(text);
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        var hours = int.parse(
                                            durationHoursTFController.text);
                                        var min = int.parse(
                                            durationMinutesTFController.text);

                                        if (min < 0) {
                                          durationMinutesTFController.text =
                                              '0';
                                          min = 0;
                                        }
                                        if (hours == 0 && min < 1) {
                                          durationMinutesTFController.text =
                                              '1';
                                          min = 1;
                                        }
                                        duration = Duration(
                                          hours: int.parse(
                                              durationHoursTFController.text),
                                          minutes: int.parse(
                                              durationMinutesTFController.text),
                                        );
                                        updateDurationSlider();
                                      });
                                    },
                                    onTap: () {
                                      durationMinutesTFController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: durationMinutesTFController
                                                .text.length),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            'SHOTS',
                            style: MyTextStyle.normal(
                                fontSize: 12.0, letterSpacing: 1.3),
                          ),
                          const SizedBox(width: 10),
                          FramedTextField(
                            width: 90,
                            height: tfHeight,
                            lock: shotsLock,
                            onLockLongPress: (FramedTF lock) {
                              shotsLock = lock;
                            },
                            textField: MyTextField(
                              fontSize: 12,
                              textController: shotsTFController,
                              onEditingComplete: () {
                                setState(() {
                                  if (int.parse(shotsTFController.text) < 1)
                                    shotsTFController.text = '1';
                                  shots = int.parse(shotsTFController.text);
                                  onShotsChanged();
                                });
                              },
                              onTap: () {
                                durationMinutesTFController.selection =
                                    TextSelection.fromPosition(
                                  TextPosition(
                                      offset: durationMinutesTFController
                                          .text.length),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Slider(
                    onChanged: (double value) {
                      setState(() {
                        onDurationSliderChanged(value);
                      });
                    },
                    onChangeStart: (_) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    activeColor: MyColors.slider,
                    inactiveColor: Colors.grey,
                    value: this.durationSliderValue,
                  ),
                ),
                const SizedBox(height: 50),
                // StartingTime(),
              ],
            ),
          ],
        ),
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      onIntervalSliderChanged('5');
      duration = Duration(minutes: 10);
      updateDurationSlider();
    });
  }



  ///!!!!!!!!!!!!!!!
  /// on changed ///
  /// !!!!!!!!!!!!!!

  void onIntervalTFChanged() {
    updateIntervalSlider();
    onIntervalChanged();
  }

  void onIntervalChanged() {
    /// Interval
    if (shotsLock == FramedTF.open)
      calcShots();
    else if (durationLock == FramedTF.open)
      calcDuration();

    calcVideoLength();
  }

  void onDurationChanged() {
    /// Duration
    if (shotsLock == FramedTF.open)
      calcShots();
    else if (intervalLock == FramedTF.open)
      calcInterval();

    calcVideoLength();
  }

  void onShotsChanged() {
    /// Shots
    if (durationLock == FramedTF.open) {
      calcDuration();
    } else if (intervalLock == FramedTF.open) {
      calcInterval();
    }
    calcVideoLength();
  }

  void onIntervalSliderChanged(String text) {
    /// Interval Slider
    intervalTFController.text = text;
    var value = interval = double.parse(text);
    if (value > 100)
      value = 100;
    else if (value < 1) {
      value = interval = 1;
    }
    value = sqrt((value - 1) / 99);
    intervalSliderValue = value;
    onIntervalChanged();
  }

  void onDurationSliderChanged(double value) {
    /// Duration Slider
    durationSliderValue = value;
    if (durationLock == FramedTF.open) {
      value = 86340 * (value * value) + 60;
      duration = Duration(seconds: value.round());
      updateDurationTF();
      onDurationChanged();
    } else if (shotsLock == FramedTF.open) {
      shots = (4990 * (value * value) + 10).round();
      shotsTFController.text = shots.toString();
      onShotsChanged();
    }
  }

  ///!!!!!!!!!
  /// calc ///
  ///!!!!!!!!!

  void calcVideoLength() {
    videoLength = (shots / fps[fpsIndex]).round();
    videoLengthTFController.text = videoLength.toString();
  }

  void calcInterval() {
    interval = duration.inSeconds / shots;
    onIntervalSliderChanged(interval.round().toString());
  }

  void calcDuration() {
    duration = Duration(seconds: (shots * interval).round());
    updateLowerSlider();
  }

  void calcShots() {
    shots = (duration.inSeconds / interval).round();
    shotsTFController.text = shots.toString();
    updateLowerSlider();
  }

  ///!!!!!!!!!!!
  /// update ///
  ///!!!!!!!!!!!

  void updateIntervalTF(double value) {
    this.intervalSliderValue = value;
    value = 99 * (value * value) + 1;
    intervalTFController.text = value.round().toString();
    interval = value;
    onIntervalChanged();
  }

  void updateDurationSlider() {
    updateDurationTF();
    double value = duration.inSeconds.toDouble();
    if (value > 86400)
      value = 86400;
    else if (value < 60) value = 60;
    value = (sqrt((value - 60) / 86340));
    durationSliderValue = value;
    onDurationChanged();
  }

  void updateLowerSlider() {
    if (durationLock == FramedTF.open) {
      updateDurationTF();
      double value = duration.inSeconds.toDouble();
      if (value > 86400)
        value = 86400;
      else if (value < 60) value = 60;
      value = (sqrt((value - 60) / 86340));
      durationSliderValue = value;
    } else if (shotsLock == FramedTF.open){
      var value = shots.toDouble();
      if (value > 5000)
        value = 5000;
      else if (value < 10)
        value = 10;
      value = sqrt((value - 10) / 4990);
      durationSliderValue = value;
    }
  }

  void updateDurationTF() {
    durationHoursTFController.text = duration.inHours.toString();
    durationMinutesTFController.text =
        (duration.inMinutes - (60 * duration.inHours)).toString();
  }
}
