import 'package:flutter/material.dart';

class RampedGraph extends StatefulWidget {
  @override
  _RampedGraphState createState() => _RampedGraphState();
}

class _RampedGraphState extends State<RampedGraph> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          print(constraints.toString());
          return Container(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}
