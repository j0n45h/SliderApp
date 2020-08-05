import 'dart:js';

import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/foundation.dart';


void setDefaultTimelapseValues(BuildContext context) {
  final tlInterval = Provider.of<TLInterval>(context, listen: false);
  // final tlShots    = Provider.of<TLShots>   (context, listen: false);
  final tlDuration = Provider.of<TLDuration>(context, listen: false);

  tlInterval.tfController.text = '10';
  tlDuration.hoursTFController.text = '1';
  tlDuration.minutesTFController.text = '30';
  tlInterval.onTFEdited();
  tlDuration.setup();
}

class TLInterval with ChangeNotifier { /// Interval
  double interval;
  FramedTF lock = FramedTF.open;
  var tfController = TextEditingController();


  void onTFEdited(){
    interval = double.parse(tfController.text);
    if (interval < 1) {
      tfController.text = '1';
      interval = 1;
    }
    updateSlider();
    _notifyChange();
  }
  void onSliderChanged(double sliderValue){
    interval = sliderValue;
    _updateTF();
    _notifyChange();
  }
  void _notifyChange(BuildContext context){
    final tlShots    = Provider.of<TLShots>   (context, listen: false);
    final tlDuration = Provider.of<TLDuration>(context, listen: false);

    if (tlShots.lock == FramedTF.open)
      tlShots.update();
    else if (tlDuration.lock == FramedTF.open)
      tlDuration.update();
  }

  void update(){
    _reCalc();
    _updateTF();
    updateSlider();
  }

  void _reCalc() {
    interval = interval = TLDuration.duration_.inSeconds / TLShots.shots;
  }

  void _updateTF() {
    tfController.text = interval.round().toString();
  }

  static void updateSlider() {
    var value = interval;
    if (value > 100)
      value = 100;
    else if (value < 1)
      value = interval = 1;

    value = sqrt((value - 1) / 99);
    UpperSlider.value = value;
  }
}



class TLDuration with ChangeNotifier { /// Duration
  static FramedTF lock_ = FramedTF.open;
  static var duration_ = Duration();
  static var hoursTFController_   = TextEditingController();
  static var minutesTFController_ = TextEditingController();

  get lock {
    return lock_;
  }
  get duration {
    return duration_;
  }
  get hoursTFController {
    return hoursTFController_;
  }
  get minutesTFController {
    return minutesTFController_;
  }

  TLDuration(){
    lock_ = FramedTF.open;
  }

  void setup() {
    var hours = int.parse(hoursTFController.text);
    var min   = int.parse(minutesTFController.text);
    duration_ = Duration(
      hours: hours,
      minutes: min,
    );
    updateSlider();
  }

  void tfEdited(BuildContext context) {
    onTFEdited(context);
  }

  void onTFEdited(BuildContext context) { // usable from outside
    var hours = int.parse(hoursTFController.text);
    var min   = int.parse(minutesTFController.text);
    if(hours <= 0) {
      if (min < 1) {
        minutesTFController.text = '1';
        min = 1;
      }
      hoursTFController.text = '0';
    }
    if(min < 0) {
      minutesTFController.text = '0';
      min = 0;
    }
    if (hours == 0 && min < 1){
      minutesTFController.text = '1';
      min = 1;
    }
    duration_ = Duration(
      hours: hours,
      minutes: min,
    );
    updateSlider();
    _notifyChange(context);
  }

  void newSliderValue(double newValue, BuildContext context) {
    onSliderChanged(newValue,context);
  }

  void onSliderChanged(double sliderValue, BuildContext context){ // usable from outside
    duration_ = Duration(seconds: sliderValue.round());
    _updateTF();
    _notifyChange(context);
  }
  void _notifyChange(BuildContext context){
    if (TLShots.lock == FramedTF.open) {
      final tlShots = Provider.of<TLShots>(context, listen: false);
      tlShots.update();
    }
    else if (TLInterval.lock == FramedTF.open){
      final tlInterval = Provider.of<TLInterval>(context, listen: false);
      tlInterval.update();
    }
    notifyListeners();
  }

