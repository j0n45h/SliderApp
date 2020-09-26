import 'dart:async';
import 'dart:math' as math;

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


    Duration dayLight =  locationStateProvider.sunSetTime.difference(locationStateProvider.sunRiseTime);

    DateTime solarNoon = locationStateProvider.sunSetTime.subtract(
        Duration(milliseconds: (dayLight.inMilliseconds/2).round()));

    DateTime beginTime = solarNoon.subtract(Duration(hours: 12));
    DateTime endTime = solarNoon.add(Duration(hours: 12));

    double position = map(
        DateTime.now().millisecondsSinceEpoch.toDouble(),
        beginTime.millisecondsSinceEpoch.toDouble(),
        endTime.millisecondsSinceEpoch.toDouble(),
        0.0,
        1.0);
    position %= 1;

    print(locationStateProvider.sunSetTime);



    double sunSetHeight = map(
        locationStateProvider.sunSetTime.millisecondsSinceEpoch.toDouble(),
        beginTime.millisecondsSinceEpoch.toDouble(),
        endTime.millisecondsSinceEpoch.toDouble(),
        0.0,
        1.0,
    );
    sunSetHeight %= 1;

    final height = size.height - SunPath.calculate(sunSetHeight, size).dy;


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












void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Collapsing List Demo')),
        body: CollapsingList(),
      ),
    );
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
class CollapsingList extends StatelessWidget {
  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 0.0,
        maxHeight: 200.0,
        child: Container(
            color: Colors.lightBlue, child: Center(child:
        Text(headerText))),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        makeHeader('Header Section 1'),
        SliverGrid.count(
          crossAxisCount: 3,
          children: [
            Container(color: Colors.red, height: 150.0),
            Container(color: Colors.purple, height: 150.0),
            Container(color: Colors.green, height: 150.0),
            Container(color: Colors.orange, height: 150.0),
            Container(color: Colors.yellow, height: 150.0),
            Container(color: Colors.pink, height: 150.0),
            Container(color: Colors.cyan, height: 150.0),
            Container(color: Colors.indigo, height: 150.0),
            Container(color: Colors.blue, height: 150.0),
          ],
        ),
        makeHeader('Header Section 2'),
        SliverFixedExtentList(
          itemExtent: 150.0,
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.red),
              Container(color: Colors.purple),
              Container(color: Colors.green),
              Container(color: Colors.orange),
              Container(color: Colors.yellow),
            ],
          ),
        ),
        makeHeader('Header Section 3'),
        SliverGrid(
          gridDelegate:
          new SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200.0,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: 4.0,
          ),
          delegate: new SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return new Container(
                alignment: Alignment.center,
                color: Colors.teal[100 * (index % 9)],
                child: new Text('grid item $index'),
              );
            },
            childCount: 20,
          ),
        ),
        makeHeader('Header Section 4'),
        // Yes, this could also be a SliverFixedExtentList. Writing
        // this way just for an example of SliverList construction.
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(color: Colors.pink, height: 150.0),
              Container(color: Colors.cyan, height: 150.0),
              Container(color: Colors.indigo, height: 150.0),
              Container(color: Colors.blue, height: 150.0),
            ],
          ),
        ),
      ],
    );
  }
}