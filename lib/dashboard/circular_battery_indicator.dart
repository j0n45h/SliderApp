import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sliderappflutter/utilities/colors.dart';


class CircularBatteryIndicator extends StatelessWidget {
  final int batteryPercentage;

  const CircularBatteryIndicator(this.batteryPercentage);

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
          percent: batteryPercentage/100,
          reverse: true,
          backgroundColor: Color(0x00ffffff), // transparent
          // progressColor: MyColors.green,
          center: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                batteryPercentage.toString() + '%',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xffffffff),
                    fontSize: 25,
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
