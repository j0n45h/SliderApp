import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/running_tl_state.dart';

import 'cubit.dart';


class RampedTlToString {
  RampedTlToString();

  send(BuildContext context, bool direction) async {
    String parameters = '{';
    final List<Points> points = context.read<RampCurveCubit>().getPointsAsShots(context);

    points.forEach((point) {
      double interval = ((point.interval ?? 1) * 100).round() / 100;
      parameters += 'TLPoint:${interval.toString()},${point.start},${point.end};';
    });


    parameters += 'dir:${direction ? '1': '0'};';

    int startIn = context.read<TimeState>().startIn.inSeconds;
    parameters += 'TLStartIn:$startIn;}';

    print(parameters);

    var first = parameters.substring(0, (parameters.length/2).round());
    var second = parameters.substring((parameters.length/2).round());

    final runningTlState = Provider.of<RunningTlState>(context, listen: false);
    runningTlState.resetAll();

    final provideBtState = Provider.of<ProvideBtState>(context, listen: false);
    await provideBtState.statListening();
    await provideBtState.sendToBtDevice(first);
    Future.delayed(const Duration(milliseconds: 400), () => provideBtState.sendToBtDevice(second));
  }
}
