import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';
import 'package:weather/weather.dart';

class ProvideWeatherState with ChangeNotifier {
  static const String _openWeatherMapKey = 'baa5ee1094f9f173005067c6b168c3c8';
  static var _weatherFactory = WeatherFactory(_openWeatherMapKey);
  static Weather?_weather;

  Future<Weather?> getWeather(BuildContext context) async {
    if (_weather != null)
      return _weather;

    await updateWeather(context);
    return _weather;
  }


  bool available() {
    return (_weather != null);
  }

  Future<void> updateWeather(BuildContext context) async {
    final locationState = context.read<ProvideLocationState>();
    if (!locationState.available())
      return;

    if (!await InternetConnectionChecker().hasConnection)
      return;


    try {
      _weather = await compute(_getTreadWeather, [locationState.getLatitude!, locationState.getLongitude!]).timeout(Duration(seconds: 15));
     // _weather = await _weatherStation.currentWeather(locationState.getLatitude, locationState.getLongitude).timeout(Duration(seconds: 10));

    } on TimeoutException catch (_){
      print('could not load weather, time out');
    } catch (e) {
      print('Could not get Weather information: $e');
    }
    notifyListeners();
  }

  static Future<Weather?> _getTreadWeather(List<double> location) async {
    return await _weatherFactory.currentWeatherByLocation(location[0], location[1]);
  }
}
