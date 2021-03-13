import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';

class IntervalGestureDetector extends StatelessWidget {
  final int index;
  final Size size;

  IntervalGestureDetector(this.index, this.size);

  @override
  Widget build(BuildContext context) {
    final provider = CubitProvider.of<RampCurveCubit>(context);
    return Positioned(
      left: provider.state[index].getStartValue(context, size),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          provider.onDragInterval(index, details.delta.dy, context);
        },
        child: Container(
          // height: double.maxFinite,
          height: size.height + 15,
          width: provider.state[index].getEndValue(context, size) - provider.state[index].getStartValue(context, size),
          color: Colors.red.withOpacity(0),
        ),
      ),
    );
  }
}

class TimeGestureDetector extends StatelessWidget {
  final int index;
  final Size size;
  final bool start; // GestureDetector for start or for end Time
  TimeGestureDetector({
    required this.index,
    required this.size,
    required this.start,
  });

  @override
  Widget build(BuildContext context) {
    final provider = CubitProvider.of<RampCurveCubit>(context);

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (start)
          provider.onDragStartTime(index, details.delta.dx, context);
        else
          provider.onDragEndTime(index, details.delta.dx, context);
      },
      child: Container(
        width: 85,
        height: 25,
        color: Colors.red.withOpacity(0),
      ),
    );
  }
}
