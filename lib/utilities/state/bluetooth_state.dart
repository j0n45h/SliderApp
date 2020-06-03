import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';

class ProvideBtState with ChangeNotifier {
  static BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  static BluetoothConnection _connection;
  static int _loadingIconState = 0;

  ProvideBtState(){
    setup();
  }

  BluetoothState get getBluetoothState {
    return _bluetoothState;
  }

  BluetoothConnection get getConnection {
    return _connection;
  }

  int get getLoadingIconState {
    return _loadingIconState;
  }

  set setBluetoothState(BluetoothState bState) {
    _bluetoothState = bState;
    notifyListeners();
  }

  set setConnection(BluetoothConnection c) {
    _connection = c;
    notifyListeners();
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

  Future<void> connect(BuildContext context) async {
    _loadingIconState = 1;
    notifyListeners();

    if (!await FlutterBluetoothSerial.instance.isEnabled) {
      bool enabled = await enable();
      if (!enabled) {
        _loadingIconState = 0;
        notifyListeners();
        return;
      }
    }

    print('connecting...');

    String address = await CustomCacheManager.getLastBtDeviceAddress();
    if (address == null) {
      _loadingIconState = 0;
      notifyListeners();
      return; // TODO: add popup dialog to search for new Device
    }
    try { // BT Connection
      print('waiting for device');
      _connection = await BluetoothConnection.toAddress(address).timeout(
          const Duration(seconds: 10));
    }
    on TimeoutException catch (e) {
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

    print('Connected to the device $address');


    _loadingIconState = 0;
    print('connected ${_connection.isConnected} ..........................................................');
    notifyListeners();
  }

  Future<bool> enable() async { // TODO Fix crash on deny
    if (await FlutterBluetoothSerial.instance.isEnabled) return true;
    print('enable!');
    try {
      await FlutterBluetoothSerial.instance.requestEnable();
    } catch (e) {
      print('could not turn on Bluetooth');
      return false;
    }
    if (!await FlutterBluetoothSerial.instance.isEnabled) {
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
    await FlutterBluetoothSerial.instance.requestDisable();

    notifyListeners(); //TODO: check if necessary because .onStateChanged().listen does the same
  }

  static bool _reCallBlocked = false;
  void autoConnectToLastDevice(BuildContext context) async {
    if (_connection != null) return;
    if(!_reCallBlocked) {
      blockReCall();
      connect(context);
    }
  }

  // prevent calling [connect()] on each rebuild
  void blockReCall() async {
    _reCallBlocked = true;
    await Future.delayed(Duration(seconds: 15));
    _reCallBlocked = false;
  }

  void setup(){
    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      _loadingIconState = 0;
      setBluetoothState = state;
      notifyListeners();
    });
    // Listen for further state changes
    FlutterBluetoothSerial.instance
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
    FlutterBluetoothSerial.instance
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