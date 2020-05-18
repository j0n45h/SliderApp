import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


import 'package:sliderappflutter/dashboard/dashboard.dart';

import 'package:sliderappflutter/utilities/colors.dart';
import 'drawer.dart';
import 'package:sliderappflutter/utilities/BluetoothDeviceListEntry.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';

class ConnectionScreen extends StatefulWidget {
  static const routeName = '/connection-screen';

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  String btDeviceAddress;
  bool isDiscovering;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();


  @override
  void initState() {
    super.initState();
    results.clear();
    isDiscovering = true;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _startDiscovery() async {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            results.add(r);
          });
        });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });


  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    //_streamSubscription?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Discovery Page: ${isDiscovering.toString()}');
    print('Devides found: ${results.length}');
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.AppBar,
          elevation: 1,
          title: const Text(
            'Connection',
            style: TextStyle(
              fontFamily: 'Bellezza',
              letterSpacing: 5,
            ),
          ),
          centerTitle: true,
          actions: <Widget>[
            isDiscovering
                ? Transform.scale(
                    scale: 0.7,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 10, 40, 10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.grey[200]),
                      ),
                    ))
                : IconButton(
              icon: Icon(Icons.replay),
              onPressed: _restartDiscovery,
            ),
          ],
        ),
        drawer: MyDrawer(),

        body: ListView.builder(
          itemCount: results.length,
          itemBuilder: (BuildContext context, index) {
            BluetoothDiscoveryResult result = results[index];
            return BluetoothDeviceListEntry(
              device: result.device,
              rssi: result.rssi,
              onTap: () async{
                var file = await CustomCacheManager().putFile('btDevideAddress', Uint8List.fromList(result.device.address.toString().codeUnits), fileExtension: 'txt');
                file.openRead();
                print(file.readAsBytes());
                // Navigator.of(context).pop(result.device);
              },
              onLongPress: () async {
                try {
                  bool bonded = false;
                  if (result.device.isBonded) {
                    print('Unbonding from ${result.device.address}...');
                    await FlutterBluetoothSerial.instance
                        .removeDeviceBondWithAddress(result.device.address);
                    print('Unbonding from ${result.device.address} has succed');
                  } else {
                    print('Bonding with ${result.device.address}...');
                    bonded = await FlutterBluetoothSerial.instance
                        .bondDeviceAtAddress(result.device.address);
                    print(
                        'Bonding with ${result.device.address} has ${bonded ? 'succed' : 'failed'}.');
                  }
                  setState(() {
                    results[results.indexOf(result)] = BluetoothDiscoveryResult(
                        device: BluetoothDevice(
                          name: result.device.name ?? '',
                          address: result.device.address,
                          type: result.device.type,
                          bondState: bonded
                              ? BluetoothBondState.bonded
                              : BluetoothBondState.none,
                        ),
                        rssi: result.rssi);
                  });
                } catch (ex) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error occured while bonding'),
                        content: Text("${ex.toString()}"),
                        actions: <Widget>[
                          new FlatButton(
                            child: new Text("Close"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            );
          },
        ),
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return;
      },
    );
  }
}
