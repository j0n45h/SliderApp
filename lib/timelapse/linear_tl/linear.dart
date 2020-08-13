import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/timelapse/linear_tl/starting_time.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/json_handling/test_.dart';
import 'package:sliderappflutter/utilities/text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class LinearTLScreen extends StatefulWidget {
  @override
  _LinearTLScreenState createState() => _LinearTLScreenState();
}

class _LinearTLScreenState extends State<LinearTLScreen> {
  static double tfHeight = 30;
  final GlobalKey<StartingTimeState> _startingTimeKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
//            Container(
//              decoration: BoxDecoration(
//                gradient: MyColors.bgRadialGradient(1),
//              ),
//            ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ListView(
              shrinkWrap: true,
              children: <Widget>[
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
                                //                             margin: EdgeInsets.fromLTRB(9, 0, 5, 0),
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
                                    toggleShotsAndVideoLock();
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
                                      lockShotsAndVideo();
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
                            lock: TLDuration.lock,
                            onLockLongPress: () {
                              setState(() {
                                toggleDurationLock();
                              });
                            },
                            textField: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 36,
                                  child: MyTextField(
                                    fontSize: 12,
                                    textController:
                                        TLDuration.hoursTFController,
                                    unit: 'h',
                                    onEditingComplete: () {
                                      setState(() {
                                        lockDuration();
                                        TLDuration.onTFEdited();
                                        _startingTimeKey.currentState
                                            .calcTime();
                                      });
                                    },
                                    onTap: () => jumpCursorToEnd(
                                      TLDuration.hoursTFController,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 52,
                                  child: MyTextField(
                                    fontSize: 12,
                                    textController:
                                        TLDuration.minutesTFController,
                                    unit: 'min',
                                    onEditingComplete: () {
                                      setState(() {
                                        lockDuration();
                                        TLDuration.onTFEdited();
                                        _startingTimeKey.currentState
                                            .calcTime();
                                      });
                                    },
                                    onTap: () => jumpCursorToEnd(
                                      TLDuration.minutesTFController,
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
                              fontSize: 12.0,
                              letterSpacing: 1.3,
                            ),
                          ),
                          const SizedBox(width: 10),
                          FramedTextField(
                            width: 90,
                            height: tfHeight,
                            lock: TLShots.lock,
                            onLockLongPress: () {
                              setState(() {
                                toggleShotsAndVideoLock();
                              });
                            },
                            textField: MyTextField(
                              fontSize: 12,
                              textController: TLShots.tfController,
                              onEditingComplete: () {
                                setState(() {
                                  lockShotsAndVideo();
                                  TLShots.onTFEdited();
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
                const SizedBox(height: 60),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RawMaterialButton(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      'SAVE',
                      style: MyTextStyle.fetStdSize(
                        letterSpacing: 6,
                        newColor: Colors.black,
                        fontWight: FontWeight.w400,
                      ),
                    ),
                    fillColor: Colors.white,
                    onPressed: () {
                      print('pressed Save');
                    },
                    shape: StadiumBorder(),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    child: Text(
                      'START',
                      style: MyTextStyle.fetStdSize(
                        letterSpacing: 6,
                        newColor: Colors.black,
                        fontWight: FontWeight.w400,
                      ),
                    ),
                    fillColor: Color(0xff00FF5F),
                    onPressed: () {
                      print('pressed Start');
                    },
                    shape: StadiumBorder(),
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
            Container(
              color: Colors.grey,
              width: 100,
              height: 50,
              child: TextField(
                controller: te,
                autocorrect: false,
                onChanged: (String str) => string = str,
              ),
            ),
            MaterialButton(
              onPressed: () => TestJson.read(string),
              color: Colors.green,
              height: 30,
              minWidth: 60,
            )
          ],
        ),
      ],
    );
  }

  String string;
  static TextEditingController te;

  void jumpCursorToEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  void toggleShotsAndVideoLock() {
    if (TLShots.lock == FramedTF.notLockable) return;
    if (TLShots.lock == FramedTF.open)
      TLShots.lock = FramedTF.locked;
    else
      TLShots.lock = FramedTF.open;
    if (TLDuration.lock == FramedTF.locked) TLDuration.lock = FramedTF.open;
  }

  void lockShotsAndVideo() {
    if (TLDuration.lock == FramedTF.locked) TLDuration.lock = FramedTF.open;
    TLShots.lock = FramedTF.locked;
  }

  void toggleDurationLock() {
    if (TLDuration.lock == FramedTF.notLockable) return;
    if (TLDuration.lock == FramedTF.open)
      TLDuration.lock = FramedTF.locked;
    else
      TLDuration.lock = FramedTF.open;
    if (TLShots.lock == FramedTF.locked) TLShots.lock = FramedTF.open;
    TLShots.updateSlider();
    TLDuration.updateSlider();
  }

  void lockDuration() {
    if (TLShots.lock == FramedTF.locked) TLShots.lock = FramedTF.open;
    TLDuration.lock = FramedTF.locked;
  }
}
