import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

class Save {
  static String? devicePath;
  static Future<void> init() async {
    devicePath = await _devicePath;
  }
  static bool inited() {
    return devicePath != null;
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
  static List<FileSystemEntity> filesInFolder() {
    return Directory('$devicePath/DreamNote').listSync();
  }
  static Future<PdfDocument?> loadPDF(String localPath) async {
    PdfDocumentListenable pdfRef = PdfDocumentRefFile('$devicePath/DreamNote/$localPath').resolveListenable();
    await pdfRef.load();
    return pdfRef.document;


  }

}