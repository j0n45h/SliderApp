import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';
import 'package:sliderappflutter/utilities/state/weather_state.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';

import 'Settings/settings.dart';
import 'advanced_timelapse/advanced_timelapse.dart';
import 'connection.dart';
import 'dashboard/dashboard.dart';
import 'drawer.dart';
import 'timelapse/timelapse.dart';
import 'video.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(MainPage());
}

TLData tlData;



class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    tlData = TLData();
    SetUpLinearTL.setToDefaultValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProvideBtState>      (create: (context) => ProvideBtState()),
        ChangeNotifierProvider<ProvideLocationState>(create: (context) => ProvideLocationState()),
        ChangeNotifierProvider<ProvideWeatherState> (create: (context) => ProvideWeatherState()),
      ],
      child: MaterialApp(
        title: 'Slider',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          platform: TargetPlatform.iOS,
        ),
        // initialRoute: TimelapseScreen.routeName,
        routes: {
          MyDrawer.routeName: (_) => MyDrawer(),
          DashboardScreen.routeName: (_) => DashboardScreen(),
          TimelapseScreen.routeName: (_) => TimelapseScreen(),
          AdvancedTimelapseScreen.routeName: (_) => AdvancedTimelapseScreen(),
          VideoScreen.routeName: (_) => VideoScreen(),
          ConnectionScreen.routeName: (_) => ConnectionScreen(),
          SettingsScreen.routeName: (_) => SettingsScreen(),
        },
      ),
    );
  }
}
