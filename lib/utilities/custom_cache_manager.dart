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
      /// getting Name
      FileInfo cachedName = await CustomCacheManager().getFileFromCache(_nameKey);
      cachedName.file.openRead();
      final name = cachedName.file.readAsStringSync();

      /// getting Address
      FileInfo cachedAddress = await CustomCacheManager().getFileFromCache(_addressKey);
      cachedAddress.file.openRead();
      final address = cachedAddress.file.readAsStringSync();

      return BtDevice(name: name, address: address);

    } catch (e) {
      print('no address of last connected device: $e');
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
      FileInfo cachedFile = await CustomCacheManager().getFileFromCache(_TLDataKey);

      // open file
      var stream = cachedFile.file.openRead();

      // get content of file as string
      final jsonStr = await cachedFile.file.readAsString();

      // return json
      return json.decode(jsonStr);

    } catch (e) {
      print('no json file stored in cache $e');
      return null;
    }
  }
}