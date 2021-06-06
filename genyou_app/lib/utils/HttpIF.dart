import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:async/async.dart';

class HttpIF {
  static Future<List> get(String url) async {
    final response =
        await http.get(Uri.parse(url));
    final code = response.statusCode;
    final jsonResponse = code == 200 ? json.decode(response.body) : null;
    return [code, jsonResponse];
  }

  static Future downFileToPath(String url, String path) async {
    var response =
        await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      File(path).writeAsBytesSync(response.bodyBytes);
      return true;
    } else {
      print('error');
      return false;
    }
  }

  static Future uploadFile(String url, int myid, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['id'] = '$myid';

    var stream = new http.ByteStream(DelegatingStream(file.openRead()));
    var length = await file.length();
    var multipartFile =
        http.MultipartFile('file', stream, length, filename: 'name');
    request.files.add(multipartFile);

    var response = await request.send();
    return response.statusCode == 200 ? true : false;
  }

  static Future uploadFileWithString(String url, String str, File file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.fields['message'] = str;

    var stream = new http.ByteStream(DelegatingStream(file.openRead()));
    var length = await file.length();
    var multipartFile =
        http.MultipartFile('file', stream, length, filename: 'name');
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    } else {
      print('error: ' + response.statusCode.toString());
      return false;
    }
  }
}
