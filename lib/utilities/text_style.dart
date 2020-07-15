import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class MyTextStyle {
  static double fontSize;
  static Color color = MyColors.font;

  const MyTextStyle();

  static TextStyle normal({
    @required double fontSize,
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
  static TextStyle normalStdSize() {
    return TextStyle(
      color: color,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w200,
    );
  }

  static TextStyle fet({@required double fontSize}) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      letterSpacing: 1,
    );
  }
  static TextStyle fetStdSize() {
    return TextStyle(
      color: color,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300,
      letterSpacing: 1,
    );
  }

  static TextStyle appBarHeadline() {
    return TextStyle(
      fontFamily: 'Bellezza',
      letterSpacing: 5,
    );
  }
}
