import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/gesture_detector.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampedGraph extends StatefulWidget {
  @override
  _RampedGraphState createState() => _RampedGraphState();
}

class _RampedGraphState extends State<RampedGraph> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight - 50);
          return CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
            builder: (context, state) {
              context.cubit<RampCurveCubit>().globalSize = size;

              List<Widget> list = List.empty(growable: true);
              for (int i = 0; i < state.length; i++) {
                var top = state[i].getIntervalValue(context, size);
                if (top > size.height) continue;
                var left = state[i].getStartValue(context, size);
                // if (left > size.width) continue;

                list.add(Positioned(
                  top: top - 15,
                  left: left,
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        width: (state[i].getEndValue(context, size) - state[i].getStartValue(context, size)),
                        child: Icon(
                          Icons.unfold_more,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                      CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                        builder: (context, state) {
                          final interval = ((state[i].interval.inMilliseconds / 100).round() / 10).toString();
                          return Text(
                            interval + 's',
                            style: MyTextStyle.normal(fontSize: 14),
                          );
                        },
                      ),
                    ],
                  ),
                ));
                list.add(MyGestureDetector(i, size));
              }
              return Stack(
                children: [
                  CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                    builder: (context, state) => ClipPath(
                      clipper: PathClipper(
                        context: context,
                        pointList: state,
                      ),
                      child: Container(
                        height: size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFF2A96FF).withOpacity(0.85),
                              Color(0xFF2A96FF).withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    // fit: StackFit.expand,
                    alignment: Alignment.topLeft,
                    children: list,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
