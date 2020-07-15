import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/timelapse.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TLInterval{ /// Interval
  static double interval;
  static FramedTF lock;
  static var tfController = TextEditingController();

  TLInterval(){
    lock = FramedTF.open;
  }

  static void onTFEdited(){
    interval = double.parse(tfController.text);
    _updateSlider();
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
    _updateSlider();
  }

  static void _reCalc() {
    interval = interval = TLDuration.duration.inSeconds / TLShots.shots;
  }

  static void _updateTF() {
    tfController.text = interval.round().toString();
  }

  static void _updateSlider() {
    var value = interval;
    if (value < 100)
      value = 100;
    else if (value < 1)
      value = interval = 1;

    value = sqrt((value - 1) / 99);
    UpperSlider.value = value;
  }
}



class TLDuration{ /// Duration
  static Duration duration;
  static FramedTF lock;
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
    _updateSlider();
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
    _updateSlider();
  }

  static void _updateTF() {
    hoursTFController.text = duration.inHours.toString();
    minutesTFController.text = (duration.inMinutes - (60 * duration.inHours)).toString();
  }

  static void _updateSlider(){
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
  static FramedTF lock;
  static var tfController = TextEditingController();

  TLShots(){
    lock = FramedTF.open;
  }

  static void onTFEdited(){
    shots = int.parse(tfController.text);
    _updateSlider();
    _notifyChange();
  }
  static void onSliderChanged(double sliderValue){

  }
  static void _notifyChange(){
    if (TLDuration.lock == FramedTF.open)
      TLDuration.update();
    else if (TLInterval.lock == FramedTF.open)
      TLInterval.update();
  }

  static void update(){
    shots = (TLDuration.duration.inSeconds / TLInterval.interval).round();
    tfController.text = shots.toString();
    if (TLDuration.lock == FramedTF.locked)
      _updateSlider();
  }
  static void _updateSlider(){
    var value = shots.toDouble();
    if (value > 5000)
      value = 5000;
    else if (value < 10)
      value = 10;

    value = sqrt((value - 10) / 4990);
    LowerSlider.value = value;
  }
}




class UpperSlider{
  static double value;

  static void onChanged(double newValue) {
    value = 99 * (newValue * newValue) + 1;
    TLInterval.onSliderChanged(value);
  }
}


class LowerSlider{
  static double value;

  static void onChanged(double newValue){
    value = newValue;
    if (TLDuration.lock == FramedTF.open){
      value = 86340 * (value * value) + 60;
      TLDuration.onSliderChanged(value);
    } else if (TLShots.lock == FramedTF.open){
      value = (4990 * (value * value) + 10);
      TLShots.onSliderChanged(value);
    }
  }
}