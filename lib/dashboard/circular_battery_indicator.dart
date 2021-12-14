import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class CircularBatteryIndicator extends StatelessWidget {
  final int batteryPercentage;
  final gradient = new List<Color>.empty(growable: true);

  CircularBatteryIndicator(this.batteryPercentage) {
    if (batteryPercentage > 35)
      gradient.addAll([MyColors.green, Color(0x6600FF3C)]);
    else if (batteryPercentage > 20)
      gradient.addAll([Colors.amber]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(40, 35, 10, 45),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: MyColors.green.withAlpha(0),
              blurRadius: 40,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            ),
          ],
        ),
        child: CircularPercentIndicator(
          linearGradient: LinearGradient(
            colors: [MyColors.green, Color(0x6600FF3C)],
            end: Alignment(0.8, 0.0),
            begin: Alignment.topCenter,
          ),
          radius: 100.0,
          lineWidth: 2.0,
          percent: batteryPercentage / 100,
          reverse: true,
          backgroundColor: Colors.transparent,
          // progressColor: MyColors.green,
          center: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                batteryPercentage.toString(),
                style: TextStyle(
                    fontFamily: 'Roboto', color: Color(0xffffffff), fontSize: 25, fontWeight: FontWeight.w200),
              ),
              Text(
                '%',
                style: TextStyle(
                    fontFamily: 'Roboto', color: Color(0xffffffff), fontSize: 15, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
