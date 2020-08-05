import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/starting_time.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';
import 'package:sliderappflutter/timelapse/interval_duration_shots.dart';
import 'package:sliderappflutter/drawer.dart';

class TimelapseScreen extends StatefulWidget {
  static const routeName = '/timelapse-screen';

  @override
  _TimelapseScreenState createState() => _TimelapseScreenState();
}

class _TimelapseScreenState extends State<TimelapseScreen> {
  static double tfHeight = 30;
  final GlobalKey<StartingTimeState> _startingTimeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final tlDuration = Provider.of<TLDuration>(context, listen: false);
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
                            textField: MyTextField(
                              fontSize: 12,
                              textController: TLInterval.tfController,
                              unit: 's',
                              onEditingComplete: () {
                                setState(() {
                                  TLInterval.onTFEdited();
                                  _startingTimeKey.currentState.calcTime();
                                });
                              },
                              onTap: () =>
                                  jumpCursorToEnd(TLInterval.tfController),
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
                                  TLVideo.toggleFPS();
                                });
                              },
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                alignment: Alignment.center,
                                width: 40,
                                height: 10,
//                              padding: EdgeInsets.fromLTRB(0, 0, 0, 44),
                                // margin: EdgeInsets.fromLTRB(9, 0, 5, 0),
                                child: Text(
                                  (TLVideo.fps).toString() + 'fps',
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
                              FramedTextField(
                                lock: TLShots.lock,
                                onLockLongPress: () {
                                  setState(() {
                                    toggleShotsAndVideoLock(tlDuration);
                                  });
                                },
                                width: 90,
                                height: tfHeight,
                                textField: MyTextField(
                                  fontSize: 12,
                                  textController: TLVideo.tfController,
                                  unit: 's',
                                  enabled: true,
                                  onEditingComplete: () {
                                    setState(() {
                                      lockShotsAndVideo(tlDuration);
                                      TLVideo.onTFEdited();
                                      _startingTimeKey.currentState.calcTime();
                                    });
                                  },
                                  onTap: () =>
                                      jumpCursorToEnd(TLVideo.tfController),
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
                        UpperSlider.onChanged(value);
                        _startingTimeKey.currentState.calcTime();
                      });
                    },
                    onChangeStart: (_) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    activeColor: MyColors.slider,
                    inactiveColor: Colors.grey,
                    value: UpperSlider.value,
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
                            lock: tlDuration.lock,
                            onLockLongPress: () {
                              setState(() {
                                toggleDurationLock(tlDuration);
                              });
                            },
                            textField: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 36,
                                  child: MyTextField(
                                    fontSize: 12,
                                    textController: tlDuration
                                        .hoursTFController,
                                    unit: 'h',
                                    onEditingComplete: () {
                                      setState(() {
                                        lockDuration();
                                        TLDuration.onTFEdited();
                                        _startingTimeKey.currentState.calcTime();
                                      });
                                    },
                                    onTap: () =>
                                        jumpCursorToEnd(
                                          tlDuration.hoursTFController,
                                        ),
                                  ),
                                ),
                                Container(
                                  width: 52,
                                  child: MyTextField(
                                    fontSize: 12,
                                    textController: tlDuration
                                        .minutesTFController,
                                    unit: 'min',
                                    onEditingComplete: () {
                                      setState(() {
                                        lockDuration();
                                        TLDuration.onTFEdited();
                                        _startingTimeKey.currentState.calcTime();
                                      });
                                    },
                                    onTap: () =>
                                        jumpCursorToEnd(
                                          tlDuration().minutesTFController,
                                        ),
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
                              fontSize: 12.0, letterSpacing: 1.3,
                            ),
                          ),
                          const SizedBox(width: 10),
                          FramedTextField(
                            width: 90,
                            height: tfHeight,
                            lock: TLShots.lock,
                            onLockLongPress: () {
                              setState(() {
                                toggleShotsAndVideoLock(tlDuration);
                              });
                            },
                            textField: MyTextField(
                              fontSize: 12,
                              textController: TLShots.tfController,
                              onEditingComplete: () {
                                setState(() {
                                  lockShotsAndVideo(tlDuration);
                                  TLShots.onTFEdited();
                                  _startingTimeKey.currentState.calcTime();
                                });
                              },
                              onTap: () => jumpCursorToEnd(TLVideo.tfController),
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
                        LowerSlider.onChanged(value);
                        _startingTimeKey.currentState.calcTime();
                      });
                    },
                    onChangeStart: (_) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    },
                    activeColor: MyColors.slider,
                    inactiveColor: Colors.grey,
                    value: LowerSlider.value,
                  ),
                ),
                const SizedBox(height: 50),
                StartingTime(_startingTimeKey),
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


  void jumpCursorToEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(TextPosition(
      offset: controller.text.length),
    );
  }

  void toggleShotsAndVideoLock(TLDuration tlDuration) {
    if (TLShots.lock == FramedTF.notLockable)
      return;
    if (TLShots.lock == FramedTF.open)
      TLShots.lock = FramedTF.locked;
    else
      TLShots.lock = FramedTF.open;
    if (tlDuration.lock == FramedTF.locked)
      tlDuration.lock = FramedTF.open;
    TLShots.updateSlider();
    tlDuration.updateSlider();
  }
  void lockShotsAndVideo(TLDuration tlDuration) {
    if (tlDuration.lock == FramedTF.locked)
      tlDuration.lock = FramedTF.open;
    TLShots.lock = FramedTF.locked;
  }

  void toggleDurationLock(TLDuration tlDuration) {
    if (tlDuration.lock == FramedTF.notLockable)
      return;
    if (tlDuration.lock == FramedTF.open)
      tlDuration.lock = FramedTF.locked;
    else
      tlDuration.lock = FramedTF.open;
    if (TLShots.lock == FramedTF.locked)
      TLShots.lock = FramedTF.open;
    TLShots.updateSlider();
    tlDuration.updateSlider();
  }
  void lockDuration() {
    if (TLShots.lock == FramedTF.locked)
      TLShots.lock = FramedTF.open;
    tlDuration.lock = FramedTF.locked;

  }

}