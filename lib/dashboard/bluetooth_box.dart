import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/popup/new_popup/popUp.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class BluetoothBox extends StatelessWidget {

  Widget btIcon(BuildContext context, ProvideBtState btStateProvider, ProvideBtState btStateBuilder){
  if (btStateBuilder.getConnection != null && btStateBuilder.getConnection.isConnected) {
      return InkWell(
        enableFeedback: true,
        child: const Icon(
          Icons.bluetooth_connected,
          color: MyColors.blue,
          size: 30,
        ),
        onTap: () => btStateProvider.disconnect(),
        onLongPress: () => SearchingDialog().showMyDialog(context),
      );
    } else if (btStateBuilder.getLoadingIconState == 1 && btStateBuilder.getBluetoothState.isEnabled) {
      return const Icon(
        Icons.bluetooth_searching,
        color: MyColors.blue,
        size: 30,
      );
    } else if (btStateBuilder.getLoadingIconState == -1) {
      return const Icon(
        Icons.bluetooth_searching,
        color: MyColors.red,
        size: 30,
      );
    } else if (btStateBuilder.getBluetoothState.isEnabled) {
      return InkWell(
        enableFeedback: true,
        child: const Icon(
          Icons.bluetooth,
          color: MyColors.blue,
          size: 30,
        ),
        onTap: () => btStateProvider.disable(),
        // onLongPress: () => btStateProvider.connect(context),
        onLongPress: () => SearchingDialog().showMyDialog(context),
      );
    } else {
      return InkWell(
        enableFeedback: true,
        child: Icon(
          Icons.bluetooth_disabled,
          color: Colors.grey[200],
          size: 30,
        ),
        onTap: () => btStateProvider.connect(),
      );
    }
  }

  String btStatus(ProvideBtState btStateProvider) {
    if (btStateProvider.getConnection != null && btStateProvider.getConnection.isConnected){
      return 'CONNECTED';
    } else {
      return 'NOT\nCONNECTED';
    }
  }
/*
  Widget buildB(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Consumer<ProvideBtState>(

      ),
    );
  }
*/
  @override
  Widget build(BuildContext context) {
    // final btStateProvider = Provider.of<ProvideBtState>(context);
    onBuild(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 0, 15, 0),
      child: Consumer<ProvideBtState>(
        builder: (context, btStateBuilder, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container( // Bluetooth icon
              padding: EdgeInsets.all(14),
              // padding: const EdgeInsets.all(14),
              child: btIcon(context, btStateBuilder, btStateBuilder),
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
}
