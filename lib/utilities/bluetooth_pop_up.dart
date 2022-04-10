import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliderappflutter/utilities/BluetoothDeviceListEntry.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class SearchingDialog extends StatefulWidget {
  Future<void> showMyDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => SearchingDialog(),
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

class _SearchingDialogState extends State<SearchingDialog> with SingleTickerProviderStateMixin {
  static const double _searchButtonHeight = 50;
  Animation? _animation;
  AnimationController? _animationController;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.65;
    final width = MediaQuery.of(context).size.width * 0.9;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final provideBtState = Provider.of<ProvideBtState>(context, listen: false);
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
                              child: btIcon(),
                            ),
                            discoveredDevicesText(),
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
                                  child: btIcon(),
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
                      Container(height: isPortrait ? 115 : 70),
                      Divider(
                        color: Colors.white.withOpacity(0.1),
                        height: 0,
                        thickness: 1,
                      ),
                      Container(
                        height: isPortrait ? height - 125 - _searchButtonHeight : height - 70 - _searchButtonHeight,
                        // color: Colors.black.withOpacity(0.23),
                        color: Color(0xffE3E3E3).withOpacity(0.05),
                        child: deviceListView(),
                      ),
                      Divider(
                        color: Colors.white.withOpacity(0.1),
                        height: 0,
                        thickness: 1,
                      ),
                      StreamBuilder<bool>(
                          initialData: false,
                          stream: FlutterBluePlus.instance.isScanning,
                          builder: (context, snapshot) {
                            if (snapshot.data ?? false)
                              return InkWell(
                                focusColor: MyColors.bg,
                                highlightColor: Colors.white.withOpacity(0.01),
                                borderRadius: BorderRadius.circular(15.0),
                                splashColor: Colors.white.withOpacity(0.2),
                                onTap: () => FlutterBluePlus.instance.stopScan(),
                                child: Container(
                                  height: _searchButtonHeight,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Stop',
                                    style: MyTextStyle.normal(fontSize: 18.0),
                                  ),
                                ),
                              );
                            return InkWell(
                              focusColor: MyColors.bg,
                              highlightColor: Colors.white.withOpacity(0.01),
                              borderRadius: BorderRadius.circular(15.0),
                              splashColor: Colors.white.withOpacity(0.2),
                              onTap: () => provideBtState.startScanning(),
                              child: Container(
                                height: _searchButtonHeight,
                                alignment: Alignment.center,
                                child: Text(
                                  'Search',
                                  style: MyTextStyle.normal(fontSize: 18.0),
                                ),
                              ),
                            );
                          }),
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

  Widget btIcon() {
    return StreamBuilder<bool>(
        stream: FlutterBluePlus.instance.isScanning,
        initialData: false,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            _animationController?.forward();
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0011)
                ..rotateY(2 * pi * (_animation?.value ?? 0)),
              alignment: FractionalOffset.center,
              child: SizedBox(
                width: 70,
                child: BtStateIcon(),
              ),
            );
          } else {
            _animationController?.stop();
            return SizedBox(
              width: 70,
              child: BtStateIcon(),
            );
          }
        });
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
    setupAnimation();
    //startScanning();
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _animationController?.dispose();
    FlutterBluePlus.instance.stopScan();

    super.dispose();
  }

  Widget deviceListView() {
    final provideBtState = Provider.of<ProvideBtState>(context, listen: false);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Consumer<ProvideBtState>(
            builder: (context, provideBtState, child) {
              if (provideBtState.isConnected) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15, top: 3, right: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Connected to:',
                        style: MyTextStyle.normal(fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            provideBtState.device?.name ?? '',
                            style: MyTextStyle.normal(fontSize: 16),
                          ),
                          TextButton(
                            onPressed: () => provideBtState.disconnect(null),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.red),
                                ),
                              ),
                            ),
                            child: Text(
                              'disconnect',
                              style: MyTextStyle.fetStdSize(newColor: Colors.red, letterSpacing: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                );
              } else
                return Container();
            },
          ),
          Divider(color: Colors.white, indent: 10, endIndent: 10, height: 25, thickness: 0.3),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 3),
            child: Text(
              'Available:',
              style: MyTextStyle.normal(fontSize: 12),
            ),
          ),
          StreamBuilder<List<ScanResult>>(
            stream: FlutterBluePlus.instance.scanResults,
            initialData: [],
            builder: (c, snapshot) {
              if (snapshot.data == null) return Container();
              return Column(
                children: snapshot.data!.map(
                  (result) {
                    if (result.device.name.length < 1) return Container();
                    return BluetoothDeviceListEntry(
                      device: result.device,
                      onTap: () async {
                        await provideBtState.connect(result.device);
                        FlutterBluePlus.instance.stopScan();
                      },
                    );
                  },
                ).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  void setupAnimation() {
    _animationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    final Animation<double> curve = CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut);
    _animation = Tween(begin: 0.0, end: 1.0).animate(curve)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController?.reset();
          _animationController?.forward();
        }
      });
  }
}
