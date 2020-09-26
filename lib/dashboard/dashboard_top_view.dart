import 'package:flutter/material.dart';
import 'package:sliderappflutter/dashboard/bluetooth_box.dart';
import 'package:sliderappflutter/dashboard/circular_battery_indicator.dart';
import 'package:sliderappflutter/dashboard/sun_position_wave.dart';
import 'package:sliderappflutter/dashboard/sunrisesunset_icons.dart';
import 'package:sliderappflutter/dashboard/weather_widget.dart';

class DashboardTopView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        const Divider(
          color: Colors.white,
          thickness: 0.15,
          height: 1,
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CircularBatteryIndicator(75),
              Container(
                // Weather and BT Box
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.fromLTRB(0, 16, 15, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    BluetoothBox(),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: WeatherWidget(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SunriseSunsetIcons(),
        const SunPositionWave(),
        // const SizedBox(height: 20),
      ],
    );
  }
}
