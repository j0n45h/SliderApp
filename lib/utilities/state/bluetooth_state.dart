import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';


class ProvideBtState with ChangeNotifier {
  BluetoothDevice device;
  BluetoothDeviceState deviceState;
  StreamSubscription<BluetoothDeviceState> deviceStateSubscription;
  StreamSubscription<List<int>> listener;
  BluetoothCharacteristic characteristic;

  int _retryCounter = 0;
  int _btStateListeningCounter = 0;

  ProvideBtState() {
    connectToLastDevice();
  }

  bool get isConnected {
    if (deviceState == null || device == null)
      return false;
    return deviceState == BluetoothDeviceState.connected;
  }

  void close() {
    listener?.cancel();
    deviceStateSubscription?.cancel();
  }

  Future<void> connect(BluetoothDevice device) async {
    // if (this.device != null && device == this.device) return;
    try {
      await device.connect();
    } catch(e) {
      if (e.code.toString() == 'already_connected')
        print('already_connected');
      else
        print('Exception on connecting: $e');
    }
    this.device = device;
    CustomCacheManager.storeDevice(BtDevice(name: device.name, address: device.id.toString()));

    deviceStateSubscription = this.device.state.listen((BluetoothDeviceState state) {
      if (state != deviceState) {
        deviceState = state;
        notifyListeners();
      }
    });
    await getBluetoothCharacteristic();
    statListening();
  }

  Future<void> disconnect(BluetoothDevice device) async {
    try {
      await device?.disconnect();
    } catch(e) {
      print('Exception on disconnecting: $e');
    }
    // if (this.device == null || device != this.device) return;
    device = null;
  }

  Future<void> statListening() async {
    characteristic?.value?.listen((value) {
      print('${utf8.decode(value)}');
    });
    await characteristic?.setNotifyValue(true);
  }

  Future<void> sendToBtDevice(String value) async {
    if (!isConnected)
      return;

    var bluetoothCharacteristic = await getBluetoothCharacteristic();

    await bluetoothCharacteristic.write(utf8.encode(value + '\n'));
  }

  Future<BluetoothCharacteristic> getBluetoothCharacteristic() async {
    if (!isConnected) return null;
    List<BluetoothService> services = await device.discoverServices();
    BluetoothCharacteristic bluetoothCharacteristic;

    services.forEach((service) {
      if (service.uuid.toString() != '0000ffe0-0000-1000-8000-00805f9b34fb')
        return;
      List<BluetoothCharacteristic> blueChars = service.characteristics;
      blueChars.forEach((BluetoothCharacteristic blueChar) async {
        if (blueChar.uuid.toString() == '0000ffe1-0000-1000-8000-00805f9b34fb')
          bluetoothCharacteristic = blueChar;
      });

    });
    characteristic = bluetoothCharacteristic;
    return bluetoothCharacteristic;
  }


  Future<void> connectToLastDevice() async {
    final flutterBlue = FlutterBlue.instance;

    if (!await flutterBlue.isOn) { // if BT is off, wait till it gets turned on
      do {
        await Future.delayed(Duration(seconds: 4));
        _btStateListeningCounter++;
      } while(!await flutterBlue.isOn && _btStateListeningCounter < 500);

      _btStateListeningCounter = 0;

      if (!await flutterBlue.isOn)
        return;
    }

    if (isConnected)
      return;

    // get last device from Cache
    final lastDevice = await CustomCacheManager.getLastBtDevice();
    if (lastDevice == null)
      return; // TODO: check if a device with this uuid is available

    flutterBlue.startScan(timeout: Duration(seconds: 8), scanMode: ScanMode.lowPower).then((value) {
      if (isConnected) {
        _retryCounter = 0;
        return;
      }

      if (_retryCounter > 15) return; // retry limit exceeded

      _retryCounter++;
      Timer(Duration(seconds: 3), connectToLastDevice); // wait another 10sec than retry

    });

    StreamSubscription<List<ScanResult>> subscription;
    subscription = flutterBlue.scanResults.listen((result) { // scan for devices
      result.forEach((r) {
        if (r.device.id.toString() == lastDevice.address) { // check if last device is available
          connect(r.device); // connect to it
          subscription?.cancel();
          return;
        }
      });
    });
  }
}



class BtDevice {
  String name;
  String address;
  BtDevice({@required this.name, @required this.address});
}
