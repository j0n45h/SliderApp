import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/ramped_graph_screen.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampCurvePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
          builder: (context, state) {
            if (state.length < 1)
              return Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              );

            return Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                height: 120,
                width: double.maxFinite,
                child: CustomPaint(
                  painter: PathPainter(context, state),
                ),
              ),
            );
          },
        ),
        InkWell(
          onTap: () => navigateToRampedGraph(context),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.rotate(
              angle: pi / 4,
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

    if (!context.cubit<RampCurveCubit>().isCreated)
      context.cubit<RampCurveCubit>().recreatePoints(context);

    context.cubit<RampCurveCubit>().wasOpened = true;

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
