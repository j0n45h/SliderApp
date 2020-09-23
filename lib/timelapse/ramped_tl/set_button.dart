import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/navigte_to_graph_screen.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class SetButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Text(
        'SET',
        style: MyTextStyle.fetStdSize(
          letterSpacing: 6,
          newColor: Colors.black,
          fontWight: FontWeight.w400,
        ),
      ),
      fillColor: MyColors.slider,
      onPressed: () => NavigateToGraphScreen(context).navigate(),
      shape: StadiumBorder(),
      elevation: 12,
    );
  }
}
