import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/gesture_detector.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/utilities/box_decoraation_frame.dart';
import 'package:sliderappflutter/utilities/map.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampedGraph extends StatefulWidget {
  @override
  _RampedGraphState createState() => _RampedGraphState();
}

class _RampedGraphState extends State<RampedGraph> {
  @override
  Widget build(BuildContext context) {
    final rampPointsCountState = Provider.of<RampingPointsState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(constraints.maxWidth, constraints.maxHeight - 50);
          return CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
            builder: (context, state) {
              context.cubit<RampCurveCubit>().globalSize = size;

              List<Widget> intervalGCList = List.empty(growable: true);
              List<Widget> timeList = List.empty(growable: true);

              for (int i = 0; i < rampPointsCountState.rampingPoints; i++) {
                // Interval
                var top = state[i].getIntervalValue(context, size);
                if (top > size.height) continue;
                var posFromLeft = state[i].getStartValue(context, size);
                final width = (state[i].getEndValue(context, size) - state[i].getStartValue(context, size));
                // if (left > size.width) continue;

                intervalGCList.add(Positioned(
                  top: top - 15,
                  left: posFromLeft,
                  child: Column(
                    children: [
                      Container(
                        height: 30,
                        width: width,
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
                intervalGCList.add(IntervalGestureDetector(i, size));

                if (i != 0) {
                  intervalGCList.add(Positioned(
                    left: posFromLeft,
                    top: top,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      width: 1,
                      height: size.height - top + 15,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ));
                }
                if (i != rampPointsCountState.rampingPoints) {
                  intervalGCList.add(Positioned(
                    left: posFromLeft + width,
                    top: top,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      width: 1,
                      height: size.height - top + 15,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ));
                }

                // Time
                if (i != 0) // skip first
                  timeList.add(timeGestureDetector(state, i, size, true));

                if (i != rampPointsCountState.rampingPoints - 1) // skip second
                  timeList.add(timeGestureDetector(state, i, size, false));
              }


              return Stack(
                children: [
                  CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                    builder: (context, state) => Hero(
                      tag: 'graph',
                      child: ClipPath(
                        clipper: PathClipper(
                          context: context,
                          pointList: state,
                          length: rampPointsCountState.rampingPoints,
                        ),
                        child: Container(
                          height: size.height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF2A96FF).withOpacity(0.85),
                                Color(0xFF2A96FF).withOpacity(0.15),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFF2A96FF).withOpacity(0.15),
                            Color(0xFF2A96FF).withOpacity(0.00),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(
                    // fit: StackFit.expand,
                    alignment: Alignment.topLeft,
                    children: intervalGCList,
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: timeList,
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget timeBox(BuildContext context, DateTime time) {
    return Container(
      width: 70,
      alignment: Alignment.center,
      height: 23,
      padding: const EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecorationFrame().thinFrame,
      child: Text(
        timeToString(context, time),
        style: MyTextStyle.normal(fontSize: 10),
      ),
    );
  }

  Widget timeGestureDetector(List<CubitRampingPoint> state, int index, Size size, bool start) {
    double posFromLeft;
    DateTime time;
    if (start) {
      posFromLeft = state[index].getStartValue(context, size) - 75;
      time = state[index].getStartTime(context, size);
    }
    else {
      posFromLeft = state[index].getEndValue(context, size) - 75;
      time = state[index].getEndTime(context, size);
    }

    return Positioned(
      left: posFromLeft,
      width: 150,
      bottom: 5,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            child: timeBox(
              context,
              time,
            ),
          ),
          TimeGestureDetector(
            size: size,
            index: index,
            start: start,
          ),
        ],
      ),
    );
  }
}
