import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyColors {
  static const AppBar = const Color(0xff000000); // Color(0xff161616);
  static const BgGradient = LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomRight,
    colors: [Color(0xff242F33), Color(0xff000000)],
    stops: [0.0, 0.9],
    //tileMode: TileMode.repeated,
  );
  static RadialGradient bgRadialGradient(double r) {
    return RadialGradient(
      radius: r,
        colors: [
          Color(0xff161616),
          Color(0xff000000),
        ]
    );
  }
  static const StatusBar = const Color(0xff161616);
  static const green = Color(0xff00FF3C);
  static const blue = Color(0xff0099FF);
  static const font = Color(0xffffffff);
  static const red = Color(0xffb81904);
  static const bg = Color(0xff242f33);
  static const popup = Color(0xff316f7f);
}