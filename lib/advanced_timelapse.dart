import 'package:flutter/material.dart';

import 'drawer.dart';

class AdvancedTimelapseScreen extends StatelessWidget {
  static const routeName = '/advanced_timelapse-screen';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Advanced Timelapse'),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('AdvancedTL-Page'),
            ],
          ),
        ),
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return;
      },
    );
  }
}
