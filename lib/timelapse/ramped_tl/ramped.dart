import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampedTL extends StatefulWidget {
  @override
  _RampedTLState createState() => _RampedTLState();
}

class _RampedTLState extends State<RampedTL> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'hallo',
        style: MyTextStyle.normal(fontSize: 20),
      ),
    );
  }
}
