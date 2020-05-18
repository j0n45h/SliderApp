import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/weather_state.dart';
import 'package:weather/weather_library.dart';

class WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvideWeatherState>(builder: (context, weatherState, _) {
      if (weatherState.available()) {
        Weather weather = weatherState.getWeather;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Transform.scale(
                scale: 0.8,
                child: Image(
                  image: NetworkImage(
                    'http://openweathermap.org/img/wn/${weather.weatherIcon.toString()}@2x.png',
                  ),
                )),
            new Container(
              margin: const EdgeInsets.fromLTRB(2, 45, 0, 0),
              child: Text(
                '${((weather.temperature.celsius * 10).round() / 10).toString()}°C',
                style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w200,
                    color: MyColors.font,
                    fontSize: 20),
              ),
            ),
          ],
        );
      } else {
        return new Container(
          height: 100,
        );
      }
    });
  }
}
