import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/connection.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/weather_state.dart';
import 'package:weather/weather.dart';

class WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProvideWeatherState>(builder: (context, weatherState, _) {
      return FutureBuilder(
        future: weatherState.getWeather(context),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return _weatherIcon(snapshot.data as Weather);
          else
            return _weatherIcon(null);
        },
      );
    });
  }

  Widget _weatherIcon(Weather? weather) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 0.8,
          child: weather?.weatherIcon != null
              ? Image(image: NetworkImage('http://openweathermap.org/img/wn/${weather!.weatherIcon}@2x.png'))
              : Image.asset('assets/icons/noConnection.png'),
        ),
        new Container(
          margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
          child: weather?.temperature?.celsius != null
              ? Text(
                  '${((weather!.temperature!.celsius! * 10).round() / 10).toString()}°C',
                  style: const TextStyle(
                      fontFamily: 'Roboto', fontWeight: FontWeight.w200, color: MyColors.font, fontSize: 15),
                )
              : Text(''),
        ),
      ],
    );
  }
}
