import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/interval_scale.dart';

class RampedGraphScreen extends StatefulWidget {
  static const routeName = '/timelapse-screen/ramped-graph-screen';
  @override
  _RampedGraphScreenState createState() => _RampedGraphScreenState();
}

class _RampedGraphScreenState extends State<RampedGraphScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IntervalScale(),

        ],
      ),
    );
  }
}
