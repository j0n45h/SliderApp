import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/weather_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';
import 'package:sunrise_sunset_calc/sunrise_sunset_calc.dart';

class ProvideLocationState with ChangeNotifier {
  static Location location = new Location();
  static bool _serviceEnabled;
  static PermissionStatus _permissionGranted;
  static LocationData _locationData;

  static DateTime _sunRiseTime;
  static DateTime _sunSetTime;


  /// Location Latitude
  double get getLatitude {
    if (_locationData == null) return null;
    return _locationData.latitude;
  }

  /// Location Longitude
  double get getLongitude {
    if (_locationData == null) return null;
    return _locationData.longitude;
  }

  bool available() {
    return (_locationData != null);
  }

  /// Sun Rise

  DateTime get sunRiseTime {
    return _sunRiseTime;
  }

  String get sunRiseTimeStr {
    if (_sunRiseTime == null) return '--:--';
    return DateFormat('HH:mm').format(_sunRiseTime);
  }

  /// Sun Set

  DateTime get sunSetTime {
    return _sunSetTime;
  }

  String get sunSetTimeStr {
    if (_sunSetTime == null) return '--:--';
    return DateFormat('HH:mm').format(_sunSetTime);
  }

  static void getSunriseSunsetResult() {
    if (_locationData == null) return null;
    SunriseSunsetResult sunriseSunsetResult = getSunriseSunset(
        _locationData.latitude, _locationData.longitude, 0, DateTime.now().toUtc());
    _sunRiseTime = sunriseSunsetResult.sunrise.toLocal();
    _sunSetTime  = sunriseSunsetResult.sunset.toLocal();
  }

  void showSnackBar(BuildContext context) {
    final SnackBar snackBar = SnackBar(
      backgroundColor: MyColors.popup,
      elevation: 10,
      content: Text(
        'Location Permission denied',
        style: MyTextStyle.fetStdSize(),
        textAlign: TextAlign.center,
      ),
      duration: Duration(seconds: 10),
    );
    Scaffold.of(context).showSnackBar(snackBar);
    return;
  }

  /// prevent calling [getLocation] on each rebuild
  static bool _reCallBlocked = false;
  static void blockReCall() async {
    _reCallBlocked = true;
    await Future.delayed(Duration(seconds: 30));
    _reCallBlocked = false;
  }

  static Future<int> getLocation() async {
    if (_reCallBlocked) return 0;
    blockReCall();
    _permissionGranted = await location.hasPermission();
    print('permission: ${_permissionGranted.toString()}');
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return -1;
      }
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      return -1;
    }

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return -2;
      }
    }

    location.changeSettings(accuracy: LocationAccuracy.balanced);
    try {
      _locationData = await location.getLocation().timeout(Duration(minutes: 2));
    } on TimeoutException catch (e){
      print('time out! $e');
    } catch (e) {
      print('could not get location $e');
    }

    getSunriseSunsetResult();
    print('latitude: ${_locationData.latitude}');
    print('longitude: ${_locationData.longitude}');

    return 0;
  }





  Future<void> updateMyGeoLocation(BuildContext context) async {
    int check;
    try {
      check = await getLocation().timeout(Duration(seconds: 20));
    } on TimeoutException catch (e) {
      print('Location time out: $e');
      return;
    } catch (e) {
      print('Error during getting Location: $e');
      return;
    }

    if (check < 0) {
      showSnackBar(context);
      return;
    }

    notifyListeners();

    // get weather update
    final weatherStateProvider =
        Provider.of<ProvideWeatherState>(context, listen: false); // Weather

    weatherStateProvider.updateWeather(context);
  }







  Widget _locationAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Permission is not given!'),
      content: const Text(
          'We need to access your Location to get Weather information and Sun position.'),
      backgroundColor: const Color(0xff316f7f),
      shape: const RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      titleTextStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        letterSpacing: 2,
        fontSize: 20,
      ),
      contentTextStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w300,
        letterSpacing: 2,
        fontSize: 16,
      ),
      actions: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 25, 0),
          child: MaterialButton(
            shape: const RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            elevation: 10,
            color: MyColors.font,
            padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Ok',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
