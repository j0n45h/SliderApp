import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class BtStateIcon extends StatelessWidget {
  const BtStateIcon();

  Widget build(BuildContext context) {
    return Consumer<ProvideBtState>(
      builder: (context, btStateProvider, child) {
        switch (btStateProvider.bluetoothState) {
          case BluetoothState.on:
            switch (btStateProvider.deviceState) {
              case BluetoothDeviceState.connected:
                return const Icon(
                  Icons.bluetooth_connected,
                  color: MyColors.blue,
                  size: 30,
                );
              case BluetoothDeviceState.disconnected:
                return const Icon(
                  Icons.bluetooth,
                  color: MyColors.blue,
                  size: 30,
                );
              case BluetoothDeviceState.connecting:
                return const Icon(
                  Icons.bluetooth_searching,
                  color: MyColors.blue,
                  size: 30,
                );
              case BluetoothDeviceState.disconnecting:
                return const Icon(
                  Icons.bluetooth_searching,
                  color: Colors.grey,
                  size: 30,
                );
              default:
                print('Bt State: ' + btStateProvider.deviceState.toString());
                return const Icon(
                  Icons.bluetooth,
                  color: Colors.grey,
                  size: 30,
                );
            }
          case BluetoothState.off:
            return const Icon(
              Icons.bluetooth_disabled,
              color: Colors.white,
              size: 30,
            );
          case BluetoothState.turningOn:
            return const Icon(
              Icons.bluetooth_searching,
              color: MyColors.blue,
              size: 30,
            );
          case BluetoothState.turningOff:
            return const Icon(
              Icons.bluetooth_searching,
              color: Colors.white,
              size: 30,
            );
          default:
            return const Icon(
              Icons.bluetooth_disabled,
              color: Colors.grey,
              size: 30,
            );
        }
      },
    );
  }
}
