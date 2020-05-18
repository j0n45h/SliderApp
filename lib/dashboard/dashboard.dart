import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/dashboard/sunrisesunset_icons.dart';
import 'package:sliderappflutter/dashboard/weather_widget.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';
import 'package:sliderappflutter/utilities/state/weather_state.dart';

import 'package:weather/weather_library.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';


import 'package:sliderappflutter/utilities/colors.dart';

import '../drawer.dart';
import 'circular_battery_indicator.dart';
import 'bluetooth_box.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/';

  @override
  Widget build(BuildContext context) {
    onBuild(context);
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
        title: Text(
          'J Slide',
          style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
        ),
        centerTitle: true,
        actions: <Widget>[
          Transform.rotate(
            angle: (-pi / 2),
            child: Icon(
              // TODO Change to scalable battery
              Icons.battery_std,
              color: MyColors.green,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text('10h'),
          ),
        ],
        backgroundColor: MyColors.AppBar,
      ),
      drawer: MyDrawer(),
      body:
      /*Container(
        decoration: BoxDecoration(
          gradient: MyColors.BgGradient,
        ),
        child: */
      ListView(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircularBatteryIndicator(75),
                Container(
                  // Weather and BT Box
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.fromLTRB(0, 16, 15, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      BluetoothBox(),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: WeatherWidget(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SunriseSunsetIcons(),
        ],
      ),
      // ),
    );
  }



  void onBuild (dynamic context) {
    final btStateProvider = Provider.of<ProvideBtState>(context, listen: false);
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      btStateProvider.setBluetoothState = state;
    });
    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      btStateProvider.setBluetoothState = state;
    });

    btStateProvider.autoConnectToLastDevice(context); // auto connect BT

      final locationStateProvider = Provider.of<ProvideLocationState>(context, listen: false); // Location
      locationStateProvider.updateMyGeoLocation(context);
      // final weatherStateProvider = Provider.of<ProvideWeatherState>(context, listen: false); // Weather
      // weatherStateProvider.updateWeather(context);


  }
}