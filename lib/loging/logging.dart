import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/drawer.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';
import 'package:sliderappflutter/utilities/state/running_tl_state.dart';

class LoggingScreen extends StatelessWidget {
  static const routeName = '/logging';

  Widget build(BuildContext context) {
    final runningTL = Provider.of<RunningTlState>(context, listen: false);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 1.0,
          title: const Text(
            'Logging',
            style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
          ),
          actions: [const BtStateIcon(), SizedBox(width: 20)],
          centerTitle: true,
          backgroundColor: MyColors.AppBar,
        ),
        drawer: MyDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MaterialButton(
              color: Colors.red,
              onPressed: () => runningTL.clearLog(),
              child: Text('Clear'),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height - 150,
              child: Consumer<RunningTlState>(
                builder: (context, runningTlState, child) => SingleChildScrollView(
                  child: Text(
                    runningTlState.log,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () {
        MyDrawer.navigateHome(context);
        return Future.value(true);
      },
    );
  }
}
