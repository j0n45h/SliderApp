import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/utilities/text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class ClickableFramedTF extends StatelessWidget {
  final TextEditingController hoursTEC;
  final TextEditingController minutesTEC;
  final GestureTapCallback onTap; // add Popup
  final double width, tfWidth, height;

  ClickableFramedTF({
    @required this.hoursTEC,
    @required this.minutesTEC,
    this.onTap,
    this.tfWidth = 25,
    this.width = 100,
    this.height = 30,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap, // open dialog
      child: FramedTextField(
        width: width,
        height: height,
        textField: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: tfWidth,
              child: MyTextField(
                textController: hoursTEC,
                fontSize: 12,
                enabled: false,
              ),
            ),
            Text(
              ':',
              style: MyTextStyle.fet(fontSize: 12),
            ),
            Container(
              width: tfWidth,
              child: MyTextField(
                textController: minutesTEC,
                fontSize: 12,
                enabled: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ClickableFramedTimeField extends StatelessWidget {
  final GestureTapCallback onTap;
  final String time;
  final double width, tfWidth, height;

  const ClickableFramedTimeField({
    Key key,
    this.time = '-- : --',
    this.onTap,
    this.tfWidth = 25,
    this.width   = 100,
    this.height  = 30,
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
          time,
          style: MyTextStyle.normal(fontSize: 12),
        ),
      ),
    );
  }
}
