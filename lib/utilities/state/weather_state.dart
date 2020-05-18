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
/*
  updateWeather(dynamic context) async {
    final locationState = Provider.of<ProvideLocationState>(context, listen: false);
    if (locationState.available()) {
      try {
        _weather = await _weatherStation.currentWeather(locationState.getLatitude, locationState.getLongitude);
      } catch (e) {
        print('Could not get Weather information: $e');
      }
      notifyListeners();
    }
  }

 */
}