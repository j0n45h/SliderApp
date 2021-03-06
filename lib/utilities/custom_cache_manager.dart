import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class CustomCacheManager extends BaseCacheManager {
  static const _addressKey = 'btDeviceAddress';
  static const _nameKey = 'btDeviceName';
  static const _TLDataKey = 'TLData';

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._() : super(_addressKey,
      maxAgeCacheObject: Duration(days: 365),
      maxNrOfCacheObjects: 5);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, _addressKey);
  }

  static storeDevice(BtDevice btDevice) async {
    try {
      await CustomCacheManager().putFile(_nameKey, Uint8List.fromList(btDevice.name.codeUnits), fileExtension: 'txt');
      await CustomCacheManager().putFile(_addressKey, Uint8List.fromList(btDevice.address.codeUnits), fileExtension: 'txt');
    } catch (e) {
      print ('not able to store devices Name in cache $e');
    }
  }

  static Future<BtDevice> getLastBtDevice() async {
    try {
      // getting file of Name
      FileInfo cachedName = await CustomCacheManager()?.getFileFromCache(_nameKey);

      if (cachedName == null || !await cachedName?.file?.exists())
        return null;

      final name = await cachedName.file.readAsString();


      // getting file of Address
      FileInfo cachedAddress = await CustomCacheManager().getFileFromCache(_addressKey);

      if (cachedAddress == null || !await cachedAddress?.file?.exists())
        return null;

      final address = await cachedAddress.file.readAsString();

      if (name == null || address == null)
        return null;

      return BtDevice(name: name, address: address);

    } catch (e) {
      print('Error on getting address of last connected device: $e');
      return null;
    }
  }

  /// TLData
  static storeTLDataAsJson(Map<String, dynamic> jsonOBJ) async {
    final jsonString = json.encode(jsonOBJ);
    try {
      await CustomCacheManager().putFile(_TLDataKey, Uint8List.fromList(jsonString.toString().codeUnits), fileExtension: 'json');
    } catch (e) {
      print ('not able to store "TLData.json" in cache $e');
    }
  }

  static Future<Map<String, dynamic>> getTLDataAsJson() async {
    try {

      // get file from cache
      FileInfo cachedFile = await CustomCacheManager()?.getFileFromCache(_TLDataKey);

      if (cachedFile == null || !await cachedFile?.file?.exists())
        return null;

      // get content of file as string
      final jsonStr = await cachedFile.file.readAsString();

      if (jsonStr == null)
        return null;

      // return json
      return json.decode(jsonStr);

    } catch (e) {
      print('Error on getting Presets from json $e');
      return null;
    }
  }
}