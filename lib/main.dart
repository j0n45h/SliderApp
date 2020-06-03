import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';
import 'package:sliderappflutter/utilities/state/weather_state.dart';

import 'Settings/settings.dart';
import 'advanced_timelapse.dart';
import 'connection.dart';
import 'dashboard/dashboard.dart';
import 'drawer.dart';
import 'timelapse.dart';
import 'video.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(MainPage());
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProvideBtState>(create: (context) => ProvideBtState()),
        ChangeNotifierProvider<ProvideLocationState>(create: (context) => ProvideLocationState()),
        ChangeNotifierProvider<ProvideWeatherState>(create: (context) => ProvideWeatherState()),
      ],
      child: MaterialApp(
        title: 'Slider',
        /*theme: ThemeData(
          primarySwatch: Colors.amber,
        ),*/
        // home: DashboardScreen(),
        initialRoute: DashboardScreen.routeName,
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
