import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/dashboard/custom_painter.dart';
import 'package:sliderappflutter/dashboard/sun.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';

class SunPositionWave extends StatefulWidget {
  const SunPositionWave({Key key}) : super(key: key);
  @override
  _SunPositionWaveState createState() => _SunPositionWaveState();
}

class _SunPositionWaveState extends State<SunPositionWave>
    with TickerProviderStateMixin {
  Animation _sunAnimation;
  AnimationController _sunAnimationController;
  Animation _colorGradientAnimation;
  AnimationController _colorGradientAnimationController;
  bool _hasSunPosition = false;
  static double _height;

  @override
  void initState() {
    super.initState();
    setupSunAnimation();
    _colorGradientAnimationController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
  }

  @override
  void dispose() {
    _sunAnimationController.dispose();
    _colorGradientAnimationController.dispose();
    super.dispose();
  }

  void setupSunAnimation() {
    _sunAnimationController =
        AnimationController(duration: const Duration(hours: 24), vsync: this);

    _sunAnimation = Tween(begin: 0.0, end: 1.0).animate(_sunAnimationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _sunAnimationController.reset();
          _sunAnimationController.forward();
        }
      });
  }

  void setupColorGradientAnimation(double newHeight) {
    _colorGradientAnimation =
        Tween<double>(begin: _height, end: newHeight).animate(_colorGradientAnimationController)
          ..addListener(() {
            setState(() {});
          });
  }


  double currentSunPosition(
      ProvideLocationState locationStateProvider, Size size) {
    if (!locationStateProvider.available()){
      return size.height / 2;
    }
    if (_hasSunPosition) return _height;

    DateTime halfTime = locationStateProvider.sunSetTime.subtract(
        locationStateProvider.sunRiseTime
            .difference(locationStateProvider.sunSetTime));

    DateTime beginTime = halfTime.subtract(Duration(hours: 12));
    DateTime endTime = halfTime.add(Duration(hours: 12));

    double position = map(
        DateTime.now().millisecondsSinceEpoch.toDouble(),
        beginTime.millisecondsSinceEpoch.toDouble(),
        endTime.millisecondsSinceEpoch.toDouble(),
        0.0,
        1.0);
    position %= 1;


    double sunSetHeight = map(
        locationStateProvider.sunSetTime.millisecondsSinceEpoch.toDouble(),
        beginTime.millisecondsSinceEpoch.toDouble(),
        endTime.millisecondsSinceEpoch.toDouble(),
        0.0,
        1.0);
    sunSetHeight %= 1;

    final height = SunPath.calculate(sunSetHeight, size).dy;

    setupColorGradientAnimation(height);

    Timer.run(() {
      _sunAnimationController.forward(from: position);
      _colorGradientAnimationController.forward();
    });
    _hasSunPosition = true;
    return height;
  }


  @override
  Widget build(BuildContext context) {
    final size = Size(MediaQuery.of(context).size.width, 80);
    return Consumer<ProvideLocationState>(
      builder: (context, locationStateProvider, _) {
        _height = currentSunPosition(locationStateProvider, size);
        return Container(
          alignment: Alignment.center,
          height: size.height + 20,
          width: size.width,
          child: Stack(
            children: <Widget>[
              Container(
                width: 10,
                height: size.height + 20,
              ),
              ClipPath(
                clipper: SineWaveClipper(invert: true),
                child: Container(
                  height: size.height,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                      begin: Alignment(
                        0, map(_colorGradientAnimation == null
                          ? _height
                          : _colorGradientAnimation.value * 0.8,
                          0, size.height, -1, 1)
                          // * _colorGradientAnimation.value
                      ),
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF000000).withOpacity(0.00),
                        Color(0xFF004DD1).withOpacity(0.28),
                        Color(0xFF0048EB).withOpacity(0.35),
                        Color(0xFF0101FC).withOpacity(0.54),
                      ])),
                ),
              ),
              ClipPath(
                clipper: SineWaveClipper(invert: false),
                child: Container(
                  height: size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment(
                            0, map(_colorGradientAnimation == null
                            ? _height
                            : _colorGradientAnimation.value * 1.2,
                            0, size.height, -1, 1)
                              // * _colorGradientAnimation.value
                        ),
                        colors: [
                          Color(0xFFFF9900).withOpacity(0.80),
                          Color(0xFFFF5900).withOpacity(0.57),
                          Color(0xFFB23300).withOpacity(0.61),
                          Color(0xFF601C00).withOpacity(0.58),
                          Color(0xFF000000).withOpacity(0.00),
                        ]),
                  ),
                ),
              ),
              Container(
                // Sine wave line
                width: size.width,
                height: size.height,
                child: CustomPaint(
                  painter: SineWavePainter(),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                top: _height,
                width: size.width,
                height: 1,
                child: Divider(
                  color: Colors.grey[700],
                  thickness: 0.8,
                ),
              ),
              Positioned(
                top: SunPath.calculate(_sunAnimation.value, size).dy,
                left: SunPath.calculate(_sunAnimation.value, size).dx,
                child: Container(
                  height: 30,
                  width: 30,
                  transform: Matrix4.translationValues(-15, -15, 0),
                  child: AnimatedCrossFade(
                    crossFadeState: _hasSunPosition
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 2000),
                    firstChild: const Sun(),
                    secondChild: Container(
                      height: 22,
                      width: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}