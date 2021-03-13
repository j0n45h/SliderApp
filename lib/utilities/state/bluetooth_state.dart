import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';


class ProvideBtState with ChangeNotifier {
  BluetoothDevice? device;
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  StreamSubscription<BluetoothDeviceState>? deviceStateSubscription;
  StreamSubscription<List<int>>? listener;
  BluetoothCharacteristic? _characteristic;

  String log = "Test";
  void clearLog() {
    log = "";
    notifyListeners();
  }

  int _retryCounter = 0;
  int _btStateListeningCounter = 0;

  ProvideBtState() {
    connectToLastDevice();
  }

  bool get isConnected {
    if (device == null)
      return false;
    return deviceState == BluetoothDeviceState.connected;
    // TODO: if (device==null && deviceState == BluetoothDeviceState.connected) get device from lastDevice or uuid
  }

  void close() {
    listener?.cancel();
    deviceStateSubscription?.cancel();
  }

  Future<void> connect(BluetoothDevice device) async {
    // if (this.device != null && device == this.device) return;
    deviceState = BluetoothDeviceState.connecting;
    notifyListeners();
    try {
      await device.connect();
    } catch(e) {
      if (e.toString() == 'already_connected')
        print('already_connected');
      else
        print('Exception on connecting: $e');
    }
    this.device = device;
    CustomCacheManager.storeDevice(BtDevice(name: device.name, address: device.id.toString()));

    deviceStateSubscription = this.device?.state.listen((BluetoothDeviceState state) {
      print('BT state changed');
      if (state != deviceState) {
        deviceState = state;
        notifyListeners();
      }
    });
    await getBluetoothCharacteristic();
    statListening();
  }

  Future<void> disconnect(BluetoothDevice? device) async {
    if (device == null) device = this.device;
    try {
      await device?.disconnect();
    } catch(e) {
      print('Exception on disconnecting: $e');
    }
    // if (this.device == null || device != this.device) return;
    device = null;
  }

  Future<void> statListening() async {
    final characteristic = await getBluetoothCharacteristic();
    characteristic?.value?.listen((value) {
      var received = utf8.decode(value);
      log += received;
      notifyListeners();
      print(received);
    });
    await characteristic?.setNotifyValue(true);
  }

  Future<void> sendToBtDevice(String value) async {
    if (!isConnected)
      return;

    var bluetoothCharacteristic = await getBluetoothCharacteristic();

    await bluetoothCharacteristic?.write(utf8.encode(value));
  }

  Future<BluetoothCharacteristic?> getBluetoothCharacteristic() async {
    if (!isConnected) return null;
    if (_characteristic != null)
      return _characteristic;
    if (device == null)
      return null;

    List<BluetoothService> services = await device!.discoverServices();
    BluetoothCharacteristic? bluetoothCharacteristic;

    services.forEach((service) {
      if (service.uuid.toString() != '0000ffe0-0000-1000-8000-00805f9b34fb')
        return;
      List<BluetoothCharacteristic> blueChars = service.characteristics;
      blueChars.forEach((BluetoothCharacteristic blueChar) async {
        if (blueChar.uuid.toString() == '0000ffe1-0000-1000-8000-00805f9b34fb')
          bluetoothCharacteristic = blueChar;
      });

    });

    if (bluetoothCharacteristic == null)
      print('characteristics not found');

    _characteristic = bluetoothCharacteristic;
    return bluetoothCharacteristic;
  }


  Future<void> connectToLastDevice() async {
    final flutterBlue = FlutterBlue.instance;

    await flutterBlue.connectedDevices.then((result) => result.forEach((device) {
      device.disconnect();
    })); // TODO: Test!

    if (!await flutterBlue.isOn) { // if BT is off, wait till it gets turned on
      do {
        await Future.delayed(Duration(seconds: 4));
        _btStateListeningCounter++;
      } while(!await flutterBlue.isOn && _btStateListeningCounter < 500);

      _btStateListeningCounter = 0;

      if (!await flutterBlue.isOn)
        return;
    }
    deviceState = BluetoothDeviceState.disconnected;
    device = null;
    if (isConnected)
      return;

    deviceState = BluetoothDeviceState.connecting;
    notifyListeners();

    // get last device from Cache
    final lastDevice = await CustomCacheManager.getLastBtDevice();
    if (lastDevice == null) {
      deviceState = BluetoothDeviceState.disconnected;
      notifyListeners();
      return; // TODO: check if a device with this uuid is available
    }

    await FlutterBlue.instance.stopScan();

      flutterBlue.startScan(
        timeout: Duration(seconds: 8),
        scanMode: ScanMode.lowPower,
        withDevices: [Guid.fromMac(lastDevice.address)]).then((value) {
      if (isConnected) {
        _retryCounter = 0;
        return;
      }

      if (_retryCounter > 15) return; // retry limit exceeded

      _retryCounter++;
      Timer(Duration(seconds: 3), connectToLastDevice); // wait another 10sec than retry

    });

    StreamSubscription<List<ScanResult>>? subscription;
    subscription = flutterBlue.scanResults.listen((result) { // scan for devices
      connect(result.first.device);
      subscription?.cancel();
    });
    await getBluetoothCharacteristic();
    statListening();
  }
}



class BtDevice {
  String? name;
  String? address;
  BtDevice({@required this.name, @required this.address});
}
