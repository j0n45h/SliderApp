import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/colors.dart';

class MySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  MySwitch({
    @required this.onChanged,
    this.value,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 20,
      child: Switch(
        activeColor: Colors.white,
        activeTrackColor: MyColors.slider,
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[700],
        onChanged: (_) => onChanged(_),
        value: value,
      ),
    );
  }
}
