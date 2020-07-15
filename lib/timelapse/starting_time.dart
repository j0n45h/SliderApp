import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class StartingTime extends StatefulWidget {
  @override
  _StartingTimeState createState() => _StartingTimeState();
}

class _StartingTimeState extends State<StartingTime> {
  TextEditingController hoursTEC;
  TextEditingController minutesTEC;

  bool boolean = false;

  @override
  void initState() {
    hoursTEC.text = '10';
    minutesTEC.text = '30';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 60,
          height: 20,
          child: Switch(
            activeColor: Colors.white,
            activeTrackColor: MyColors.slider,
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[700],
            onChanged: (bool value) {
              print(value);
              setState(() {
                boolean = !boolean;
              });
            },
            value: boolean,
          ),
        ),
        const SizedBox(width: 15),
        Text(
          'STARTING TIME',
          style: MyTextStyle.normal(fontSize: 12, letterSpacing: 1.3),
        ),
//        Container(
//          alignment: Alignment.centerRight,
//          child: FramedTextField(
//            width: 120,
//            height: 30,
//            textField: Row(
//              children: <Widget>[
//                Container(
//                  width: 30,
//                  child: MyTextField(
//                    textController: hoursTEC,
//                    fontSize: 12,
//                  ),
//                ),
//                Container(
//                  width: 30,
//                  child: MyTextField(
//                    textController: minutesTEC,
//                    fontSize: 12,
//
//                  ),
//                ),
//              ],
//            ),
//          ),
//        ),
      ],
    );
  }
}
