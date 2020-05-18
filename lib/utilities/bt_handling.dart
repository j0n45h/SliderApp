import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'file:///C:/Users/jonas/Documents/Slider_Source/App/slider_app_flutter/lib/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';

class BtHandling {

  static Future<BluetoothConnection> connectToDevice(dynamic context) async {
    BluetoothConnection connection;
    if (await FlutterBluetoothSerial.instance.isEnabled) {
      final btState = Provider.of<ProvideBtState>(context, listen: false); // state management
      try {
        String address = await getLastBtDeviceAddress();

        // set Standard pin to 1234
        FlutterBluetoothSerial.instance
            .setPairingRequestHandler((BluetoothPairingRequest request) {
          print("Trying to auto-pair with Pin 1234");
          if (request.pairingVariant == PairingVariant.Pin) {
            return Future.value("1234");
          }
          return null;
        });

        connection = await BluetoothConnection.toAddress(address);

        print('Connected to the device');

        connection.input.listen((Uint8List data) {
          print('Data incoming: ${ascii.decode(data)}');
          connection.output.add(data); // Sending data

          if (ascii.decode(data).contains('!')) {
            connection.finish(); // Closing connection
            print('Disconnecting by local host');
          }
        }).onDone(() {
          btState.changeState();
          print('Disconnected by remote request');
        });
      } catch (exception) {
        print('Cannot connect, exception occured: $exception');
      }
    }
    return connection;
  }


  static Future<String> getLastBtDeviceAddress() async {
    FileInfo cacheFile = await CustomCacheManager().getFileFromCache('btDevideAddress');
    cacheFile.file.openRead();
    return cacheFile.file.readAsStringSync();
  }


}