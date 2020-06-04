import 'package:flutter/material.dart';

import 'drawer.dart';

import 'dashboard/dashboard.dart';

class VideoScreen extends StatelessWidget {
  static const routeName = '/video-screen';

  void navigateHome(BuildContext context) {
    Navigator.of(context).pushNamed(DashboardScreen.routeName);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Video'),
        ),
        drawer: MyDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Video-Page'),
            ],
          ),
        ),
      ),
    );
  }
}
