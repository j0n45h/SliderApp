import 'package:flutter/material.dart';

class Sun extends StatelessWidget {
  const Sun();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          // Sun
          height: 30,
          width: 30,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0xffff6e00),
                  Color(0xffff7e00).withOpacity(0.45),
                  Color(0xffff7e00).withOpacity(0.25),
                  Color(0xffff7e00).withOpacity(0),
                ],
              )),
        ),
        Container(
          height: 12,
          width: 12,
          // color: Colors.blue,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
//            color: Color(0xffFF8800),
          gradient: RadialGradient(
            colors: [
              Color(0xffff7e00),
              Color(0xffff8b00),
//            Color(0xffFF9900),
            ]
          )
          ),
        ),
      ],
    );
  }
}
