import 'package:flutter/material.dart';
import 'package:sliderappflutter/main.dart';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class PhotoVideoTabBar extends StatefulWidget {
  @override
  _PhotoVideoTabBarState createState() => _PhotoVideoTabBarState();
}

class _PhotoVideoTabBarState extends State<PhotoVideoTabBar>
    with SingleTickerProviderStateMixin {
  static TabController _tabController;
  static int _tabIndex = 0;
  static var photoListTitle = List<PhotoListTitle>();
  Future<bool> futureList;



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

  Future<bool> makeList() async {
    if (!tlData.dataHasBeenLoaded)
      await tlData.openFromAssets();

    /// Photo List
    photoListTitle.clear();
    for(int i=0; i<tlData.linearTL.length; i++)
      photoListTitle.add(PhotoListTitle(
        index: tlData.linearTL[i].index,
        linearTL: tlData.linearTL[i],
      ));
    for(int i=0; i<tlData.rampedTL.length; i++){
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Text('Photo',
                    style: MyTextStyle.normalStdSize(letterSpacing: 3)),
              ),
              Tab(
                child: Text('Video',
                    style: MyTextStyle.normalStdSize(letterSpacing: 3)),
              ),
            ],
            indicatorColor: Colors.white,
            indicatorPadding: const EdgeInsets.only(left: 15, right: 15),
            indicatorWeight: 0.5,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 130,
          child: TabBarView(
            controller: _tabController,
            children: [
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
                                style: MyTextStyle.normal(fontSize: 18)),
                            subtitle: Text(
                              'Linear TL',
                              style: MyTextStyle.normalStdSize(
                                  newColor: Colors.white),
                            ),
                            onTap: () => print('taped: ${preset.linearTL.name}'),
                          );
                        else
                          return ListTile(
                            title: Text(preset.rampedTL.name, style: MyTextStyle.normal(fontSize: 18),),
                            subtitle: Text('Ramped TL', style: MyTextStyle.normalStdSize(),),
                            onTap: () => print('paped: ${preset.linearTL.name}'),
                          );
                      },
                    );
                  }
                  else
                    return Center(
                      child: Text(
                        'Save a Timelapse-Preset to see it in this List',
                        style: MyTextStyle.normal(fontSize: 24),
                      ),
                    );
                },
              ),
              FutureBuilder(
                future: futureList,
                builder: (context, snapshot) {
                  if (snapshot.hasData){
                    return ListView.builder(
                      itemCount: tlData.video.length,
                      itemBuilder: (context, index) {
                        var preset = tlData.video[index];
                        return ListTile(
                          title: Text(preset.name,
                            style: MyTextStyle.normal(fontSize: 18),
                          ),
                        );
                      },
                    );
                  }
                  else
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
      ],
    );
  }
}

class PhotoListTitle {
  PhotoListTitle({this.index, this.linearTL, this.rampedTL});
  int index;
  LinearTL linearTL;
  RampedTL rampedTL;
}
