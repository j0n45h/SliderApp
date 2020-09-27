import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';
import 'package:weather/weather_library.dart';

class ProvideWeatherState with ChangeNotifier {
  static String _openWeatherMapKey = 'baa5ee1094f9f173005067c6b168c3c8';
  static WeatherStation _weatherStation = new WeatherStation(_openWeatherMapKey);
  static Weather _weather;

  Weather get getWeather {
    return _weather;
  }


  bool available() {
    return (_weather != null);
  }

  Future<void> updateWeather(BuildContext context) async {
    final locationState = context.read<ProvideLocationState>();
    if (!locationState.available()) return;
    print('getting weather');
    if (!await DataConnectionChecker().hasConnection)
      return;
    try {
      _weather = await compute(getTreadWeather, [locationState.getLatitude, locationState.getLongitude]).timeout(Duration(seconds: 15));
     // _weather = await _weatherStation.currentWeather(locationState.getLatitude, locationState.getLongitude).timeout(Duration(seconds: 10));

    } on TimeoutException catch (e){
      print('no internet connection, could not load weather');
    } catch (e) {
      print('Could not get Weather information: $e');
    }
    notifyListeners();
  }

  static Future<Weather> getTreadWeather(List<double> location) async {
    return await _weatherStation.currentWeather(location[0], location[1]);
  }
}