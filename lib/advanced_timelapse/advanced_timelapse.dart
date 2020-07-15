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
        body: Column(
          children: <Widget>[
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.amber,
                  child: CustomPaint(
                    painter: CurvePainter(),
                  ),

                ),
                Positioned(
                  top: dy,
                  left: dx,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    child: Transform.scale(child: Icon(Icons.adjust), scale: 1,),
                    /*
                    onVerticalDragUpdate: (DragUpdateDetails details) {
                      setState(() {
//                    print(details.globalPosition.dy.toString());
                        dy = details.globalPosition.dy;
                      });
                    },
                    onHorizontalDragUpdate: (DragUpdateDetails details) {
                      setState(() {
                        dx = details.globalPosition.dx;
                      });
                    },*/
                    onPanUpdate: (DragUpdateDetails details) {
                      setState(() {
                        dx = details.globalPosition.dx;
                        dy = details.globalPosition.dy - 90;
                      });
                    },
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
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return;
      },
    );
  }
}
