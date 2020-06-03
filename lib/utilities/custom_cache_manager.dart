import 'dart:typed_data';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CustomCacheManager extends BaseCacheManager {
  static const _key = "btDeviceAddress";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._() : super(_key,
      maxAgeCacheObject: Duration(days: 365),
      maxNrOfCacheObjects: 5);

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();
    return path.join(directory.path, _key);
  }

  static storeDeviceAddress(String newAddress) async {
    try {
      await CustomCacheManager().putFile(_key, Uint8List.fromList(newAddress.codeUnits), fileExtension: 'txt');
    } catch (e) {
      print ('not able to store devices Address in cache $e');
    }
  }

  static Future<String> getLastBtDeviceAddress() async {
    try {
      FileInfo cacheFile = await CustomCacheManager().getFileFromCache(_key);
      cacheFile.file.openRead();
      return cacheFile.file.readAsStringSync();
    } catch (e) {
      print('no address of last connected device: $e');
      return null;
    }
  }

}