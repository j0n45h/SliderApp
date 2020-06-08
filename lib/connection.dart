import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliderappflutter/dashboard/bluetooth_box.dart';
import 'package:sliderappflutter/utilities/BluetoothDeviceListEntry.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/custom_cache_manager.dart';
import 'package:sliderappflutter/utilities/popup/popup.dart';
import 'package:sliderappflutter/utilities/popup/popup_content.dart';

import 'drawer.dart';

class ConnectionScreen extends StatefulWidget {
  static const routeName = '/connection-screen';

  /// POP UP
  showPopup(BuildContext context, {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 90,
        left: 35,
        right: 35,
        bottom: 80,
        child: PopupContent(
          content: ConnectionScreen(),
        ),
      ),
    );
  }

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
    print('Devices found: ${results.length}');
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: new Builder(builder: (context) {
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                try {
                  Navigator.pop(context); //close the popup
                } catch (e) {}
              },
            );
          }),
          backgroundColor: MyColors.AppBar,
          elevation: 1,
          title: const Text(
            'Searching for Devices',
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
              onTap: () {
                CustomCacheManager.storeDeviceAddress(result.device.address.toString());
                print('getting Devices address');
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
