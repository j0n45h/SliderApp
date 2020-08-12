import 'dart:convert';
import 'package:sliderappflutter/utilities/json_handling/json_class.dart';

class TestJson {
  static read(String jsonFile) async {
    // print(jsonFile);
    var parsedJson = json.decode(jsonFile);

    if (parsedJson == null) return;
    // print(parsedJson.toString());

    var tlData = TLData();
    // tlData.fromJson(parsedJson);
    await tlData.getFromCache();
    print(tlData.linearTL.length);
    // tlData.saveToCache();
  }
}
