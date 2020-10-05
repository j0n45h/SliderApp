import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/utilities/BluetoothDeviceListEntry.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class SearchingDialog extends StatefulWidget {
  Future<void> showMyDialog(BuildContext context) async {
    return showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => null,
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
    final btStateProvider = Provider.of<ProvideBtState>(context, listen: false);
    final height = MediaQuery.of(context).size.height * 0.65;
    final width = MediaQuery.of(context).size.width * 0.9;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 24.0,
      backgroundColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width > 500 ? 500 : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              decoration: BoxDecoration(
                // color: MyColors.popup.withOpacity(0.2),
                // color: MyColors.bg.withOpacity(0.5),
                // color: Colors.black12.withOpacity(0.3),
                // color: Colors.white.withOpacity(0.05),
                color: Color(0xffE3E3E3).withOpacity(0.16),
              ),
              child: Stack(
                children: <Widget>[
                  OrientationBuilder(
                    builder: (context, orientation) {
                      if (orientation == Orientation.portrait) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topCenter,
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 15),
                              child: btIcon(btStateProvider),
                            ),
                            discoveredDevicesText(),
                            // Divider(
                            //   color: Colors.white.withOpacity(0.6),
                            //   height: 30,
                            //   indent: 20,
                            //   endIndent: 20,
                            // ),
                          ],
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  child: btIcon(btStateProvider),
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                ),
                                discoveredDevicesText(),
                              ],
                            ),
                            Divider(
                              color: Colors.white.withOpacity(0.6),
                              height: 10,
                              indent: 60,
                              endIndent: 60,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  Column(
                    children: <Widget>[
                      Container(height: isPortrait ? 125 : 70),
                      Divider(
                        color: Colors.white.withOpacity(0.1),
                        height: 0,
                        thickness: 1,
                      ),
                      Container(
                        height: isPortrait
                            ? height - 125 - 60
                            : height - 70 - 60,
                        // color: Colors.black.withOpacity(0.23),
                        color: Color(0xffE3E3E3).withOpacity(0.05),
                        child: listView(),
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.1),
                        height: 0,
                        thickness: 1,
                      ),
                      InkWell(
                        focusColor: MyColors.bg,
                        highlightColor: Colors.white.withOpacity(0.01),
                        borderRadius: BorderRadius.circular(15.0),
                        splashColor: Colors.white.withOpacity(0.2),
                        // splashColor: MyColors.popup.withOpacity(0.2),
                        onTap: () => _restartDiscovery(),
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          child: Text(
                            'Search',
                            style: MyTextStyle.normal(fontSize: 18.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget btIcon(ProvideBtState btStateProvider) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.0011)
        ..rotateY(2 * pi * _animation.value),
      alignment: FractionalOffset.center,
      child: SizedBox(
        width: 70,
        child: BtStateIcon(btStateProvider),
      ),
    );
  }

  Widget discoveredDevicesText() {
    return Text(
      'Discovered Devices:',
      style: MyTextStyle.normal(fontSize: 18.0),
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
              if (i.device.address == r.device.address) {
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
      results.insert(
          0,
          BluetoothDiscoveryResult(
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
            final BtDevice btDevice = BtDevice(
                name: result.device.name, address: result.device.address);

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
                    'Bonding with ${result.device.address} has ${bonded
                        ? 'succed'
                        : 'failed'}.');
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
            // btIcon = Icons.bluetooth_searching;
            _animationController.reset();
            _animationController.forward();
          } else {
            _animationController.reset();
            // btIcon = Icons.bluetooth;
          }
        } else if (_isDiscovering) {
          // btIcon = Icons.bluetooth_searching;
        }
      });
  }
}
