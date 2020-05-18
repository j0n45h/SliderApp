import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliderappflutter/utilities/bt_handling.dart';

class ProvideBtState with ChangeNotifier {
  static BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  static BluetoothConnection _connection;
  static int _loadingIconState = 0;

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

  void disconnect() {
    future() async {
      _loadingIconState = -1;
      notifyListeners();
      await _connection.finish();
      _connection = null;
    }

    future().then((_) {
      _loadingIconState = 0;
      notifyListeners();
    });
  }

  void connect(dynamic context) {
    future() async {
      HapticFeedback.mediumImpact();
      _loadingIconState = 1;
      notifyListeners();
      _connection = await BtHandling.connectToDevice(context);
    }

    future().then((_) {
      _loadingIconState = 0;
      notifyListeners();
    });
  }

  void enable() {
    future() async {
      await FlutterBluetoothSerial.instance.requestEnable();
    }

    future().then((_) {
      notifyListeners();
    });
  }

  void disable() {
    future() async {
      await FlutterBluetoothSerial.instance.requestDisable();
    }

    future().then((_) {
      notifyListeners();
    });
  }

  void autoConnectToLastDevice(dynamic context) async {
    if (!_bluetoothState.isEnabled) {
      await FlutterBluetoothSerial.instance.requestEnable();
      notifyListeners();
    }

    if (_connection == null) {
      connect(context);
    }
    // print('connestion Status: ${_connection.isConnected.toString()}-------------------------------------------------------');
  }

  void changeState() {
    notifyListeners();
  }
}
