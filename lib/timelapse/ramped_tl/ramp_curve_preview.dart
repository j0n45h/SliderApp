import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/ramped_graph_screen.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/ramping_point.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampCurvePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        InkWell(
          onTap: () => navigateToRampedGraph(context),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.rotate(
              angle: pi/4,
              child: Icon(
                Icons.unfold_more,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void navigateToRampedGraph(BuildContext context) {
    final timeState = Provider.of<TimeState>(context, listen: false);
    if (timeState.endingTime == null) {
      _showTimeNotSetSnakeBar(context);
      return;
    }

    final rampCurveCubit = CubitProvider.of<RampCurveCubit>(context);
    rampCurveCubit.state.clear();
    rampCurveCubit.addList([
      CubitRampingPoint(
        newRampingPoint: RampingPoint(
          interval: 12,
          startTime: DateTime.now().add(Duration(minutes: 0)),
          endTime: DateTime.now().add(Duration(minutes: 30)),
        ),
      ),
      CubitRampingPoint(
        newRampingPoint: RampingPoint(
          interval: 12,
          startTime: DateTime.now().add(Duration(minutes: 60)),
          endTime: DateTime.now().add(Duration(minutes: 90)),
        ),
      ),
      CubitRampingPoint(
        newRampingPoint: RampingPoint(
          interval: 12,
          startTime: DateTime.now().add(Duration(minutes: 120)),
          endTime: DateTime.now().add(Duration(minutes: 140)),
        ),
      ),
    ]);

    Navigator.of(context).pushNamed(RampedGraphScreen.routeName);
  }

  void _showTimeNotSetSnakeBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.redAccent,
      elevation: 40,
      behavior: SnackBarBehavior.fixed,
      content: Text(
        'End-Time is not set!',
        style: MyTextStyle.fetStdSize(),
      ),
    ));
  }
}
