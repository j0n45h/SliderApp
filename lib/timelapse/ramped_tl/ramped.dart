import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/interval_range.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/start_end_duration.dart';
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
        ListView(
          padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
          children: [
            StartEndDuration(),
            const SizedBox(height: 30),
            RampingPoints(),
            const SizedBox(height: 30),
            IntervalRange(),
            const SizedBox(height: 30),
            Container(
              height: 140,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.5,
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
        SaveAndStartButtons(
          onPressSave: null,
          onPressStart: null,
        ),
      ],
    );
  }
}
