import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bts;
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/bluetooth_pop_up.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';

class BluetoothBox extends StatelessWidget {
  String btStatus(ProvideBtState btState) {
    if (btState.isConnected) {
      return 'CONNECTED';
    } else {
      return 'NOT\nCONNECTED';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 0, 5, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onLongPress: () => _inkWellLongPress(context),
        onTap: () => _inkWellTap(context),
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                // Bluetooth icon
                padding: const EdgeInsets.all(14),
                child: const BtStateIcon(),
              ),
              Consumer<ProvideBtState>(builder: (context, btState, child) {
                return Text(
                  // Bluetooth text
                  btStatus(btState),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MyColors.font,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w200,
                    letterSpacing: 2,
                    fontSize: 14,
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _inkWellLongPress(BuildContext context) async {
    if (!await FlutterBlue.instance.isOn) return;
    SearchingDialog().showMyDialog(context);
  }

  Future<void> _inkWellTap(BuildContext context) async {
    if (!await FlutterBlue.instance.isAvailable)
      return;

    final btState = Provider.of<ProvideBtState>(context, listen: false);

    if (!await FlutterBlue.instance.isOn) {
      try {
        //await bts.FlutterBluetoothSerial.instance.requestEnable();
        //btState.connectToLastDevice();
      } catch (e) {
        print('could not turn on and connect Bluetooth');
      }
    } else if (btState.isConnected) {
      btState.disconnect(null);
    } else { // on but not connected
      btState.connectToLastDevice();
    }
  }
}
