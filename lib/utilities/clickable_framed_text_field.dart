import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class ClickableFramedTimeField extends StatelessWidget {
  final GestureTapCallback? onTap;
  final DateTime? time;
  final double width, height;
  static const String notSet = '-- : --';

  const ClickableFramedTimeField({
    Key? key,
    this.time,
    this.onTap,
    this.width  = 100,
    this.height = 30,
  }) : super(key: key); // add Popup

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: FramedTextField(
        width: width,
        height: height,
        textField: Text(
          _timeToString(context),
          style: MyTextStyle.normal(fontSize: 12),
        ),
      ),
    );
  }

  String _timeToString(BuildContext context) {
    if (time == null)
      return notSet;
    if (MediaQuery.of(context).alwaysUse24HourFormat)
      return DateFormat.Hm().format(time!);
    else
      return DateFormat.jm().format(time!);
  }
}
