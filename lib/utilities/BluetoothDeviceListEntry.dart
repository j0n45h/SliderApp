import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliderappflutter/utilities/text_style.dart';


class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    @required BluetoothDevice device,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
    bool enabled = true,
  }) : super(
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
//          leading:
//              Icon(Icons.devices, color: Colors.white,), // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name ?? "Unknown device", style: MyTextStyle.normalStdSize(),),
          subtitle: Text(device.address.toString(), style: MyTextStyle.normalStdSize(),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              device.isConnected
                  ? Icon(Icons.import_export, color: Colors.white,)
                  : Container(width: 0, height: 0),
              device.isBonded
                  ? Icon(Icons.link, color: Colors.white,)
                  : Container(width: 0, height: 0),
            ],
          ),
        );
}
