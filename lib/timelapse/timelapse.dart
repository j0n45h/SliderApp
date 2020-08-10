import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sliderappflutter/timelapse/linear_tl/linear.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';
import 'package:sliderappflutter/drawer.dart';

class TimelapseScreen extends StatefulWidget {
  static const routeName = '/timelapse-screen';

  @override
  _TimelapseScreenState createState() => _TimelapseScreenState();
}

class _TimelapseScreenState extends State<TimelapseScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;


  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      initialIndex: 0,
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 1.0,
          title: const Text(
            'Timelapse',
            style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
          ),
          centerTitle: true,
          backgroundColor: MyColors.AppBar,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(child: Text('LINEAR',
                  style: MyTextStyle.normalStdSize(letterSpacing: 3)),
              ),
              Tab(child: Text('RAMPED',
                  style: MyTextStyle.normalStdSize(letterSpacing: 3)),
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 0.5,
          ),
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            LinearTL(),
            RampedTL(),
          ],
        ),
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return;
      },
    );
  }
}