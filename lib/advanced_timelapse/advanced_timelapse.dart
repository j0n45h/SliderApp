import 'package:flutter/material.dart';
import 'package:sliderappflutter/advanced_timelapse/curvePainter.dart';

import '../drawer.dart';

class AdvancedTimelapseScreen extends StatefulWidget {
  static const routeName = '/advanced_timelapse-screen';

  @override
  _AdvancedTimelapseScreenState createState() => _AdvancedTimelapseScreenState();
}

class _AdvancedTimelapseScreenState extends State<AdvancedTimelapseScreen> {
  Offset _position = Offset(50, 50);
  double dx = 50;
  double dy = 50;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Advanced Timelapse'),
        ),
        drawer: MyDrawer(),
        body: ListView(
          children: [
            Column(
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 90,
                      color: Colors.amber,
                      child: CustomPaint(
                        painter: CurvePainter(Offset(dx, dy)),
                      ),

                    ),
                    Positioned(
                      top: dy,
                      left: dx,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onPanUpdate: (DragUpdateDetails details) {
                          setState(() {
                            dx += details.delta.dx;
                            dy += details.delta.dy;
                          });
                        },
//                        onVerticalDragUpdate: (details) {
//                          setState(() {
//                            print(details);
//                            dx += details.delta.dx;
//                            dy += details.delta.dy;
//                          });
//                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 30,
                          width: 30,
                          color: Colors.red,
                          child: Icon(Icons.adjust),
                        ),
                      ),
                    ),
                  ],
                ),
                MaterialButton(
                  child: Text('RESET'),
                  color: Colors.blue,
                  onPressed: (){
                    setState(() {
                      dx = 50;
                      dy = 50;
                    });
                  },
                ),
              ],
            ),
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
