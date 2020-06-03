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
    if (getSunriseSunsetResult() == null) return null;
    return getSunriseSunsetResult().sunrise.toLocal();
  }

  String get sunRiseTimeStr {
    if (sunRiseTime == null) return '--:--';
    return DateFormat('HH:mm').format(sunRiseTime);
  }

  /// Sun Set
  DateTime get sunSetTime {
    if (getSunriseSunsetResult() == null) return null;
    return getSunriseSunsetResult().sunset.toLocal();
  }

  String get sunSetTimeStr {
    if (sunSetTime == null) return '--:--';
    return DateFormat('HH:mm').format(sunSetTime);
  }

  SunriseSunsetResult getSunriseSunsetResult() {
    if (_locationData == null) return null;
    return getSunriseSunset(
        getLatitude, getLongitude, 0, DateTime.now().toUtc());
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

  static Future<int> getLocation() async {
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

    _locationData = await location.getLocation();
    // _locationData = await compute(getLoc, 1);

    print('latitude: ${_locationData.latitude}');
    print('longitude: ${_locationData.longitude}');

    return 0;
  }

  static Future<LocationData> getLoc(int k) async {
    return await location.getLocation();
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

    /*
    if (_serviceStatus == ServiceStatus.unknown) {
      _serviceStatus = await LocationPermissions().checkServiceStatus();
      if (_serviceStatus == ServiceStatus.notApplicable) {
        print('Device has no Location Service');
        return;
      }
    }
    if (_permissionStatus == PermissionStatus.unknown)
      _permissionStatus = await LocationPermissions().requestPermissions(permissionLevel: LocationPermissionLevel.locationWhenInUse);

    switch (_permissionStatus) {
      case PermissionStatus.denied:
        bool isOpened = false;
        final SnackBar snackBar = SnackBar(
          content: Text('Location Permission denied'),
          duration: Duration(seconds: 15),
          action: SnackBarAction(
            label: 'Open Settings',
            onPressed: () async {
              isOpened = await LocationPermissions().openAppSettings();
              if (!isOpened) return;
              updateMyGeoLocation(context);
              return;
            },
          ),
        );
        Scaffold.of(context).showSnackBar(snackBar);
        return;
      case PermissionStatus.granted:
        print('Location Permission granted');
        break;
      case PermissionStatus.restricted:
        print('granted restricted location services access (only on iOS).');
        break;
      case PermissionStatus.unknown:
        print('Location permission status UNKNOWN');
        return;
    }

    _serviceStatus = await LocationPermissions().checkServiceStatus();
    if (_serviceStatus == ServiceStatus.disabled){
      print('Location Service is Disabled');
      // TODO Turn on GPS
      return;
    }



    try {
      _geolocationStatus = await Geolocator()
          .checkGeolocationPermissionStatus(); // TODO make request to enable GPS if off (Time off)
      if (_geolocationStatus == GeolocationStatus.denied) {
        print('Location Permission not given');
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return _locationAlertDialog(context);
          },
        );
      }
    } catch (e) {
      print('Failed to access location status: $e');
    }

    try {
      _position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          locationPermissionLevel: GeolocationPermission.locationWhenInUse);
    } catch (e) {
      print('Could not get user Position data: $e');
    }

     */

    notifyListeners();

    // get weather update
    final weatherStateProvider =
        Provider.of<ProvideWeatherState>(context, listen: false); // Weather

    weatherStateProvider.updateWeather(context);
    notifyListeners();
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
