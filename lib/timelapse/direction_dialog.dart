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
      pageBuilder: (context, animation, secondaryAnimation) => DirectionDialog(),
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
  bool _isDismissed = false;

  @override
  Widget build(BuildContext context) {
    var popUpWidth = MediaQuery.of(context).size.width * 0.92;
    if (popUpWidth > 500) popUpWidth = 500; // limit max Width
    var popUpHeight = MediaQuery.of(context).size.height * 0.65;
    if (popUpHeight > 270) popUpHeight = 270; // limit max Height

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 24,
      backgroundColor: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: popUpHeight,
        width: popUpWidth,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffE3E3E3).withOpacity(0.17),
              ),
              width: popUpWidth,
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
                          width: popUpWidth - 20 < 262 ? popUpWidth - 20 : 262,
                          height: 45,
                          color: MyColors.green.withOpacity(0.50),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.black,
                                  highlightColor: Colors.white,
                                  direction: ShimmerDirection.rtl,
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
                              dismissThresholds: {DismissDirection.startToEnd: 1, DismissDirection.endToStart: 1},
                              onDismissed: (direction) {
                                _isDismissed = true;
                                RampedTlToString().send(context, direction == DismissDirection.startToEnd);
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(38),
                                child: Container(
                                  height: 38,
                                  width: 85,
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Text(
                                    'SEND',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 4,
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
