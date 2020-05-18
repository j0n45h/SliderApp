import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

import 'dashboard/dashboard.dart';
import 'timelapse.dart';
import 'advanced_timelapse.dart';
import 'video.dart';
import 'connection.dart';
import 'Settings/settings.dart';

class MyDrawer extends StatelessWidget {
  static const routeName = '/drawer';
  static navigateHome(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 300,
        child: Stack(
          children: <Widget>[
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                decoration: BoxDecoration(
                  color: MyColors.bg.withOpacity(0.0),
//                  color: Color(0xff316f7f).withOpacity(0.2),
                ),
              ),
            ),
            ListView(
              children: <Widget>[
                Container(height: 140,),
                ListTile(
                  leading: Icon(Icons.widgets, color: Colors.grey[100]),
                  title: Text('Dashboard', style: MyTextStyle.fetStdSize(),),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(DashboardScreen.routeName);
                  },
                ),
                Divider(color: Colors.grey[100].withOpacity(0.4), indent: 6, thickness: 0.6),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.grey[100]),
                  title: Text('Timelapse', style: MyTextStyle.fetStdSize(),),
                  subtitle: Text('easy mode', style: MyTextStyle.normalStdSize(),),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(TimelapseScreen.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_enhance, color: Colors.grey[100]),
                  title: Text('Advanced Timelapse', style: MyTextStyle.fetStdSize(),),
                  subtitle: Text('pro mode', style: MyTextStyle.normalStdSize(),),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(AdvancedTimelapseScreen.routeName);
                  },
                ),
                Divider(color: Colors.grey[100].withOpacity(0.4), indent: 6, thickness: 0.6),
                ListTile(
                  leading: Icon(Icons.videocam, color: Colors.grey[100]),
                  title: Text('Video', style: MyTextStyle.fetStdSize(),),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(VideoScreen.routeName);
                  },
                ),
                Divider(color: Colors.grey[100].withOpacity(0.4), indent: 6, thickness: 0.6),
                ListTile(
                  leading: Icon(Icons.bluetooth, color: Colors.grey[100]),
                  title: Text('Connection', style: MyTextStyle.fetStdSize(),),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(ConnectionScreen.routeName);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey[100]),
                  title: Text('Settings', style: MyTextStyle.fetStdSize(),),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed(SettingsScreen.routeName);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        // Set the transparency here
          canvasColor: Color(0xff316f7f).withOpacity(0.3),
//        canvasColor: MyColors.bg.withOpacity(0.7), //or any other color you want. e.g Colors.blue.withOpacity(0.5)
      ),
      child: Drawer(
        child: ListView(
          children: <Widget>[
            Container(height: 140,),
            ListTile(
              leading: Icon(
                Icons.widgets,
                color: Colors.lightBlue,
              ),
              title: Text('Dashboard', style: MyTextStyle.fetStdSize(),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(DashboardScreen.routeName);
              },
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.lightBlue),
              title: Text('Timelapse', style: MyTextStyle.fetStdSize(),),
              subtitle: Text('easy mode', style: MyTextStyle.normalStdSize(),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(TimelapseScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_enhance, color: Colors.amber),
              title: Text('Advanced Timelapse', style: MyTextStyle.fetStdSize(),),
              subtitle: Text('pro mode', style: MyTextStyle.normalStdSize(),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(AdvancedTimelapseScreen.routeName);
              },
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(Icons.videocam, color: Colors.lightBlue),
              title: Text('Video', style: MyTextStyle.fetStdSize(),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(VideoScreen.routeName);
              },
            ),
            Divider(
              color: Colors.blueGrey,
            ),
            ListTile(
              leading: Icon(Icons.bluetooth, color: Colors.lightBlue),
              title: Text('Connection', style: MyTextStyle.fetStdSize(),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(ConnectionScreen.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.lightBlue),
              title: Text('Settings', style: MyTextStyle.fetStdSize(),),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(SettingsScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
