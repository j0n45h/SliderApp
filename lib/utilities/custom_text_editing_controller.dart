import 'package:flutter/material.dart';

class CustomTextEditingController extends TextEditingController {

  @override
  set text(String newText){
    var number = int.parse(newText);
    if (number < 10)
      newText = '0' + number.toString();
    value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }
}