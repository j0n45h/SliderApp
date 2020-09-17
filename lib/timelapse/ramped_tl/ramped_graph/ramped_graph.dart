import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';

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
          print('length of cubit: ${rampCurveCubit.state.length}');
          final size = Size(constraints.maxWidth, constraints.maxHeight - 50);
          print('size: $size');
          return CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
            builder: (context, state) {
              final rampCurveCubit = CubitProvider.of<RampCurveCubit>(context);
              rampCurveCubit.globalSize = size;
              return Stack(
                // fit: StackFit.expand,
                children: [
                  ClipPath(
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
//                  CustomPaint(
//                    painter: PathPainter(
//                      context: context,
//                      pointList: state,
//                    ),
//                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
