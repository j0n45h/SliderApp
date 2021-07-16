import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';
import 'package:sliderappflutter/utilities/state/running_tl_state.dart';
import 'package:synchronized/synchronized.dart';


class ProvideBtState with ChangeNotifier {
  BluetoothDevice? device;
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;
  StreamSubscription<BluetoothDeviceState>? deviceStateSubscription;
  StreamSubscription<List<int>>? listener;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription<bool>? _isScanningListener;
  bool isScanning = false;
  BluetoothState bluetoothState = BluetoothState.unknown;
  StreamSubscription<BluetoothState>? _bluetoothStateListener;
  final BuildContext internalContext;


  ProvideBtState(this.internalContext) {
    _bluetoothStateListener = FlutterBlue.instance.state.listen((event) {
      bluetoothState = event;
      notifyListeners();
    });
    _isScanningListener = FlutterBlue.instance.isScanning.listen((event) {
      isScanning = event;
      notifyListeners();
    });
    connectToLastDevice();
  }

  int _btStateListeningCounter = 0;


  @override
  void dispose() {
    disconnect(device);
    _isScanningListener?.cancel();
    listener?.cancel();
    _bluetoothStateListener?.cancel();
    deviceStateSubscription?.cancel();
    super.dispose();
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
    await _getBluetoothCharacteristic();
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
    _characteristic = null;
    listener?.cancel();
  }

  final _lockStartListening = new Lock();
  Future<void> statListening() async {
    _characteristic = await _getBluetoothCharacteristic();

    try {
      await _lockStartListening.synchronized(() async {
        await _characteristic?.setNotifyValue(true);
      });
    }
    catch (e) {
      print('Exception while setNotifyValue: $e');
    }

    listener = _characteristic?.value.listen((value) {
      try {
        final runningTl = Provider.of<RunningTlState>(internalContext, listen: false);
        var received = utf8.decode(value);

        runningTl.rawLogAdd = received;
        runningTl.updateValues();
        print(received);

      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> sendToBtDevice(String value) async {
    if (!isConnected)
      return;

    var bluetoothCharacteristic = await _getBluetoothCharacteristic();

    await bluetoothCharacteristic?.write(utf8.encode(value));
  }

  Future<BluetoothCharacteristic?> _getBluetoothCharacteristic() async {
    if (!isConnected)
      return null;
    if (device == null)
      return null;

    List<BluetoothService> services = await device!.discoverServices();
    BluetoothCharacteristic? bluetoothCharacteristic;

    services.forEach((service) {
      if (service.uuid.toString() != '0000ffe0-0000-1000-8000-00805f9b34fb')
        return;

      service.characteristics.forEach((blueChar) async {
        if (blueChar.uuid.toString() == '0000ffe1-0000-1000-8000-00805f9b34fb') {
          bluetoothCharacteristic = blueChar;
          // await bluetoothCharacteristic?.setNotifyValue(true);
        }
      });

    });

    if (bluetoothCharacteristic == null)
      print('characteristics not found');

    _characteristic = bluetoothCharacteristic;
    return bluetoothCharacteristic;
  }


  StreamSubscription<List<ScanResult>>? _scanSubscription;
  Future<void> connectToLastDevice() async {
    if (deviceState == BluetoothDeviceState.connecting)
      return;
    if (isScanning)
      await FlutterBlue.instance.stopScan();

    final flutterBlue = FlutterBlue.instance;

    await disconnect(device);
    await flutterBlue.connectedDevices.then((result) => result.forEach((device) {
      device.disconnect();
    })); // TODO: Test!

    if (!await flutterBlue.isOn) { // if BT is off, wait till it gets turned on
      do {
        await Future.delayed(Duration(seconds: 4));
        _btStateListeningCounter++;
      } while(!await flutterBlue.isOn && _btStateListeningCounter < 500);

      _btStateListeningCounter = 0;

      if (!await flutterBlue.isOn){
        return;
      }
    }
    deviceState = BluetoothDeviceState.disconnected;
    device = null;
    if (isConnected){
      notifyListeners();
      return;
    }

    deviceState = BluetoothDeviceState.connecting;
    notifyListeners();

    // get last device from Cache
    BtDevice? lastDevice = await CustomCacheManager.getLastBtDevice();
    if (lastDevice?.address == null) {
      deviceState = BluetoothDeviceState.disconnected;
      notifyListeners();
      return; // TODO: check if a device with this uuid is available
    }
    var charService = [Guid('0000ffe0-0000-1000-8000-00805f9b34fb')];
    var lastDevices = [Guid.fromMac(lastDevice!.address!)];
    await FlutterBlue.instance.stopScan();
    FlutterBlue.instance.startScan(
      timeout: Duration(seconds: 15),
      scanMode: ScanMode.lowLatency,
      withServices: charService,
      // withDevices: lastDevices,
    ).then((value) async {
      if (!isConnected) {
        await FlutterBlue.instance.stopScan();
        FlutterBlue.instance.startScan(
          timeout: Duration(minutes: 3),
          scanMode: ScanMode.lowPower,
          withServices: charService,
          // withDevices: lastDevices,
        ).then((value) async {
          if (!isConnected) {
            await FlutterBlue.instance.stopScan();
            FlutterBlue.instance.startScan(
              timeout: Duration(minutes: 10),
              scanMode: ScanMode.lowPower,
              withServices: charService,
              // withDevices: lastDevices,
            );
          }
        });
      }
    });

    _scanSubscription = flutterBlue.scanResults.listen((result) { // scan for devices
      if (result.length < 1)
        return;

      connect(result.first.device);
      _scanSubscription?.cancel();
      FlutterBlue.instance.stopScan();
    });
    await _getBluetoothCharacteristic();
    statListening();
  }

  Future<void> startScanning({int timeout = 10}) async {
    await FlutterBlue.instance.stopScan();
    FlutterBlue.instance.startScan(
      timeout: Duration(seconds: timeout),
      withServices: [Guid('0000ffe0-0000-1000-8000-00805f9b34fb')],
    );
  }

}



class BtDevice {
  String? name;
  String? address;
  BtDevice({@required this.name, @required this.address});
}
