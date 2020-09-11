import 'package:flutter/material.dart';
import 'package:sliderappflutter/timelapse/framed_textfield.dart';
import 'package:sliderappflutter/utilities/colors.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class ToolBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(width: 20),
              Text(
                'SHOTS',
                style: MyTextStyle.normal(fontSize: 12),
              ),
              SizedBox(width: 10),
              FramedTextField(
                width: 75,
                height: 25,
                textField: Text(
                  '1353',
                  style: MyTextStyle.normal(fontSize: 12),
                ),
              ),
            ],
          ),
          Text(
            '',
            style: MyTextStyle.normal(fontSize: 14),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline, color: Colors.red),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.white),
              ),
              IconButton(
                icon: Icon(Icons.check, color: MyColors.green),
              ),
              SizedBox(width: 15)
            ],
          ),
        ],
      ),
    );
  }
}
