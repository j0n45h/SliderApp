import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/dashboard/custom_painter.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/state/locatin_state.dart';

class SunPositionWave extends StatefulWidget {
  const SunPositionWave();
  @override
  _SunPositionWaveState createState() => _SunPositionWaveState();
}

class _SunPositionWaveState extends State<SunPositionWave>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController controller;
  bool _hasSunPosition = false;
  double _height;
  Size size;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(hours: 24), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reset();
          controller.forward();
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void currentSunPosition(
      ProvideLocationState locationStateProvider, Size size) {
    // final locationStateProvider = context.watch<ProvideLocationState>();
    if (!locationStateProvider.available()) return;
    if (_hasSunPosition) return;
    Timer.run(() {
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

      controller.forward(from: position);

      double sunSetHeight = map(
          locationStateProvider.sunSetTime.millisecondsSinceEpoch.toDouble(),
          beginTime.millisecondsSinceEpoch.toDouble(),
          endTime.millisecondsSinceEpoch.toDouble(),
          0.0,
          1.0);
      sunSetHeight %= 1;

      _height = SunPath.calculate(sunSetHeight, size).dy;

      _hasSunPosition = true;
    });
  }

  void onBuild(BuildContext context) {
    if (size != null) return;
    size = Size(MediaQuery.of(context).size.width, 80);
    _height = size.height / 2;
  }

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    // print('height: ${SunPath.calculate(animation.value, size).dy}');
    return Consumer<ProvideLocationState>(
      builder: (context, locationStateProvider, _) {
        currentSunPosition(locationStateProvider, size);
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
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color(0xff000000).withOpacity(0),
                        Color(0xff000000).withOpacity(0),
                        Color(0xff007FFF).withOpacity(0.16),
                        Color(0xff0022FF).withOpacity(0.28),
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
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFF9900).withOpacity(0.62),
                          Color(0xFFFF4900).withOpacity(0.40),
                          Color(0xFF601C00).withOpacity(0.24),
                          Color(0xFF242F33).withOpacity(0.00),
                          Color(0xFF242F33).withOpacity(0.00),
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
                duration: Duration(milliseconds: 1000),
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
                top: SunPath.calculate(animation.value, size).dy,
                left: SunPath.calculate(animation.value, size).dx,
                child: Container(
                  height: 20,
                  width: 20,
                  transform: Matrix4.translationValues(-10, -10, 0),
                  child: AnimatedCrossFade(
                    crossFadeState: _hasSunPosition
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: Duration(milliseconds: 2000),
                    firstChild: Container(
                      // Sun
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          gradient: RadialGradient(
                        colors: [
                          Color(0xffff6e00),
                          Color(0xffff7e00),
                          Color(0xffff7e00).withOpacity(0)
                        ],
                        // center: Alignment.topLeft,
                      )),
                    ),
                    secondChild: Container(
                      height: 20,
                      width: 20,
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
