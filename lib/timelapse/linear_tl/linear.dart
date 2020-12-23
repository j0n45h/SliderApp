import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliderappflutter/main.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/timelapse/linear_tl/starting_time.dart';
import 'package:sliderappflutter/timelapse/save_start_buttons.dart';
import 'package:sliderappflutter/utilities/save_preset_dialog.dart';
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
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Row(
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
                              height: 25,
//                          padding: EdgeInsets.fromLTRB(0, 0, 0, 44),
//                          margin: EdgeInsets.fromLTRB(9, 0, 5, 0),
                              child: Text(
                                (TLVideo.fps).toString() + 'fps',
                                style: MyTextStyle.normal(fontSize: 10),
                              ),
                            ),
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
                  value: LowerSlider.value,
                ),
              ),
              const SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: StartingTime(_startingTimeKey),
              ),
              const SizedBox(height: 60),

              const SizedBox(height: 42)
            ],
          ),
        ),
        SaveAndStartButtons(
          onPressSave: () => _saveSettings(),
          onPressStart: () {
            print('pressed Start');
          },
        ),
      ],
    );
  }

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

  Future<void> _saveSettings() async {
    final thisLinearTL = SetUpLinearTL.getData();
    var presetName = TextEditingController();
    bool skip = true;

    await showDialog(
        context: context,
        child: SaveTLDialog(
          presetName: presetName,
          onDone: () {
            if(presetName.text.isEmpty)
              thisLinearTL.name = 'Unnamed';
            else
              thisLinearTL.name = presetName.text.toString();
            skip = false;
          },
        ),
    );

    if (skip) return; // skips saving step when dialog dismissed

    thisLinearTL.index = tlData.linearTL.length + tlData.rampedTL.length;
    tlData.linearTL.add(thisLinearTL);
    tlData.saveToCache();
  }
}
