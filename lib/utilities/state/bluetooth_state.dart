import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue/flutter_blue.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';


class ProvideBtState with ChangeNotifier {
  bool _connected = false;

  set connected(bool c) {
    _connected = c;
    notifyListeners();
  }

  bool get isConnected {
    return _connected;
  }
}

/*

class ProvideBtState with ChangeNotifier {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  static BluetoothState _bluetoothState = BluetoothState.unknown;
  BluetoothDevice device;
  static BluetoothConnection _connection;
  static int _loadingIconState = 0;

  static BtDevice _connectedBtDevice;


  ProvideBtState(){
    setup();
  }

  BluetoothState get getBluetoothState {
    return _bluetoothState;
  }

  BluetoothConnection get getConnection {
    return _connection;
  }

  /// -1 on disconnect | 1 on connect | else 0
  int get getLoadingIconState {
    return _loadingIconState;
  }

  BtDevice get connectedBtDevice {
    return _connectedBtDevice;
  }

  set setBluetoothState(BluetoothState bState) {
    _bluetoothState = bState;
    notifyListeners();
  }

  set setConnection(BluetoothConnection c) {
    _connection = c;
    notifyListeners();
  }

  bool get isConnected {
    if (_connection == null) return false;
    return _connection.isConnected;
  }

  bool isConnectedTo(BtDevice btDevice) {
    if (!isConnected) return false;
    return btDevice.address == _connectedBtDevice.address;
  }

  void resetLoadingIconState() {
    _loadingIconState = 0;
  }

  Future<void> disconnect() async {
    _loadingIconState = -1;
    notifyListeners();
    if(_connection != null) {
      await _connection.finish();
      _connection = null;
    }
    _loadingIconState = 0;
    notifyListeners();
  }

  Future<void> connect({BtDevice btDeviceToConnectTo}) async {
    if (!await FlutterBlue.instance.isAvailable)
      return;

    _loadingIconState = 1;
    notifyListeners();

    if (_connection != null) {
      await disconnect();
    }

    if (!await FlutterBlue.instance.isOn) {
      bool enabled = await enable();
      if (!enabled) {
        _loadingIconState = 0;
        notifyListeners();
        return;
      }
    }

    print('connecting...');

    /// figure out which address to connect to
    if (btDeviceToConnectTo == null) {
      btDeviceToConnectTo = await CustomCacheManager.getLastBtDevice();

      if (btDeviceToConnectTo == null) {
        _loadingIconState = 0;
        notifyListeners();
        return; // TODO: add popup dialog to search for new Device
      }
    } else {
      CustomCacheManager.storeDevice(btDeviceToConnectTo);
    }

    try { /// Bluetooth Connection
      print('waiting for device');
      _connection = await BluetoothConnection.toAddress(btDeviceToConnectTo.address).timeout(
          const Duration(seconds: 15));
      _connectedBtDevice = btDeviceToConnectTo;
    }
    on TimeoutException catch (_) {
      print('connection time out');
      _loadingIconState = 0;
      notifyListeners();
      return null;
    }
    on Error catch (e) {
      print(e);
      _loadingIconState = 0;
      notifyListeners();
      return null;
    }

    listenToConnectedDevice();

    print('Connected to the device $btDeviceToConnectTo.address');


    _loadingIconState = 0;
    print('connected ${_connection.isConnected} ..........................................................');
    notifyListeners();
  }

  Future<bool> enable() async { // TODO Fix crash on deny
    if (!await FlutterBlue.instance.isAvailable)
      return false;

    if (await FlutterBlue.instance.isOn) return true;
    print('enable!');
    try {
      await FlutterBluetoothSerial.instance.requestEnable();
    } catch (e) {
      print('could not turn on Bluetooth');
      return false;
    }
    if (!await FlutterBlue.instance.isOn) {
      print('failed to enable Bluetooth');
      return false;
    }
    print('enabled');
    print(_bluetoothState.isEnabled);
    notifyListeners();
    return true;
  }

  Future<void> disable() async {
    if (_connection != null && _connection.isConnected) await disconnect();
    await flutterBlue.instance.requestDisable();

    notifyListeners(); //TODO: check if necessary because .onStateChanged().listen does the same
  }

  static bool _reCallBlocked = false;
  void autoConnectToLastDevice() async {
    if (_connection != null) return;
    if(_reCallBlocked) return;
    blockReCall();
    connect();
  }

  /// prevent calling [autoConnectToLastDevice] on each rebuild
  void blockReCall() async {
    _reCallBlocked = true;
    await Future.delayed(Duration(seconds: 15));
    _reCallBlocked = false;
  }

  void setup() async {
    if (!await FlutterBlue.instance.isAvailable)
      return;

    // Get current state
    FlutterBlue.instance.state.then((state) {
      _loadingIconState = 0;
      setBluetoothState = state;
      notifyListeners();
    });
    // Listen for further state changes
    FlutterBlue.instance
        .onStateChanged()
        .listen((BluetoothState state) {
          _loadingIconState = 0;
          setBluetoothState = state;
          if (!_bluetoothState.isEnabled){
            disconnect();
          }
          notifyListeners();
    });

    // set Standard pin to 1234
    FlutterBlue.instance
        .setPairingRequestHandler((BluetoothPairingRequest request) {
      print("Trying to auto-pair with Pin 1234");
      if (request.pairingVariant == PairingVariant.Pin) {
        return Future.value("1234");
      }
      return null;
    });
  }

  void changeState() {
    notifyListeners();
  }

  void listenToConnectedDevice() {
    _connection.input.listen((Uint8List data) {
      print('Data incoming: ${ascii.decode(data)}');
      _connection.output.add(data); // Sending data

      if (ascii.decode(data).contains('!')) {
        disconnect();
        print('Disconnecting by local host');
      }
    }).onDone(() {
      disconnect();
      print('Disconnected by remote request');
    });
  }
}

*/
class BtDevice {
  String name;
  String address;
  BtDevice({@required this.name, @required this.address});
}
