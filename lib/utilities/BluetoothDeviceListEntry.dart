import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    @required BluetoothDevice device,
    GestureTapCallback onTap,
    GestureLongPressCallback onLongPress,
    bool enabled = true,
    Widget trailing,
  }) : super(
          onTap: onTap,
          onLongPress: onLongPress,
          enabled: enabled,
          title: Text(device.name.length > 0 ? device.name : "Unknown device", style: MyTextStyle.normalStdSize()),
          subtitle: Text(
            device.id.toString(),
            style: MyTextStyle.normalStdSize(),
          ),
          trailing: trailing,
        );
}
