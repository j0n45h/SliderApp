import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/drawer.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';
import 'package:sliderappflutter/utilities/state/bt_state_icon.dart';

class LoggingScreen extends StatefulWidget {
  static const routeName = '/logging';

  @override
  _LoggingScreenState createState() => _LoggingScreenState();
}

class _LoggingScreenState extends State<LoggingScreen> {
  @override
  Widget build(BuildContext context) {
    //final btState = Provider.of<ProvideBtState>(context, listen: false);
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
        body: Consumer<ProvideBtState>(
          builder: (context, btStateConsumer, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Colors.grey,
                    onPressed: () => btStateConsumer.clearLog(),
                    child: Text('Clear'),
                  ),
                  MaterialButton(
                    color: Colors.grey,
                    onPressed: () => setState(() {}),
                    child: Text('Refresh'),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                height: MediaQuery.of(context).size.height - 150,
                child: Consumer<ProvideBtState>(
                  builder: (context, btStateConsumer, child) => SingleChildScrollView(
                    child: Text(
                      btStateConsumer.log,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ),
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
