import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliderappflutter/dashboard/bluetooth_box.dart';
import 'package:sliderappflutter/dashboard/circular_battery_indicator.dart';
import 'package:sliderappflutter/dashboard/sun_position_wave.dart';
import 'package:sliderappflutter/dashboard/sunrisesunset_icons.dart';
import 'package:sliderappflutter/dashboard/weather_widget.dart';
import 'package:sliderappflutter/drawer.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/';


  @override
  Widget build(BuildContext context) {
    print('Dashboard rebuild//////////////////////////////////////////////////////////');
    return Scaffold(
      // backgroundColor: Color(0xff242f33),
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 1.0,
        /*leading: Transform.scale( // TODO Fix drawerIcon onPress:
          scale: 0.65,
          child: IconButton(
            onPressed: () { _scaffoldKey.currentState.openDrawer();},
            icon: Image.asset('assets/icons/DrawerIcon.png'),
          ),
        ),*/
        title: const Text(
          'J Slide',
          style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
        ),
        centerTitle: true,
        actions: <Widget>[
          Transform.rotate(
            angle: (-math.pi / 2),
            child: const Icon(
              // TODO Change to scalable battery
              Icons.battery_std,
              color: MyColors.green,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: const Text('10h'),
          ),
        ],
        backgroundColor: MyColors.AppBar,
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              minHeight: 0.0,
              maxHeight: 350.0,
              child: Column(
                children: <Widget>[
                  const Divider(
                    color: Colors.white,
                    thickness: 0.15,
                    height: 1,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const CircularBatteryIndicator(75),
                        Container(
                          // Weather and BT Box
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.fromLTRB(0, 16, 15, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              BluetoothBox(),
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: WeatherWidget(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SunriseSunsetIcons(),
                  const SunPositionWave(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // SliverToBoxAdapter(child: PhotoVideoTabBar(),),
          SliverList(
            delegate: ,
          ),
      ),
    );
  }
}



class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}