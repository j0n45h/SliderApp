import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class SaveAndStartButtons extends StatelessWidget {
  final VoidCallback onPressSave;
  final VoidCallback onPressStart;
  final Widget saveButton;

  const SaveAndStartButtons({this.onPressSave, this.onPressStart, this.saveButton});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.05),
              Colors.black54,
              Colors.black87
            ],
          ),
        ),
        height: 40,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 160,
              child: RawMaterialButton(
                child: Text(
                  'SAVE',
                  style: MyTextStyle.fetStdSize(
                    letterSpacing: 6,
                    newColor: Colors.black,
                    fontWight: FontWeight.w400,
                  ),
                ),
                fillColor: Colors.white,
                onPressed: onPressSave,
                shape: StadiumBorder(),
                elevation: 12,
              ),
            ),
            const SizedBox(width: 32),
            Container(
              width: 160,
              child: Builder(builder: (context) {
                if (saveButton == null)
                  return RawMaterialButton(
                    child: Text(
                      'START',
                      style: MyTextStyle.fetStdSize(
                        letterSpacing: 6,
                        newColor: Colors.black,
                        fontWight: FontWeight.w400,
                      ),
                    ),
                    fillColor: Color(0xff00FF5F),
                    onPressed: onPressStart,
                    shape: StadiumBorder(),
                    elevation: 12,
                  );
                else
                  return saveButton;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}