import 'package:flutter/material.dart';

import 'drawer.dart';

class TimelapseScreen extends StatelessWidget {
  static const routeName = '/timelapse-screen';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Timelapse'),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('TL-Page'),
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
