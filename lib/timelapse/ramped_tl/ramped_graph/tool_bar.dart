import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class ToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
                textField: CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                  builder: (context, state) {
                    var shots = context.cubit<RampCurveCubit>().getShots();
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
                  context.cubit<RampCurveCubit>().undo();
                },
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
                onPressed: () {
                  context.cubit<RampCurveCubit>().add(CubitRampingPoint(
                    interval: Duration(seconds: 17),
                    start: Duration(minutes: 180),
                    end: Duration(minutes: 200),
                  ));
                },
              ),
              IconButton(
                icon: Icon(Icons.check, color: MyColors.green),
              ),
              SizedBox(width: 15)
            ],
          ),
        ],
      ),
    );
  }
}
