import 'dart:async';
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
  LinearTL? linearTL;
  RampedTL? rampedTL;
  TlType type;

  PhotoListTitle({required this.index, required this.type, this.linearTL, this.rampedTL});
}

enum TlType{
  linear,
  ramped
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  static TabController? _tabController;
  static const List<String> _tabs = ['Photo', 'Video'];
  static int _tabIndex = 0;
  static List<PhotoListTitle> photoListTitle = [];

  Future<bool>? hasList;

  @override
  Widget build(BuildContext context) {
    print('Dashboard rebuild//////////////////////////////////////////////////////////');
    return Scaffold(
      // backgroundColor: Color(0xff242f33),
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 1.0,
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: IconButton(
              onPressed: () => Scaffold.of(context).openDrawer(),
              icon: Image.asset('assets/icons/DrawerIcon.png'),
            ),
          ),
        ),
        title: const Text('SLYDER'),
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
                  maxHeight: 320,
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
              future: hasList,
              builder: (context, snapshot) {
                if (snapshot.hasData && photoListTitle.length > 0) {
                  return ListView.builder(
                    itemCount: photoListTitle.length,
                    itemBuilder: (context, index) {
                      var preset = photoListTitle[index];
                      if (preset.type == TlType.linear)
                        return ListTile(
                          title: Text(preset.linearTL?.name ?? '',
                            style: MyTextStyle.normal(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Linear TL',
                            style: MyTextStyle.normalStdSize(
                                newColor: Colors.white),
                          ),
                          onTap: () {
                            if (preset.linearTL != null)
                              loadLinearTlPreset(context, preset.linearTL!);
                          },
                        );
                      else
                        return ListTile(
                          title: Text(
                            preset.rampedTL?.name ?? '',
                            style: MyTextStyle.normal(fontSize: 18),
                          ),
                          subtitle: Text(
                            'Ramped TL',
                            style: MyTextStyle.normalStdSize(),
                          ),
                          onTap: () =>
                              print('paped: ${preset.linearTL?.name}'),
                        );
                    },
                  );
                } else
                  return Center(
                    child: Text(
                      'Save a Timelapse-Preset to see it in this List',
                      style: MyTextStyle.normal(fontSize: 18),
                    ),
                  );
              },
            ),

            // Video
            FutureBuilder(
              future: hasList,
              builder: (context, snapshot) {
                if (snapshot.hasData && tlData.video?.length != null && tlData.video!.length > 0) {
                  return ListView.builder(
                    itemCount: tlData.video!.length,
                    itemBuilder: (context, index) {
                      var preset = tlData.video![index];
                      return ListTile(
                        title: Text(
                          preset.name ?? '',
                          style: MyTextStyle.normal(fontSize: 18),
                        ),
                      );
                    },
                  );
                } else
                  return Center(
                    child: Text(
                      'Save a Video-Preset to see it in this List',
                      style: MyTextStyle.normal(fontSize: 18),
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
    _tabController?.addListener(() {
      _tabIndex++;
      _tabIndex %= 2;
    });
    hasList = makeList();

    super.initState();
  }


    void loadLinearTlPreset(BuildContext context, LinearTL linearTL) {
      SetUpLinearTL.loadData(linearTL);
      TimelapseScreenState.tabIndex = 0;
      Navigator.of(context).pushNamed(TimelapseScreen.routeName);
    }

  Future<bool> makeList() async {
    if (!tlData.dataHasBeenLoaded) await tlData.openFromAssets();
    // if (!tlData.dataHasBeenLoaded) await tlData.getFromCache();

    /// Photo List
    photoListTitle.clear();
    for (int i = 0; i < (tlData.linearTL?.length ?? 0); i++)
      photoListTitle.add(PhotoListTitle(
        index: tlData.linearTL![i].index ?? i,
        type: TlType.linear,
        linearTL: tlData.linearTL![i],
      ));
    for (int i = 0; i < (tlData.rampedTL?.length ?? 0); i++) {
      photoListTitle.add(PhotoListTitle(
        index: tlData.rampedTL![i].index ?? i + (tlData.linearTL?.length ?? 0),
        type: TlType.ramped,
        rampedTL: tlData.rampedTL![i],
      ));
    }

    photoListTitle.sort((a, b) => a.index.compareTo(b.index));

    /// Video List
    tlData.video?.sort((a, b) => a.index?.compareTo(b.index ?? 0) ?? 0);

    return true;
  }
}