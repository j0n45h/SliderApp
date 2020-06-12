import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/BluetoothDeviceListEntry.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class SearchingDialog extends StatefulWidget {
  Future<void> showMyDialog(BuildContext context) async {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, anim1, anim2) {},
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.4),
      barrierLabel: '',
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: SearchingDialog(),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  @override
  _SearchingDialogState createState() => _SearchingDialogState();
}

class _SearchingDialogState extends State<SearchingDialog>
    with SingleTickerProviderStateMixin {
  Animation _animation;
  AnimationController _animationController;
  bool _isDiscovering;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 24.0,
      backgroundColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 450,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.popup.withOpacity(0.2),
                    // color: MyColors.bg.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0011)
                      ..rotateY(2 * pi * _animation.value),
                    alignment: FractionalOffset.center,
                    child: Icon(
                      Icons.bluetooth,
                      size: 30,
                      color: _animation.value > 0.25 && _animation.value < 0.75
                          ? Colors.blue
                          : Colors.white,
                      // color: Color.lerp(Colors.blue, Colors.white, sin(_animation.value * 2 * pi + pi/2) * 0.5 + 0.5),
                    ),
                  ),
                ),
                Text(
                  'Discovered Devices:',
                  style: MyTextStyle.normal(fontSize: 18.0),
                ),
                Divider(
                  color: Colors.deepOrange.withOpacity(0.6),
                  height: 30,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Container(
                  height: 125,
                ),
                Divider(
                  color: Colors.black38.withOpacity(0.5),
                  height: 1,
                  thickness: 1,
                ),
                Container(
                  height: 250,
                  color: Colors.black.withOpacity(0.3),
                  child: listView(),
                ),
                Divider(
                  color: Colors.black38.withOpacity(0.5),
                  height: 1,
                  thickness: 1,
                ),
                Container(
                  height: 73,
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(35.0)),
                    child: MaterialButton(
                      elevation: 24,
                      height: 55,
                      minWidth: 250,
                      child: Text(
                        'Search',
                        style: MyTextStyle.normal(fontSize: 18.0),
                      ),
                      color: MyColors.bg.withOpacity(0.6),
                      onPressed: () => _restartDiscovery(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    results.clear();
    _isDiscovering = true;
    _connectedDeviceAdded = false;
    setupAnimation();
    if (_isDiscovering) {
      _startDiscovery();
    }
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startDiscovery() async {
    _animationController.reset();
    _animationController.forward();
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        for (BluetoothDiscoveryResult i in results) {
          if (i.device.address == r.device.address){
            results.insert(results.indexOf(i), r);
            results.remove(i);
            return;
          }
        }
        results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  void _restartDiscovery() {
    if (_isDiscovering) return;
    setState(() {
      _streamSubscription?.cancel();
      results.clear();
      _isDiscovering = true;
      _connectedDeviceAdded = false;
    });

    _startDiscovery();
  }

  void addConnectedDeviceToList(ProvideBtState btStateProvider) {
    setState(() {
      results.insert(0, BluetoothDiscoveryResult(
        device: BluetoothDevice(
          name: btStateProvider.connectedBtDevice.name,
          isConnected: btStateProvider.getConnection.isConnected,
          address: btStateProvider.connectedBtDevice.address,
          bondState: BluetoothBondState.bonded,
          type: BluetoothDeviceType.unknown,
        ),
      ));
    });
  }

  static bool _connectedDeviceAdded = false;
  Widget listView() {
    final btStateProvider = Provider.of<ProvideBtState>(context, listen: false);
    if (!_connectedDeviceAdded && btStateProvider.isConnected) {
      addConnectedDeviceToList(btStateProvider);
      _connectedDeviceAdded = true;
    }
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (BuildContext context, index) {
        BluetoothDiscoveryResult result = results[index];
        return BluetoothDeviceListEntry(
          device: result.device,
          onTap: () async {
            final BtDevice btDevice = BtDevice(name: result.device.name, address: result.device.address);

            if (btStateProvider.isConnectedTo(btDevice)) {
              await btStateProvider.disconnect();
              // results.removeAt(0);
              _connectedDeviceAdded = false;
            } else {
              await btStateProvider.connect(btDeviceToConnectTo: btDevice);
              _connectedDeviceAdded = true;
            }
            setState(() {
              results[results.indexOf(result)] = BluetoothDiscoveryResult(
                  device: BluetoothDevice(
                    name: result.device.name ?? 'Unknown device',
                    address: btDevice.address,
                    type: result.device.type,
                    bondState: result.device.bondState,
                    isConnected: btStateProvider.isConnectedTo(btDevice),
                  ),
                  rssi: result.rssi);
            });
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
    );
  }

  void setupAnimation() {
    _animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (_isDiscovering) {
            _animationController.reset();
            _animationController.forward();
          } else {
            _animationController.reset();
          }
        }
      });
  }
}
