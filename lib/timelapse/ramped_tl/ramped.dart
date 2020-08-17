import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sliderappflutter/timelapse/ramped_tl/ramped_tl_state.dart';
import 'package:sliderappflutter/timelapse/save_start_buttons.dart';
import 'package:sliderappflutter/utilities/clickable_framed_text_field.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class RampedTL extends StatefulWidget {
  @override
  _RampedTLState createState() => _RampedTLState();
}

class _RampedTLState extends State<RampedTL> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RampedTLState(),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(15, 25, 15, 10),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'START',
                        style: MyTextStyle.normal(
                            fontSize: 12, letterSpacing: 1.3
                        ),
                      ),
                      const SizedBox(width: 18),
                      Consumer<RampedTLState>(
                        builder: (context, rampedTLState, _) =>
                            ClickableFramedTimeField(
                          time: rampedTLState.startingTimeStr(context),
                          onTap: () {
                            print(MediaQuery.of(context).alwaysUse24HourFormat);
                            print(DateFormat.jm().format(DateTime.now()));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          SaveAndStartButtons(
            onPressSave: null,
            onPressStart: null,
          ),
        ],
      ),
    );
  }
}
