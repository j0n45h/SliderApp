import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampingPoints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool showSnakeBar = false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RAMPING POINTS',
          style: MyTextStyle.normal(fontSize: 12),
        ),
        Consumer<RampingPointsState>(
          builder: (context, rampingPointsState, child) => Slider(
            onChangeStart: (value) {
              context.cubit<RampCurveCubit>().newEvent();
            },
            onChanged: (value) {
              rampingPointsState.rampingPoints = value.floor();

              // check if undo is possible and if it has been created
              if (context.cubit<RampCurveCubit>().canUndo && context.cubit<RampCurveCubit>().wasOpened)
                showSnakeBar = true;

              context.cubit<RampCurveCubit>().updatePoints(context);
            },
            onChangeEnd: (value) {
              if (!showSnakeBar)
                return;

              showSnakeBar = false;
              _showSnakeBar(context);
            },
            value: rampingPointsState.rampingPoints.toDouble(),
            label: rampingPointsState.rampingPoints.toString(),
            divisions: 4,
            max: 5,
            min: 1,
          ),
        ),
      ],
    );
  }

  void _showSnakeBar(BuildContext context) {
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        elevation: 40,
        behavior: SnackBarBehavior.fixed,
        content: Text(
          'Previous points overridden!',
          style: MyTextStyle.fetStdSize(),
        ),
        action: SnackBarAction(
          label: "UNDO",
          textColor: Colors.white,
          onPressed: () {
            // context.cubit<RampCurveCubit>().myUndo();
            context.cubit<RampCurveCubit>().undo();

            final rampingPointsState = Provider.of<RampingPointsState>(context, listen: false);

            final pointsCount = context.cubit<RampCurveCubit>().state.length;
            rampingPointsState.rampingPoints = pointsCount >= 1 && pointsCount <= 5 ? pointsCount : 3; // undo Slider

            if (context.cubit<RampCurveCubit>().state.length == 0)
              context.cubit<RampCurveCubit>().updatePoints(context); // recalc Points
          },
        ),
      ),
    );
  }
}
