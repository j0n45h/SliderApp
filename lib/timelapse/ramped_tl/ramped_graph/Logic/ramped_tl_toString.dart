import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cubit/flutter_cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/time_state.dart';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';


class RampedTlToString {
  RampedTlToString();

  send(BuildContext context, bool direction){
    String parameters = '{';
    final List<Points> points = context.cubit<RampCurveCubit>().getPointsAsShots(context);

    int i = 0;
    points.forEach((point) {
      parameters += 'TLPoint:$i,${point.interval},${point.start},${point.end};';
      i++;
    });


    parameters += 'dir:${direction ? '1': '0'};';

    int startIn = context.read<TimeState>().startIn.inSeconds;
    parameters += 'TLStartIn:$startIn;}';

    print(parameters);

    final provideBtState = Provider.of<ProvideBtState>(context, listen: false);
    provideBtState.sendToBtDevice(parameters);
  }
}