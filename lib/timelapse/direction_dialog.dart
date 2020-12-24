import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/ramped_tl_toString.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/lib/shimmer.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class DirectionDialog extends StatefulWidget {
  void openDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (_, __, ___) => null,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black.withOpacity(0.4),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
            opacity: anim1.value,
            child: DirectionDialog(),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 300),
    );
  }

  @override
  _DirectionDialogState createState() => _DirectionDialogState();
}

class _DirectionDialogState extends State<DirectionDialog> {
  bool direction = false;
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.65;
    final width = MediaQuery.of(context).size.width * 0.9;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 270,
        width: width > 500 ? 500 : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffE3E3E3).withOpacity(0.17),
              ),
              width: width > 500 ? 500 : width,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Start',
                    style: MyTextStyle.fet(fontSize: 20.0),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Chose the direction you want the Slider to move in',
                    style: MyTextStyle.normal(fontSize: 18.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 70),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Container(
                          width: width > 500 ? (500 - 100).toDouble() : width - 100,
                          height: 40,
                          color: MyColors.green.withOpacity(0.40),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.black,
                                  highlightColor: Colors.white,
                                  child: Icon(
                                    Icons.arrow_back_ios_sharp,
                                    color: Colors.black45,
                                    size: 30,
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.black,
                                  highlightColor: Colors.white,
                                  child: RotatedBox(
                                    quarterTurns: 2,
                                    child: Icon(
                                      Icons.arrow_back_ios_sharp,
                                      color: Colors.black45,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (_isDismissed)
                            return Container();
                          else
                            return Dismissible(
                              key: Key('Send'),
                              direction: DismissDirection.horizontal,
                              dismissThresholds: {DismissDirection.startToEnd: 1},
                              onDismissed: (direction) {
                                _isDismissed = true;
                                RampedTlToString().send(context, direction == DismissDirection.startToEnd);
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Container(
                                  // width: width > 500 ? 500 - 100 : width - 100,
                                  height: 35,
                                  width: 75,
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Text(
                                    'SEND',
                                    style: MyTextStyle.fetStdSize(
                                      letterSpacing: 4,
                                      newColor: Colors.black,
                                      fontWight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
