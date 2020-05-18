import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class BluetoothBox extends StatelessWidget {

  Widget btIcon(dynamic context, ProvideBtState btStateProvider, ProvideBtState btStateBuilder){
    if (btStateBuilder.getConnection != null && btStateBuilder.getConnection.isConnected) {
      return InkWell(
        enableFeedback: true,
        child: const Icon(
          Icons.bluetooth_connected,
          color: MyColors.blue,
          size: 30,
        ),
        onTap: () => btStateProvider.disconnect(),
        onLongPress: () => btStateProvider.disconnect(),
      );
    } else if (btStateBuilder.getLoadingIconState == 1) {
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
        onLongPress: () => btStateProvider.connect(context),
      );
    } else {
      return InkWell(
        enableFeedback: true,
        child: Icon(
          Icons.bluetooth_disabled,
          color: Colors.grey[200],
          size: 30,
        ),
        onTap: () => btStateProvider.enable(),
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

  @override
  Widget build(BuildContext context) {
    final btStateProvider = Provider.of<ProvideBtState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Consumer<ProvideBtState>(
        builder: (context, btStateBuilder, _) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container( // Bluetooth icon
              padding: const EdgeInsets.all(14),
              child: btIcon(context, btStateProvider, btStateBuilder),
            ),
            Text( // Bluetooth text
              btStatus(btStateProvider),
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
}