  void _reCalc() {
    duration_ = Duration(seconds: (TLShots.shots * TLInterval.interval).round());
  }

  void update() {
    _reCalc();
    _updateTF();
    updateSlider();
  }

  void _updateTF() {
    hoursTFController_.text = duration_.inHours.toString();
    minutesTFController_.text = (duration_.inMinutes - (60 * duration_.inHours)).toString();
  }

  void updateSlider(){
    if (lock_ != FramedTF.open) return;
    double value = duration_.inSeconds.toDouble();
    if (value > 86400)
      value = 86400;
    else if (value < 60)
      value = 60;

    value = sqrt((value - 60) / 86340);
    LowerSlider.value = value;
  }
}






class TLShots with ChangeNotifier { /// Shots
  int shots;
  FramedTF lock = FramedTF.open;
  static var tfController = TextEditingController();

  TLShots(){
    lock = FramedTF.open;
  }

  void onTFEdited(){
    shots = int.parse(tfController.text);
    if (shots < 1) {
      tfController.text = '1';
      shots = 1;
    }
    updateSlider();
    _notifyChange();
  }
  void onSliderChanged(double sliderValue, BuildContext context){
    shots = sliderValue.round();
    _updateTF();
    _notifyChange(context);
  }
  void _notifyChange(BuildContext context){
    final tlDuration = Provider.of<TLDuration>(context, listen: false);
    final tlInterval = Provider.of<TLInterval>(context, listen: false);
    if (tlDuration.lock == FramedTF.open)
      tlDuration.update();
    else if (tlInterval.lock == FramedTF.open)
      tlInterval.update();
    TLVideo.update();
  }

  void update(){
    _reCalc();
    _updateTF();
    updateSlider();
    TLVideo.update();
  }

  void _reCalc(){
    shots = (TLDuration.duration.inSeconds / TLInterval.interval).round();
  }
  void _updateTF() {
    tfController.text = shots.toString();
  }
  void updateSlider(){
    if (TLDuration.lock != FramedTF.locked) return;
    var value = shots.toDouble();
    if (value > 5000)
      value = 5000;
    else if (value < 10)
      value = 10;

    value = sqrt((value - 10) / 4990);
    LowerSlider.value = value;
  }
}


class TLVideo{
  static int videoLength;
  static FramedTF lock = FramedTF.open;
  static var tfController = TextEditingController();

  static int _fpsIndex = 0;
  static List<int> _fpsArray = [24, 25, 30, 50, 60, 100, 120];

  static int get fps {
    return _fpsArray[_fpsIndex];
  }

  static void toggleFPS() {
    _fpsIndex++;
    if (_fpsIndex >= _fpsArray.length) _fpsIndex = 0;
    update();
  }

  static void onTFEdited() {
    videoLength = int.parse(tfController.text);
    if (videoLength < 1){
      tfController.text = '1';
      videoLength = 1;
    }
    updateSlider();
    _notifyChange();
  }
  static void onSliderChanged(double sliderValue) {
    videoLength = sliderValue.round();
    _updateTF();
    _notifyChange();
  }
  static void update() {
    _reCalc();
    _updateTF();
    // updateSlider();
  }
  static void updateSlider() {
    TLShots.updateSlider();
  }

  static void _notifyChange() {
    TLShots.update();
  }
  static void _reCalc() {
    videoLength = (TLShots.shots / fps).round();
  }
  static void _updateTF() {
    tfController.text = videoLength.toString();
  }

  }



class UpperSlider{
  static double value;

  static void onChanged(double newValue) {
    value = newValue;
    newValue = 99 * (newValue * newValue) + 1;
    TLInterval.onSliderChanged(newValue);
  }
}


class LowerSlider{
  static double value;

  static void onChanged(double newValue){
    value = newValue;
    if (TLDuration.lock == FramedTF.open){
      newValue = 86340 * (newValue * newValue) + 60;
      TLDuration().newSliderValue = newValue;
    } else if (TLShots.lock == FramedTF.open){
      newValue = (4990 * (newValue * newValue) + 10);
      TLShots.onSliderChanged(newValue);
    }
  }
}