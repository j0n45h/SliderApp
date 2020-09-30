import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';

class SunriseSunsetIcons extends StatelessWidget {
  static bool _didBuild = false;
  static double _space;

  const SunriseSunsetIcons();

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    // return Container(color: Colors.red, width: 40, height: 20,);
    return Consumer<ProvideLocationState>(builder: (context, locationState, _) {
      _space = iconSpacing(locationState, MediaQuery.of(context).size);
      return Container(
        alignment: Alignment.center,
        height: 20,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: <Widget>[
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: _space,
              height: 20,
              // width: 70,
              child: SunRiseIcon(locationState),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              right: _space,
              height: 20,
              // width: 70,
              child: SunSetIcon(locationState),
            ),
          ],
        ),
      );
    });
  }


  double iconSpacing(ProvideLocationState locationStateProvider, Size size) {
    if (locationStateProvider.sunSetTime == null) return 80;

    // TODO use [SunPath.calculate(sunSetHeight, size).dx]
    Duration halfDuration = locationStateProvider.sunSetTime
        .difference(locationStateProvider.sunRiseTime);

    double space = map(halfDuration.inMilliseconds.toDouble(), 0,
        Duration(hours: 24).inMilliseconds.toDouble(), size.width / 2 - 30, 0);

    if (space < 15) return 15;
    return space;
  }

  void onBuild(BuildContext context) async {
    if (_didBuild) return;

    final locationStateProvider = Provider.of<ProvideLocationState>(context, listen: false);
    await locationStateProvider.updateMyGeoLocation(context);

    _didBuild = true;
  }
}






class SunRiseIcon extends StatelessWidget {
  final ProvideLocationState _locationState;

  SunRiseIcon(this._locationState);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Image.asset(
            'assets/icons/SunArrow.png',
            scale: 8,
          ),
        ),
        Text(
          _locationState.sunRiseTimeStr(context),
          style: const TextStyle(
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w200,
              color: MyColors.font,
              fontSize: 14),
        ),
      ],
    );
  }
}

class SunSetIcon extends StatelessWidget {
  final ProvideLocationState _locationState;

  SunSetIcon(this._locationState);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Transform.rotate(
            angle: pi / 2,
            child: Image.asset(
              'assets/icons/SunArrow.png',
              scale: 8,
            ),
          ),
        ),
        Text(
          _locationState.sunSetTimeStr(context),
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w200,
            color: MyColors.font,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
