import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sliderappflutter/utilities/text_style.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController textController;
  final String unit;
  final String labelText;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onChanged;
  final VoidCallback onTap;
  final ValueChanged<String> onSubmitted;
  final bool enabled;
  final double fontSize;

  MyTextField({
    @required this.textController,
    this.unit,
    this.labelText,
    this.onChanged,
    this.onEditingComplete,
    this.onTap,
    this.onSubmitted,
    this.enabled = true,
    this.fontSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      onTap: onTap,
      onSubmitted: (sub) {
        FocusScope.of(context).requestFocus(new FocusNode());
        onSubmitted(sub);
      },
      style: MyTextStyle.fet(fontSize: fontSize),
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      cursorColor: Colors.white,
      cursorWidth: 1,
      maxLines: 1,
      autocorrect: false,
      enabled: enabled,
      selectionHeightStyle: BoxHeightStyle.tight,
      selectionWidthStyle: BoxWidthStyle.tight,
      decoration: _decoration(),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      suffixStyle: MyTextStyle.normal(fontSize: fontSize),
      suffixText: unit,
      border: InputBorder.none,
    );
  }

}
