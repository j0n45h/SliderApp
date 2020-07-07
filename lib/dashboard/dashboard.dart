import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliderappflutter/dashboard/bluetooth_box.dart';
import 'package:sliderappflutter/dashboard/circular_battery_indicator.dart';
import 'package:sliderappflutter/dashboard/sun_position_wave.dart';
import 'package:sliderappflutter/dashboard/sunrisesunset_icons.dart';
import 'package:sliderappflutter/dashboard/weather_widget.dart';
import 'package:sliderappflutter/drawer.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/dashboard/circular_battery_indicator.dart';
import 'file:///C:/Users/jonas/Documents/Slider_Source/App/slider_app_flutter/lib/utilities/popUp.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    print('Dashboard rebuild//////////////////////////////////////////////////////////');
    return Scaffold(
      backgroundColor: Color(0xff242f33),
      appBar: AppBar(
        elevation: 1.0,
        /*leading: Transform.scale( // TODO Fix drawerIcon onPress:
          scale: 0.65,
          child: IconButton(
            onPressed: () { _scaffoldKey.currentState.openDrawer();},
            icon: Image.asset('assets/icons/DrawerIcon.png'),
          ),
        ),*/
        title: const Text(
          'J Slide',
          style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
        ),
        centerTitle: true,
        actions: <Widget>[
          Transform.rotate(
            angle: (-pi / 2),
            child: const Icon(
              // TODO Change to scalable battery
              Icons.battery_std,
              color: MyColors.green,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Text('10h'),
          ),
        ],
        backgroundColor: MyColors.AppBar,
      ),
      drawer: MyDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: MyColors.bgRadialGradient(1),
            ),
          ),
          ListView(
            children: <Widget>[
              Divider(
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
            ],
          ),
        ],
      ),
    );
  }
}
