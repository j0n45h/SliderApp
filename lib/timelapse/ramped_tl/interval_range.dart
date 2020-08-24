import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/interval_range_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class IntervalRange extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INTERVAL',
          style: MyTextStyle.normal(fontSize: 12),
        ),
        Consumer<IntervalRangeState>(
          builder: (context, intervalRangeState, child) => RangeSlider(
            onChanged: (newRangeValues) =>
            intervalRangeState.intervalRangeSlider = newRangeValues,
            values: intervalRangeState.intervalRangeSlider,
          ),
        ),
        Consumer<IntervalRangeState>(
          builder: (context, intervalRangeState, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              intWidget(context, intervalRangeState.intervalRange.start, 'MIN'),
              intWidget(context, intervalRangeState.intervalRange.end  , 'MAX'),
            ],
          ),
        ),
      ],
    );
  }

  Widget intWidget(BuildContext context, double interval, String label) {
    return Row(
      children: [
        Text(
          label,
          style: MyTextStyle.normal(fontSize: 10),
        ),
        const SizedBox(width: 10),
        FramedTextField(
          width: 70,
          height: 25,
          textField: Consumer<IntervalRangeState>(
            builder: (context, intervalRangeState, child) => Text(
              interval.round().toString() + ' s',
              style: MyTextStyle.normal(fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}