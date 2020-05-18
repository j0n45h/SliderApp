import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

class SunriseSunsetIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvideLocationState>(
        builder: (context, locationState, _) {
          if (locationState.available()) {
            var sunriseSunset = getSunriseSunset(locationState.getLatitude, locationState.getLongitude, 0, DateTime.now().toUtc());
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Image.asset(
                    'assets/icons/SunArrow.png',
                    scale: 8,
                  ),
                ),
                Text(
                  '${sunriseSunset.sunrise
                      .toLocal()
                      .hour}:${sunriseSunset.sunrise
                      .toLocal()
                      .minute}',
                  style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w200,
                      color: MyColors.font,
                      fontSize: 14),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(120, 0, 10, 0),
                  child: Transform.rotate(
                    angle: pi / 2,
                    child: Image.asset(
                      'assets/icons/SunArrow.png',
                      scale: 8,
                    ),
                  ),
                ),
                Text(
                  '${sunriseSunset.sunset.toLocal().hour}:${sunriseSunset.sunset.toLocal().minute}',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w200,
                    color: MyColors.font,
                    fontSize: 14,
                  ),
                ),
              ],
            );
          } else {
            return Container(height: 20, width: MediaQuery.of(context).size.width,);
          }
        }
    );
  }
}
