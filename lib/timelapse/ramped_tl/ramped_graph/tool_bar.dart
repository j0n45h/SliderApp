import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

import 'Logic/cubit.dart';

class ToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30),
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Text(
                'SHOTS',
                style: MyTextStyle.normal(fontSize: 12),
              ),
              const SizedBox(width: 10),
              FramedTextField(
                width: 75,
                height: 25,
                textField: BlocBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                  builder: (context, state) {
                    final shots = BlocProvider.of<RampCurveCubit>(context, listen: false).getShots(context);
                    return Text(
                        shots.toString(),
                        style: MyTextStyle.normal(fontSize: 12),
                    );
                  },
                ),
              ),
            ],
          ),
          Text(
            '',
            style: MyTextStyle.normal(fontSize: 14),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
                onPressed: () {
                  final rampingPointsState = Provider.of<RampingPointsState>(context, listen: false);
                  rampingPointsState.rampingPoints--;
                  if (rampingPointsState.rampingPoints < 1)
                    rampingPointsState.rampingPoints = 1;

                  BlocProvider.of<RampCurveCubit>(context, listen: false).updatePoints(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: () {
                  final rampingPointsState = Provider.of<RampingPointsState>(context, listen: false);
                  rampingPointsState.rampingPoints++;
                  if (rampingPointsState.rampingPoints > 5)
                    rampingPointsState.rampingPoints = 5;

                  BlocProvider.of<RampCurveCubit>(context, listen: false).updatePoints(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.check, color: MyColors.green),
                onPressed: () => Navigator.of(context).pop(),
              ),
              SizedBox(width: 15)
            ],
          ),
        ],
      ),
    );
  }
}
