import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class NewLocation {
  static bool _serviceEnabled;
  static PermissionStatus _permissionGranted;
  static LocationData _locationData;

  LocationData get locationData {
    if (_locationData == null) return null;
    return _locationData;
  }

  static void getNewLocation(BuildContext context) async {
    Location location = new Location();

    _permissionGranted = await location.hasPermission();
    print('permission: ${_permissionGranted.toString()}');
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
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
    } else if (_permissionGranted == PermissionStatus.deniedForever) {
      final SnackBar snackBar = SnackBar(
        content: Text('Location Permission denied'),
        duration: Duration(seconds: 10),
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    location.changeSettings(accuracy: LocationAccuracy.balanced);

    _locationData = await location.getLocation();

    print('latitude: ${_locationData.latitude}');
    print('longitude: ${_locationData.longitude}');
  }
}
