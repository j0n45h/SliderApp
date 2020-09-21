import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';

class MyGestureDetector extends StatelessWidget {
  final int index;
  final Size size;
  final rebuildParent;
  MyGestureDetector(this.index, this.size, this.rebuildParent);

  @override
  Widget build(BuildContext context) {
    final provider = CubitProvider.of<RampCurveCubit>(context);
    return Positioned(
      left: provider.state[index].getStartValue(context, size),
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
           provider.onDragInterval(index, details.delta.dy, context);
           // rebuildParent();
        },
        child: Container(
          height: double.maxFinite,
          width: provider.state[index].getEndValue(context, size)
              - provider.state[index].getStartValue(context, size),
          color: Colors.red.withOpacity(0.9),
        ),
      ),
    );
  }
}
