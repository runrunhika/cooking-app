import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:genyou_app/ui/MyDialogs.dart';
import 'package:genyou_app/StuffsWidget.dart';
import 'package:genyou_app/utils/Constants.dart';
import 'package:genyou_app/utils/HttpIF.dart';

class UploadMenuView extends StatefulWidget {
  @override
  _UploadMenuView createState() => new _UploadMenuView();
}

class _UploadMenuView extends State<UploadMenuView> {
  StuffsWidget _stuffWidget;
  var _imagePath = '';
  var _imageAvailable = false;

  final TextEditingController _teMenuNamee = TextEditingController();
  final ScrollController controller = ScrollController();

  Future _selectImage() async {
    int i = await MyDialogs.selectDialog(context, '選択してください', ["アルバム", "カメラ"]);
    if (i == null) return;

    final picker = ImagePicker();
    final image = await picker.getImage(
        source: i == 0 ? ImageSource.gallery : ImageSource.camera);
    if (image == null) return;
    _imagePath = image.path;
    _imageAvailable = true;
    setState(() {});
  }

  Future _uploadMenu() async {
    _teMenuNamee.text = _teMenuNamee.text.trimRight();
    if (_teMenuNamee.text.length == 0) {
      MyDialogs.confirmDialog(context, 'エラー', '料理名を入力してください。', ['OK']);
      return;
    }
    if (_imageAvailable == false) {
      MyDialogs.confirmDialog(context, 'エラー', '料理の写真を選択してください。', ['OK']);
      return;
    }

    if (_stuffWidget.mystuffs.length == 0) {
      MyDialogs.confirmDialog(context, 'エラー', '材料が選択されていません。', ['OK']);
      return;
    }

    var menu = _teMenuNamee.text;
    for (int i = 0; i < _stuffWidget.mystuffs.length; ++i) {
      menu += "," + _stuffWidget.mystuffs[i];
    }

    final url = Constants.kuploadMenuURL;
    if (await HttpIF.uploadFileWithString(url, menu, File(_imagePath)))
      MyDialogs.confirmDialog(context, '成功', '料理が登録されました。', ['OK']);
    else
      MyDialogs.confirmDialog(context, 'エラー', '通信エラーが発生しました。', ['OK']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    if (_stuffWidget == null) {
      _stuffWidget =
          StuffsWidget(width: 250, height: 0.25 * size, search: false);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ListView(
        controller: controller,
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: .7 * size,
              height: .4 * size,
              child: _imageAvailable
                  ? Image.memory(File(_imagePath).readAsBytesSync())
                  : Material(
                      color: Colors.grey.withOpacity(.5),
                      child: InkWell(
                        child: Icon(Icons.camera_alt_outlined, size: 100),
                        onTap: () {
                          _selectImage();
                        },
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //料理名入力
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: double.infinity,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '料理名',
                    hintText: "創作ハンバーグソルジャー"),
                textInputAction: TextInputAction.done,
                controller: _teMenuNamee,
                enabled: true,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                maxLines: 1,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //食材選択
          _stuffWidget,
          
          //画像
          // Container(
          //   height: 0.2 * size,
          //   width: 0.2 * size,
          //   child: _imageAvailable
          //       ? Image.memory(File(_imagePath).readAsBytesSync())
          //       : Container(
          //           decoration: BoxDecoration(
          //             border: Border.all(color: Colors.grey),
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          // ),
          //画像追加ボタン
          // ButtonTheme(
          //   minWidth: 100.0,
          //   height: 20.0,
          //   child: RaisedButton(
          //       child: Text(
          //         '写真',
          //       ),
          //       color: Colors.blue,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       textColor: Colors.white,
          //       onPressed: () {
          //         _selectImage();
          //       }),
          // ),

          // Expanded(child: Container()),
          //登録ボタン
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
            child: ButtonTheme(
              height: 30.0,
              child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    '登録',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    _uploadMenu();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
