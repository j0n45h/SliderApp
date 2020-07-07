import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sliderappflutter/utilities/state/bluetooth_state.dart';

class CustomCacheManager extends BaseCacheManager {
  static const _addressKey = 'btDeviceAddress';
  static const _nameKey = 'btDeviceName';

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
}