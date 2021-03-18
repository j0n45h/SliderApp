import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';

class IntervalGestureDetector extends StatelessWidget {
  final int index;
  final Size size;
  late RampCurveCubit _provider;

  IntervalGestureDetector(this.index, this.size);



  @override
  Widget build(BuildContext context) {
    _provider = BlocProvider.of<RampCurveCubit>(context);
    return Positioned(
      left: _provider.state[index].getStartValue(context, size),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          _provider.onDragInterval(index, details.delta.dy, context);
        },
        child: Container(
          // height: double.maxFinite,
          height: size.height + 15,
          width: _provider.state[index].getEndValue(context, size) - _provider.state[index].getStartValue(context, size),
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
    final provider = BlocProvider.of<RampCurveCubit>(context);

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
