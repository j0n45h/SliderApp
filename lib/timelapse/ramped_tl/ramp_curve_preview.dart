import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/navigte_to_graph_screen.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';

class RampCurvePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rampPointsCountState = Provider.of<RampingPointsState>(context, listen: false);
    return Container(
      height: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => NavigateToGraphScreen(context).navigate(),
            child: CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Builder(
                    builder: (context) {
                      if (state.length < 1)
                        return Container();

                      return Hero(
                        tag: 'graph',
                        child: CustomPaint(
                          painter: PathPainter(context, state, rampPointsCountState.rampingPoints),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () => NavigateToGraphScreen(context).navigate(),
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
          ),
        ],
      ),
    );
  }
}
