import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/interval_scale.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/ramped_graph.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/tool_bar.dart';

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
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            ToolBar(),
            RampedGraph(),
            IntervalScale(),
          ],
        ),
      ),
    );
  }
}
