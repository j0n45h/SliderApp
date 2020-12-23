
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/Logic/ramped_tl_toString.dart';

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.65;
    final width = MediaQuery.of(context).size.width * 0.9;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 24,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width > 500 ? 500 : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              decoration: BoxDecoration(color: Color(0xffE3E3E3).withOpacity(0.16)),
              width: width > 500 ? 500 : width,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text('Start TL', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 50),
                  Text('Direction', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () => setState(() => direction = !direction),
                    child: RotatedBox(
                      quarterTurns: direction ? 2 : 0,
                      child: Icon(Icons.double_arrow, color: Colors.red, size: 80),
                    ),
                  ),
                  const SizedBox(height: 40),
                  MaterialButton(
                    minWidth: 150,
                    height: 50,
                    onPressed: () => RampedTlToString().send(context, direction),
                    color: Colors.grey,
                    child: Text('Send'),
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