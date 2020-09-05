import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_graph/ramped_graph_screen.dart';

class RampCurvePreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.5,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        InkWell(
          onTap: () => Navigator.of(context).pushNamed(RampedGraphScreen.routeName),
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Transform.rotate(
              angle: pi/4,
              child: Icon(
                Icons.unfold_more,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
