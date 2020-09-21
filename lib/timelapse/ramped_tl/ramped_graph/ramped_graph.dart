import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/gesture_detector.dart';

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
          final rampCurveCubit = CubitProvider.of<RampCurveCubit>(context);
          final size = Size(constraints.maxWidth, constraints.maxHeight - 50);
          return CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
            builder: (context, state) {
              final rampCurveCubit = CubitProvider.of<RampCurveCubit>(context);
              rampCurveCubit.globalSize = size;

              List<Widget> list = List.empty(growable: true);
//              list.add(ClipPath(
//                clipper: PathClipper(
//                  context: context,
//                  pointList: state,
//                ),
//                child: Container(
//                  height: size.height,
//                  decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                      begin: Alignment.topCenter,
//                      end: Alignment.bottomCenter,
//                      colors: [
//                        Color(0xFF2A96FF).withOpacity(0.85),
//                        Color(0xFF2A96FF).withOpacity(0.05),
//                      ],
//                    ),
//                  ),
//                ),
//              ));

              for (int i=0; i<state.length; i++) {
                var top = state[i].getIntervalValue(context, size);
                if (top > size.height) continue;
                var left = state[i].getStartValue(context, size) + (state[i].getEndValue(context, size)
                    - state[i].getStartValue(context, size)) / 2;
                // if (left > size.width) continue;

                list.add(Positioned(
                  top: top,
                  left: left,
                  child: Icon(Icons.unfold_more, color: Color(0xff7B7B7B).withOpacity(0.9)),
                ));
                list.add(MyGestureDetector(i, size, () => setState(() {})));
                // list.add(GestureDetector());
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
