import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sliderappflutter/dashboard/dashboard_top_view.dart';
import 'package:sliderappflutter/drawer.dart';
import 'package:sliderappflutter/main.dart';
import 'package:sliderappflutter/timelapse/linear_tl/interval_duration_shots.dart';
import 'package:sliderappflutter/timelapse/timelapse.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/custom_sliver.dart';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class PhotoListTitle {
  int index;
  LinearTL linearTL;
  RampedTL rampedTL;

  PhotoListTitle({this.index, this.linearTL, this.rampedTL});
}


class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  static TabController _tabController;
  static const List<String> _tabs = ['Photo', 'Video'];
  static int _tabIndex = 0;
  static var photoListTitle = List<PhotoListTitle>();

  Future<bool> futureList;

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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                pinned: true,
                delegate: SliverFoldableBoxDelegate(
                  minHeight: 0,
                  maxHeight: 300,
                  child: DashboardTopView(),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFoldableBoxDelegate(
                minHeight: 50,
                maxHeight: 50,
                child: Container(
                  color: Colors.black,
                  child: TabBar(
                    controller: _tabController,
                    tabs: _tabs.map((String name) =>
                        Tab(
                          child: Text(name,
                              style: MyTextStyle.normalStdSize(letterSpacing: 3)),
                        )).toList(),
                    indicatorColor: Colors.white,
                    indicatorPadding: const EdgeInsets.only(left: 15, right: 15),
                    indicatorWeight: 0.5,
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Photo
            FutureBuilder(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: photoListTitle.length,
                    itemBuilder: (context, index) {
                      var preset = photoListTitle[index];
                      if (preset.linearTL != null)
                        return ListTile(
                          title: Text(preset.linearTL.name,
                            style: MyTextStyle.normal(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Linear TL',
                            style: MyTextStyle.normalStdSize(
                                newColor: Colors.white),
                          ),
                          onTap: () =>
                              loadLinearTlPreset(context, preset.linearTL),
                        );
                      else
                        return ListTile(
                          title: Text(
                            preset.rampedTL.name,
                            style: MyTextStyle.normal(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Ramped TL',
                            style: MyTextStyle.normalStdSize(),
                          ),
                          onTap: () =>
                              print('paped: ${preset.linearTL.name}'),
                        );
                    },
                  );
                } else
                  return Center(
                    child: Text(
                      'Save a Timelapse-Preset to see it in this List',
                      style: MyTextStyle.normal(fontSize: 24),
                    ),
                  );
              },
            ),

            // Video
            FutureBuilder(
              future: futureList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: tlData.video.length,
                    itemBuilder: (context, index) {
                      var preset = tlData.video[index];
                      return ListTile(
                        title: Text(
                          preset.name,
                          style: MyTextStyle.normal(fontSize: 18),
                        ),
                      );
                    },
                  );
                } else
                  return Center(
                    child: Text(
                      'Save a Video-Preset to see it in this List',
                      style: MyTextStyle.normal(fontSize: 24),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _tabController = TabController(
      length: 2,
      initialIndex: _tabIndex,
      vsync: this,
    );
    _tabController.addListener(() {
      _tabIndex++;
      _tabIndex %= 2;
    });
    futureList = makeList();
    super.initState();
  }


    void loadLinearTlPreset(BuildContext context, LinearTL linearTL) {
      SetUpLinearTL.loadData(linearTL);
      TimelapseScreenState.tabIndex = 0;
      Navigator.of(context).pushNamed(TimelapseScreen.routeName);
    }

  Future<bool> makeList() async {
    if (!tlData.dataHasBeenLoaded) await tlData.openFromAssets();

    /// Photo List
    photoListTitle.clear();
    for (int i = 0; i < tlData.linearTL.length; i++)
      photoListTitle.add(PhotoListTitle(
        index: tlData.linearTL[i].index,
        linearTL: tlData.linearTL[i],
      ));
    for (int i = 0; i < tlData.rampedTL.length; i++) {
      photoListTitle.add(PhotoListTitle(
        index: tlData.rampedTL[i].index,
        rampedTL: tlData.rampedTL[i],
      ));
    }

    photoListTitle?.sort((a, b) => a.index.compareTo(b.index));

    /// Video List
    tlData.video?.sort((a, b) => a.index.compareTo(b.index));

    return true;
  }
}