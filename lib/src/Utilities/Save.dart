import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Save {
  static String? devicePath;
  static Future<void> init() async {
    devicePath = await _devicePath;
  }
  static void saveFile(String localPath, String data) {
    if(devicePath == null) {
      //throws error if storage is not initiated
      throw Error();
    }
    File fileRef = File('$devicePath/DreamNote/$localPath');
    fileRef.createSync(recursive: true);
    fileRef.writeAsStringSync(data);
  }
  static Future<String> get _devicePath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  static String readFile(String localPath) {
   return File('$devicePath/DreamNote/$localPath').readAsStringSync();
  }
  static bool fileExists(String localPath) {
    return File('$devicePath/DreamNote/$localPath').existsSync();
  }

}