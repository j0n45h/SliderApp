import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/loging/logging.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/ramped_graph_screen.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/video_shots_state.dart';
import 'package:sliderappflutter/utilities/colors.dart';
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
    return CubitProvider(
      create: (context) => RampCurveCubit(),
      child: MultiProvider(
        providers: [
          /// Dashboard
          ChangeNotifierProvider<ProvideBtState>(
            create: (context) => ProvideBtState()),
          ChangeNotifierProvider<ProvideLocationState>(
            create: (context) => ProvideLocationState()),
          ChangeNotifierProvider<ProvideWeatherState>(
            create: (context) => ProvideWeatherState()),

          /// Ramping
          ChangeNotifierProvider<TimeState>(
            create: (context) => TimeState()),
          ChangeNotifierProvider<IntervalRangeState>(
            create: (context) => IntervalRangeState()),
          ChangeNotifierProvider<RampingPointsState>(
            create: (context) => RampingPointsState()),
          ChangeNotifierProvider<VideoShotsState>(
            create: (context) => VideoShotsState(),),
        ],
        child: MaterialApp(
          title: 'Slider',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            platform: TargetPlatform.iOS,
            sliderTheme: SliderThemeData(
              activeTrackColor: MyColors.slider,
              thumbColor: MyColors.slider,
              inactiveTrackColor: Colors.grey,
              activeTickMarkColor: MyColors.slider,
              overlayColor: MyColors.slider.withOpacity(0.2),
              valueIndicatorColor: MyColors.slider.withOpacity(0.8),
            ),
          ),
          initialRoute: TimelapseScreen.routeName,
          routes: {
            MyDrawer.routeName: (_) => MyDrawer(),
            DashboardScreen.routeName: (_) => DashboardScreen(),
            TimelapseScreen.routeName: (_) => TimelapseScreen(),
            RampedGraphScreen.routeName: (_) => RampedGraphScreen(),
            AdvancedTimelapseScreen.routeName: (_) => AdvancedTimelapseScreen(),
            VideoScreen.routeName: (_) => VideoScreen(),
            ConnectionScreen.routeName: (_) => ConnectionScreen(),
            SettingsScreen.routeName: (_) => SettingsScreen(),
            LoggingScreen.routeName: (_) => LoggingScreen(),
          },
        ),
      ),
    );
  }
}
