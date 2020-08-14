import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class SaveTLDialog extends StatelessWidget {
  final TextEditingController presetName;
  final VoidCallback onDone;

  SaveTLDialog({@required this.onDone, this.presetName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 24,
      insetAnimationDuration: Duration(milliseconds: 500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: EdgeInsets.all(5),
      child: Container(
        alignment: Alignment.center,
        height: 155,
        constraints: BoxConstraints(minHeight: 155),
        width: width > 380 ? 380 : width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
              ),
              constraints: const BoxConstraints(minWidth: 200),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    'Give this Preset a Name',
                    style: MyTextStyle.normal(fontSize: 16),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: presetName,
                      style: MyTextStyle.normal(fontSize: 12),
                      cursorWidth: 1.2,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey[300],
                            width: 0.8,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  RawMaterialButton(
                    padding: const EdgeInsets.only(left: 50, right: 50),
                    elevation: 8,
                    shape: StadiumBorder(),
                    fillColor: const Color(0xff00FF5F),
                    child: Text('Save'),
                    onPressed: () {
                      onDone();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
