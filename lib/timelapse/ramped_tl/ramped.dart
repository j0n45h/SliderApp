import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/interval_range.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramp_curve_preview.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/set_button.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/start_end_duration.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/video_shots.dart';
import 'package:sliderappflutter/timelapse/save_start_buttons.dart';

class RampedTL extends StatefulWidget {
  @override
  _RampedTLState createState() => _RampedTLState();
}

class _RampedTLState extends State<RampedTL> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OrientationBuilder(// TODO: not the best way. Better to check if ListView fits on screen or not
            builder: (context, orientation) {
          return ListView(
            physics: orientation == Orientation.portrait ? NeverScrollableScrollPhysics() : null,
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
            children: [
              StartEndDuration(),
              const SizedBox(height: 30),
              RampingPoints(),
              const SizedBox(height: 25),
              IntervalRange(),
              const SizedBox(height: 30),
              RampCurvePreview(),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: VideoShots(),
              ),
              const SizedBox(height: 40),
            ],
          );
        }),
        CubitBuilder<RampCurveCubit, List<CubitRampingPoint>>(
          builder: (context, state) {
            return SaveAndStartButtons(
              onPressSave: null,
              onPressStart: null,
              saveButton: context.cubit<RampCurveCubit>().wasOpened ? null : SetButton(),
            );
          },
        ),
      ],
    );
  }
}
