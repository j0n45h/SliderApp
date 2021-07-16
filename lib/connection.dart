import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/cubit_ramping_points.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/path.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/state/ramping_points_state.dart';

import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/state/running_tl_state.dart';
import 'package:sliderappflutter/utilities/text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

import 'drawer.dart';

class ConnectionScreen extends StatefulWidget {
  static const routeName = '/runningTL-screen';

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    final rampPointsCountState = Provider.of<RampingPointsState>(context, listen: false);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 1,
          title: const Text(
            'Running Timelapse',
            style: TextStyle(fontFamily: 'Bellezza', letterSpacing: 5),
          ),
          centerTitle: true,
          backgroundColor: MyColors.AppBar,
        ),
        drawer: MyDrawer(),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: 200,
              width: MediaQuery.of(context).size.width - 20,
              child: Stack(
                alignment: Alignment.topLeft,
                fit: StackFit.expand,
                children: [
                  BlocBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                      builder: (context, state) {
                    if (state.length < 1) return Container();

                    return CustomPaint(
                      painter: PathPainter(context, state, rampPointsCountState.rampingPoints),
                    );
                  }),
                  BlocBuilder<RampCurveCubit, List<CubitRampingPoint>>(
                    builder: (context, state) {
                      final runningTl = Provider.of<RunningTlState>(context, listen: false);
                      final shots = context.read<RampCurveCubit>().getShots(context) ?? 1;
                      final size = Size(MediaQuery.of(context).size.width - 20, 200);

                      // Calc y-position
                      final path = RampPath.getPath(size, context, state, rampPointsCountState.rampingPoints, false);
                      final metrics = path.computeMetrics().elementAt(0);
                      final offset = metrics.getTangentForOffset(metrics.length * (runningTl.shotsTaken/shots))?.position ?? Offset(0, 0);
                      return Positioned(
                        top: offset.dy,
                        left: size.width * (runningTl.shotsTaken/shots),
                        child: Container(
                          height: 30,
                          width: 30,
                          transform: Matrix4.translationValues(-15, -15, 0),
                          child: Icon(Icons.adjust, color: MyColors.green),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 50),
              child: Consumer<RunningTlState>(builder: (context, tlState, child) {
                const double tfWidth = 120;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ShotsTaken:', style: MyTextStyle.fetStdSize()),
                        FramedTextField(
                          textField: MyTextField(
                            enabled: false,
                            textController: TextEditingController(
                              text: '${tlState.shotsTaken}/${context.read<RampCurveCubit>().getShots(context)}',
                            ),
                            fontSize: 14,
                          ),
                          height: 30,
                          width: tfWidth,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Current Interval:', style: MyTextStyle.fetStdSize()),
                        FramedTextField(
                          textField: MyTextField(
                            enabled: false,
                            textController: TextEditingController(
                              text: tlState.currentIntervalString(),
                            ),
                            unit: 'sec',
                            fontSize: 14,
                          ),
                          height: 30,
                          width: tfWidth,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Maximal Exposuere Time:', style: MyTextStyle.fetStdSize()),
                        FramedTextField(
                          textField: MyTextField(
                            textController: TextEditingController(
                              text: tlState.maxExposureString(),
                            ),
                            enabled: false,
                            unit: 'sec',
                            fontSize: 14,
                          ),
                          height: 30,
                          width: tfWidth,
                        ),
                      ],
                    ),
                  ],
                );
              }),
            )
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
