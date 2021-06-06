import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class FileController {

  static Future get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future get tempPath async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  static Future get uniquePath async {
    DateTime now = DateTime.now();
    return DateFormat('yyyy-MM-dd–kk:mm:ss').format(now);
  }

  static Future saveLocalImage(File src, File dst) async {
    var savedFile = await dst.writeAsBytes(await src.readAsBytes());
    return savedFile;
  }

  static Future copyAssetToFile(String asset, File dst) async {
    final data = await rootBundle.load(asset);
    List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await dst.writeAsBytes(bytes);
  }

  static Future removeFile(String path) async {
    if (File(path).existsSync() == true) {
      File(path).deleteSync();
    }
  }

  static List<File> getFiles(String dir)  {
    var files = Directory(dir).listSync().toList();
    return files.cast();
  }

  static saveStringFile(String s, String path) async {
    File(path).writeAsString(s);
  }

  static Future<String> readStringFile(String path) async {
    final file = File(path);
    if (file.existsSync())
      return await File(path).readAsString();
    else
      return null;
  }
}