import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class LinearTlToString {

  static Future<void> send(BuildContext context, bool direction) async {
    String parameters = '{';
    final interval = (TLInterval.interval * 100).round() / 100;
    parameters += 'TLPoint:${interval.toString()},0,${TLShots.shots};';
    parameters += 'dir:${direction ? '1' : '0'};';
    parameters += 'TLStartIn:${StartTime.picked ? StartTime.startIn.inSeconds : '0'};';
    parameters += '}';

    print(parameters);

    final provideBtState = Provider.of<ProvideBtState>(context, listen: false);
    await provideBtState.statListening();
    await provideBtState.sendToBtDevice(parameters);
  }
}