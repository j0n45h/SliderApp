import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyColors extends StatelessWidget {
  static const AppBar = const Color(0xff1D2629);
  static const BgGradient = LinearGradient(
    begin: FractionalOffset.topLeft,
    end: FractionalOffset.bottomRight,
    colors: [Color(0xff242F33), Color(0xff000000)],
    stops: [0.0, 0.9],
    //tileMode: TileMode.repeated,
  );
  static const StatusBar = const Color(0xff17242A);
  static const green = Color(0xff00FF3C);
  static const blue = Color(0xff0099FF);
  static const font = Color(0xffffffff);
  static const red = Color(0xffb81904);
  static const bg = Color(0xff242f33);
  static const popup = Color(0xff316f7f);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}