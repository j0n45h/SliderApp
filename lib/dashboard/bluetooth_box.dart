import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/popUp.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';

class BluetoothBox extends StatelessWidget {

  String btStatus(ProvideBtState btStateProvider) {
    if (btStateProvider.getConnection != null && btStateProvider.getConnection.isConnected){
      return 'CONNECTED';
    } else {
      return 'NOT\nCONNECTED';
    }
  }

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 0, 15, 0),
      child: Consumer<ProvideBtState>(
        builder: (context, btStateBuilder, _) => InkWell(
          onLongPress: () => _inkWellLongPress(context, btStateBuilder),
          onTap: () => _inkWellTap(context, btStateBuilder),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container( // Bluetooth icon
                padding: EdgeInsets.all(14),
                // padding: const EdgeInsets.all(14),
                child: BtStateIcon(btStateBuilder),
                // child: btIcon(context, btStateBuilder, btStateBuilder),
              ),
              Text( // Bluetooth text
                btStatus(btStateBuilder),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: MyColors.font,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w200,
                  letterSpacing: 2,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _didBuild = false;
  void onBuild(dynamic context) {
    if (_didBuild) return;
    Timer.run(() {
      final btStateProvider = Provider.of<ProvideBtState>(context, listen: false);
      btStateProvider.autoConnectToLastDevice(); // auto connect BT
    });
    _didBuild = true;
  }

  _inkWellLongPress(final BuildContext context, final ProvideBtState btStateProvider) {
    if (!btStateProvider.getBluetoothState.isEnabled) return;
    SearchingDialog().showMyDialog(context);
  }

  _inkWellTap(final BuildContext context, final ProvideBtState btStateProvider) {
    if (!btStateProvider.getBluetoothState.isEnabled) {
      btStateProvider.connect();
    } else if (!btStateProvider.isConnected) {
      btStateProvider.disable();
    } else {
      btStateProvider.disconnect();
    }
  }
}
