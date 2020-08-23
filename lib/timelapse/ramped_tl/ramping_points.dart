import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampingPoints extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RAMPING POINTS',
          style: MyTextStyle.normal(fontSize: 12),
        ),
        Consumer<RampingPointsState>(
          builder: (context, rampingPointsState, child) => Slider(
            onChanged: (value) {
              rampingPointsState.rampingPoints = value.floor();
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
}
