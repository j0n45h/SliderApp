import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class ProvideLocationState with ChangeNotifier {
  static Position _position;
  static GeolocationStatus _geolocationStatus;

  double get getLatitude {
    if(_position == null)
      return null;
    else
      return _position.latitude;
  }

  double get getLongitude {
    if(_position == null)
      return null;
    else
      return _position.longitude;
  }

  bool available() {
    return (_position != null);
  }

  void updateMyGeoLocation(dynamic context) async {
    try {
      _geolocationStatus = await Geolocator().checkGeolocationPermissionStatus();
      print(_geolocationStatus.value); // test
      if (_geolocationStatus.toString() != 'GeolocationStatus.granted') {
        print('Location Permission not given');
        await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return locationAlertDialog(context);
          },
        );
      }
    } catch (e) {
      print('Failed to access location status: $e');
    }

    try {
      _position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low, locationPermissionLevel: GeolocationPermission.locationWhenInUse);
    } catch (e) {
      print('Could not get user Position data: $e');
    }
    notifyListeners();
  }

  Widget locationAlertDialog(dynamic context){
    return AlertDialog(
      title: const Text('Location Permission is not given!'),
      content: const Text(
          'We need to access your Location to get Weather information and Sun position.'),
      backgroundColor: Color(0xff316f7f),
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