import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:sliderappflutter/utilities/json_handling/json_class.dart';

class SetUpLinearTL {
  static void setToDefaultValues() {
    TLInterval.tfController.text = '12';
    TLDuration.hoursTFController.text = '1';
    TLDuration.minutesTFController.text = '30';
    TLInterval.onTFEdited();
    TLDuration.onTFEdited();
  }

  static void loadData(LinearTL linearTL) {
    print(linearTL.interval.toString());
    TLInterval.tfController.text = linearTL.interval.toString();
    TLInterval.interval = linearTL.interval;
    TLShots.tfController.text =  linearTL.shots.toString();
    TLShots.shots = linearTL.shots;
    TLShots.onTFEdited();
    TLInterval.onTFEdited();
  }

  static LinearTL getData(){
    return LinearTL(
      interval: TLInterval.interval,
      shots: TLShots.shots,
    );
  }
}

class TLInterval{ /// Interval
  static double interval;
  static FramedTF lock = FramedTF.open;
  static var tfController = TextEditingController();


  static void onTFEdited(){
    interval = double.parse(tfController.text);
    if (interval < 1) {
      tfController.text = '1';
      interval = 1;
    }
    updateSlider();
    _notifyChange();
  }
  static void onSliderChanged(double sliderValue){
    interval = sliderValue;
    _updateTF();
    _notifyChange();
  }
  static void _notifyChange(){
    if (TLShots.lock == FramedTF.open)
      TLShots.update();
    else if (TLDuration.lock == FramedTF.open)
      TLDuration.update();
  }

  static void update(){
    _reCalc();
    _updateTF();
    updateSlider();
  }

  static void _reCalc() {
    interval = interval = TLDuration.duration.inSeconds / TLShots.shots;
  }

  static void _updateTF() {
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



class TLDuration{ /// Duration
  static FramedTF lock = FramedTF.open;
  static var duration = Duration();
  static var hoursTFController   = TextEditingController();
  static var minutesTFController = TextEditingController();

  TLDuration(){
    lock = FramedTF.open;
  }

  static void onTFEdited(){ // usable from outside
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
    duration = Duration(
      hours: hours,
      minutes: min,
    );
    updateSlider();
    _notifyChange();
  }

  static void onSliderChanged(double sliderValue){ // usable from outside
    duration = Duration(seconds: sliderValue.round());
    _updateTF();
    _notifyChange();
  }

  static void _notifyChange(){
    if (TLShots.lock == FramedTF.open)
      TLShots.update();
    else if (TLInterval.lock == FramedTF.open)
      TLInterval.update();
  }

  static void _reCalc() {
    duration = Duration(seconds: (TLShots.shots * TLInterval.interval).round());
  }

  static void update() {
    _reCalc();
    _updateTF();
    updateSlider();
  }

  static void _updateTF() {
    hoursTFController.text = duration.inHours.toString();
    minutesTFController.text = (duration.inMinutes - (60 * duration.inHours)).toString();
  }

  static void updateSlider(){
    if (lock != FramedTF.open) return;
    double value = duration.inSeconds.toDouble();
    if (value > 86400)
      value = 86400;
    else if (value < 60)
      value = 60;

    value = sqrt((value - 60) / 86340);
    LowerSlider.value = value;
  }
}






class TLShots{ /// Shots
  static int shots;
  static FramedTF lock = FramedTF.open;
  static var tfController = TextEditingController();

  TLShots(){
    lock = FramedTF.open;
  }

  static void onTFEdited(){
    shots = int.parse(tfController.text);
    if (shots < 1) {
      tfController.text = '1';
      shots = 1;
    }
    updateSlider();
    _notifyChange();
  }
  static void onSliderChanged(double sliderValue){
    shots = sliderValue.round();
    _updateTF();
    _notifyChange();
  }
  static void _notifyChange(){
    if (TLDuration.lock == FramedTF.open)
      TLDuration.update();
    else if (TLInterval.lock == FramedTF.open)
      TLInterval.update();
    TLVideo.update();
  }

  static void update(){
    _reCalc();
    _updateTF();
    updateSlider();
    TLVideo.update();
  }

  static void _reCalc(){
    shots = (TLDuration.duration.inSeconds / TLInterval.interval).round();
  }
  static void _updateTF() {
    tfController.text = shots.toString();
  }
  static void updateSlider(){
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
      TLDuration.onSliderChanged(newValue);
    } else if (TLShots.lock == FramedTF.open){
      newValue = (4990 * (newValue * newValue) + 10);
      TLShots.onSliderChanged(newValue);
    }
  }
}