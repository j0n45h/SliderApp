import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class BtStateIcon extends StatelessWidget {
  final ProvideBtState _btStateProvider;

  BtStateIcon(this._btStateProvider);

  Widget build(BuildContext context) {
    if (!_btStateProvider.getBluetoothState.isEnabled) {
      return const Icon(
        Icons.bluetooth_disabled,
        color: Colors.white,
        size: 30,
      );
    } else if (_btStateProvider.getLoadingIconState == 1) {
      return const Icon(
        Icons.bluetooth_searching,
        color: MyColors.blue,
        size: 30,
      );
    } else if (_btStateProvider.getLoadingIconState == -1) {
      return const Icon(Icons.bluetooth_searching,
        color: MyColors.blue,
        size: 30,
      );
    } else if (!_btStateProvider.isConnected) {
      return const Icon(
        Icons.bluetooth,
        color: MyColors.blue,
        size: 30,
      );
    } else {
      return const Icon(
        Icons.bluetooth_connected,
        color: MyColors.blue,
        size: 30,
      );
    }
  }
}