import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class BtStateIcon extends StatelessWidget {
  const BtStateIcon();

  Widget build(BuildContext context) {
    return Consumer<ProvideBtState>(
      builder: (context, provideBtState, child) {
        if (provideBtState.isConnected)
          return const Icon(
            Icons.bluetooth_connected,
            color: MyColors.blue,
            size: 30,
          );
        else
          return StreamBuilder<BluetoothState>(
            stream: FlutterBlue.instance.state,
            initialData: BluetoothState.on,
            builder: (context, snapshot) {
              final state = snapshot.data;
              switch (state) {
                case BluetoothState.on:
                  return const Icon(
                    Icons.bluetooth,
                    color: MyColors.blue,
                    size: 30,
                  );
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
      },
    );
  }
}
