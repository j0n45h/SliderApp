import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as bls;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';

import '../drawer.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings-screen';

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TextEditingController _controller = TextEditingController();

  // bool isConnected = false;

  void initState() {
    super.initState();

    // Get current state
    bls.FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // Listen for further state changes
    bls.FlutterBluetoothSerial.instance.onStateChanged().listen((bls.BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    // set Standard pin to 1234
    bls.FlutterBluetoothSerial.instance.setPairingRequestHandler((bls.BluetoothPairingRequest request) {
      print("Trying to auto-pair with Pin 1234");
      if (request.pairingVariant == bls.PairingVariant.Pin) {
        return Future.value("1234");
      }
      return null;
    });
  }

  void dispose() {
    _controller.dispose();
    bls.FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    super.dispose();
  }

  void sendString(String string) {}

  @override
  Widget build(BuildContext context) {
    final provideBtState = Provider.of<ProvideBtState>(context, listen: false);
    return WillPopScope(
      child: Scaffold(
        // backgroundColor: Color(0xff242F33),
        appBar: AppBar(
          elevation: 1.0,
          title: Text(
            'Settings',
            style: TextStyle(
              fontFamily: 'Bellezza',
              letterSpacing: 5,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            BtStateIcon(),
            SizedBox(width: 15),
          ],
          backgroundColor: MyColors.AppBar,
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            children: [
              FutureBuilder<BluetoothCharacteristic?>(
                future: provideBtState.getBluetoothCharacteristic(),
                builder: (context, future) {
                  if (!future.hasData) return Container();

                  return StreamBuilder<List<int>>(
                    stream: future.data?.value,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Container();

                      return Text(utf8.decode(snapshot.data ?? []));
                    },
                  );
                },
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: this._controller,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Send this data to Slider',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (String value) async {
                    await showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: MyColors.popup,
                          title: const Text('Send this String:'),
                          content: Text(value),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            FlatButton(
                              onPressed: () {
                                provideBtState.sendToBtDevice(value);
                                Navigator.pop(context);
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return Future.value(true);
      },
    );
  }

  bls.BluetoothState _bluetoothState = bls.BluetoothState.UNKNOWN;
  bls.BluetoothConnection? connection;

  Future<String> getLastBtDeviceAddress() async {
    FileInfo cacheFile = await CustomCacheManager.getFileFromCache('btDevideAddress');
    cacheFile.file.openRead();
    return cacheFile.file.readAsStringSync();
  }

  Future<void> connectToDevice() async {
    if (_bluetoothState.isEnabled) {
      try {
        String address = await getLastBtDeviceAddress();

        // set Standard pin to 1234
        bls.FlutterBluetoothSerial.instance.setPairingRequestHandler((bls.BluetoothPairingRequest request) {
          print("Trying to auto-pair with Pin 1234");
          if (request.pairingVariant == bls.PairingVariant.Pin) {
            return Future.value("1234");
          }
          return null;
        });

        connection = await bls.BluetoothConnection.toAddress(address);
        if (connection == null){
          print('Connecting failed!');
          return;
        }
        print('Connected to the device');

        connection?.input?.listen((Uint8List data) {
          print('Data incoming: ${ascii.decode(data)}');
          connection?.output?.add(data); // Sending data

          if (ascii.decode(data).contains('!')) {
            connection?.finish(); // Closing connection
            print('Disconnecting by local host');
          }
        }).onDone(() {
          setState(() {});
          print('Disconnected by remote request');
        });
      } catch (exception) {
        print('Cannot connect, exception occured: $exception');
      }
    }
  }

  Widget btTaskBarIcon() {
    bool connected = connection?.isConnected ?? false;
    if (connected) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
        child: IconButton(
          icon: Icon(
            Icons.bluetooth_connected,
            color: MyColors.blue,
          ),
          onPressed: () {
            /// Disconnect
            future() async {
              await connection?.finish();
            }

            future().then((_) {
              setState(() {});
            });
          },
        ),
      );
    } else if (_bluetoothState.isEnabled) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 42, 0),
        child: InkWell(
          child: Icon(
            Icons.bluetooth,
            color: MyColors.blue,
          ),
          onTap: () {
            /// BT off
            future() async {
              await bls.FlutterBluetoothSerial.instance.requestDisable();
            }

            future().then((_) {
              setState(() {});
            });
          },
          onLongPress: () {
            /// connect
            future() async {
              await connectToDevice();
            }

            future().then((_) {
              setState(() {});
            });
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
        child: IconButton(
          icon: Icon(
            Icons.bluetooth_disabled,
            color: Colors.grey[200],
          ),
          onPressed: () {
            /// BT on
            future() async {
              await bls.FlutterBluetoothSerial.instance.requestEnable();
            }

            future().then((_) {
              setState(() {});
            });
          },
        ),
      );
    }
  }
}
