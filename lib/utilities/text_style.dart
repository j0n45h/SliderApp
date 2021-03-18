import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class MyTextStyle {
  static const Color color = MyColors.font;

  const MyTextStyle();

  static TextStyle normal({
    required double fontSize,
    double letterSpacing = 1,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w200,
      letterSpacing: letterSpacing,
    );
  }
  static TextStyle normalStdSize({
    double letterSpacing = 0,
    Color newColor = color,
  }) {
    return TextStyle(
      color: newColor,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w200,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle fet({required double fontSize}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      letterSpacing: 1,
    );
  }
  static TextStyle fetStdSize({
    double letterSpacing = 1,
    Color newColor = color,
    FontWeight fontWight = FontWeight.w300,
  }) {
    return TextStyle(
      color: newColor,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle appBarHeadline() {
    return TextStyle(
      fontFamily: 'Bellezza',
      letterSpacing: 5,
    );
  }
}
