import 'package:flutter/material.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/clickable_framed_text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';
import 'package:sliderappflutter/utilities/timepicker.dart';

class StartEndDuration extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        start(context),
        end(context),
        // duration(context),
      ],
    );
  }

  Widget start(BuildContext context) {
    return Row(
      children: [
        Text(
          'START',
          style: MyTextStyle.normal(fontSize: 12, letterSpacing: 1.3),
        ),
        const SizedBox(width: 10),
        Consumer<TimeState>(
          builder: (context, timeState, _) => ClickableFramedTimeField(
            time: timeState.startingTime,
            onTap: () => _showStartTimePicker(timeState, context),
          ),
        ),
      ],
    );
  }

  Future<void> _showStartTimePicker
      (TimeState timeState, BuildContext context) async {
    final timePicker = TimePicker(
      context: context,
      hintPickedNextDay: true,
      initialTime: TimeOfDay.fromDateTime(timeState.startingTime) ?? null,
    );

    final pickedTime = await timePicker.show();

    if (pickedTime == null) return;

    timeState.startingTime = pickedTime;
    context.cubit<RampCurveCubit>().updatePoints(context);
  }

  Widget end(BuildContext context) {
    return Row(
      children: [
        Text(
          'END',
          style: MyTextStyle.normal(fontSize: 12, letterSpacing: 1.3),
        ),
        const SizedBox(width: 10),
        Consumer<TimeState>(
          builder: (context, rampedTLState, _) => ClickableFramedTimeField(
            time: rampedTLState.endingTime,
            onTap: () => _showEndTimePicker(rampedTLState, context),
          ),
        ),
      ],
    );
  }

  Future<void> _showEndTimePicker
      (TimeState timeState, BuildContext context) async {
    print(timeState.endingTime == null);
    final timePicker = TimePicker(
      context: context,
      hintPickedNextDay: true,
      initialTime: timeState.endingTime != null
          ? TimeOfDay.fromDateTime(timeState.endingTime)
          : null,
      helpText: 'The Time you want the Timelapse to End',
    );

    final pickedTime = await timePicker.show();

    if (pickedTime == null) return;

    timeState.endingTime = pickedTime;
    context.cubit<RampCurveCubit>().updatePoints(context);
  }

  Widget duration(BuildContext context) {
    return Row(
      children: [],
    );
  }
}
