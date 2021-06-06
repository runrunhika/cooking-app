import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:genyou_app/utils/HttpIF.dart';
import 'package:genyou_app/utils/Constants.dart';
import 'package:genyou_app/utils/FileController.dart';
import 'package:genyou_app/ui/MyDialogs.dart';
import 'package:genyou_app/views/page/privacy_policy_page.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterView createState() => new _RegisterView();
}

class _RegisterView extends State<RegisterView> {
  final TextEditingController _teNickname = TextEditingController();
  final TextEditingController _teEmail = TextEditingController();
  final TextEditingController _tePassword = TextEditingController();

  Map<String, dynamic> _auth = {'name': '', 'email': '', 'password': ''};
  var _authInfoPath = '';

  Future _clickedButton(bool register) async {
    _teEmail.text = _teEmail.text.replaceAll(' ', '');
    if (register && _teNickname.text.length == 0) {
      MyDialogs.confirmDialog(context, 'エラー', 'お名前を入力してください', ['OK']);
      return;
    }
    // if (_teEmail.text.length == 8 || _tePassword.text.length == 0) {
    //   MyDialogs.confirmDialog(context, 'エラー', '生年月日・ご出身を入力してください。', ['OK']);
    //   return;
    // }

    if (_teEmail.text.length == 0 ||
        _teEmail.text.length == 1 ||
        _teEmail.text.length == 2 ||
        _teEmail.text.length == 3 ||
        _teEmail.text.length == 4 ||
        _teEmail.text.length == 5 ||
        _teEmail.text.length == 6 ||
        _teEmail.text.length == 7) {
      MyDialogs.confirmDialog(
          context, 'エラー', '生年月日を入力してください\nまた、8桁でのご入力お願いいたします', ['OK']);
      return;
    }
    if (_tePassword.text.length == 0 
        // _tePassword.text.length != '青森県' ||
        // _tePassword.text.length != '岩手県' ||
        // _tePassword.text.length != '秋田県' ||
        // _tePassword.text.length != '宮城県' ||
        // _tePassword.text.length != '山形県' ||
        // _tePassword.text.length != '福島県' ||
        // _tePassword.text.length != '茨城県' ||
        // _tePassword.text.length != '栃木県' ||
        // _tePassword.text.length != '群馬県' ||
        // _tePassword.text.length != '埼玉県' ||
        // _tePassword.text.length != '千葉県' ||
        // _tePassword.text.length != '東京都' ||
        // _tePassword.text.length != '神奈川県' ||
        // _tePassword.text.length != '新潟県' ||
        // _tePassword.text.length != '富山県' ||
        // _tePassword.text.length != '石川県' ||
        // _tePassword.text.length != '福井県' ||
        // _tePassword.text.length != '山梨県' ||
        // _tePassword.text.length != '長野県' ||
        // _tePassword.text.length != '岐阜県' ||
        // _tePassword.text.length != '静岡県' ||
        // _tePassword.text.length != '愛知県' ||
        // _tePassword.text.length != '三重県' ||
        // _tePassword.text.length != '滋賀県' ||
        // _tePassword.text.length != '京都府' ||
        // _tePassword.text.length != '大阪府' ||
        // _tePassword.text.length != '兵庫県' ||
        // _tePassword.text.length != '奈良県' ||
        // _tePassword.text.length != '和歌山県' ||
        // _tePassword.text.length != '鳥取県' ||
        // _tePassword.text.length != '島根県' ||
        // _tePassword.text.length != '岡山県' ||
        // _tePassword.text.length != '広島県' ||
        // _tePassword.text.length != '山口県' ||
        // _tePassword.text.length != '徳島県' ||
        // _tePassword.text.length != '愛媛県' ||
        // _tePassword.text.length != '高知県' ||
        // _tePassword.text.length != '福岡県' ||
        // _tePassword.text.length != '佐賀県' ||
        // _tePassword.text.length != '長崎県' ||
        // _tePassword.text.length != '熊本県' ||
        // _tePassword.text.length != '大分県' ||
        // _tePassword.text.length != '宮崎県' ||
        // _tePassword.text.length != '鹿児島県' ||
        // _tePassword.text.length != '沖縄県'
        ) {
      MyDialogs.confirmDialog(
          context, 'エラー', 'ご出身を入力してください\nまた、都や県は不要です', ['OK']);
      return;
    }

    setState(() {
      Future(() async {
        _auth['name'] = _teNickname.text;
        _auth['email'] = _teEmail.text;
        _auth['password'] = _tePassword.text;

        String url;
        if (register)
          url = Constants.kregisterURL +
              '?name=' +
              _auth['name'] +
              '&email=' +
              _auth['email'] +
              '&password=' +
              _auth['password'];
        else
          url = Constants.kloginURL +
              '?email=' +
              _auth['email'] +
              '&password=' +
              _auth['password'];

        var response = await HttpIF.get(url);
        if (response[0] == 200) {
          final s = json.encode(_auth);
          FileController.saveStringFile(s, _authInfoPath);
          if (register)
            await MyDialogs.confirmDialog(
                context, '成功', '登録完了です。\n次回から自動でログインします。', ['OK']);
          else
            await MyDialogs.confirmDialog(
                context, '成功', 'ログインしました。\n次回から自動でログインします。', ['OK']);
          Navigator.pop(context, true);
        } else {
          final s = json.encode(_auth);
          FileController.saveStringFile(s, _authInfoPath);
          if (register)
            await MyDialogs.confirmDialog(
                context, '成功', '登録完了です。\n次回から自動でログインします。', ['OK']);
          else
            await MyDialogs.confirmDialog(
                context, '成功', 'ログインしました。\n次回から自動でログインします。', ['OK']);
          Navigator.pop(context, true);
        }
        // else {
        // if (register)

        // MyDialogs.confirmDialog(context, 'エラー', 'すでに使用されているメールアドレスです。', ['OK']);
        // else
        //   MyDialogs.confirmDialog(
        //       context, 'エラー', 'メールアドレス、パスワードを確認して下さい。', ['OK']);
        // setState(() {});
        // }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Future(() async {
        _authInfoPath = await FileController.localPath + '/auth.txt';
        final auth = await FileController.readStringFile(_authInfoPath);
        if (auth != null) {
          _auth = json.decode(auth);
          _teNickname.text = _auth['name'];
          _teEmail.text = _auth['email'];
          _tePassword.text = _auth['password'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = 0.7 * MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text("ユーザー登録"),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.orangeAccent, Colors.lightBlueAccent],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft)),
              ),
              leading: Container(),
            ),
            body: SafeArea(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                //お名前フィールド
                Container(
                  width: width,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'お名前'),
                    textInputAction: TextInputAction.done,
                    controller: _teNickname,
                    enabled: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //生年月日フィールド
                Container(
                  width: width,
                  height: 60,
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '生年月日',
                          hintText: "1990年1月1日⇨19900101"),
                      textInputAction: TextInputAction.done,
                      controller: _teEmail,
                      enabled: true,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      maxLength: 8,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                //ご出身フィールド
                Container(
                  width: width,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'ご出身',
                        hintText: "広島"),
                    textInputAction: TextInputAction.done,
                    controller: _tePassword,
                    enabled: true,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                    maxLines: 1,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 180,
                      height: 40,
                      child: ButtonTheme(
                        minWidth: 100.0,
                        height: 100.0,
                        child: GestureDetector(
                          onTap: () {
                            _clickedButton(true);
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(colors: [
                                  Colors.purpleAccent,
                                  Colors.orange
                                ]),
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          Colors.purpleAccent.withOpacity(.6),
                                      spreadRadius: 1,
                                      blurRadius: 16,
                                      offset: Offset(8, 8))
                                ]),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 10),
                                  child: Icon(
                                    Icons.login,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "登録",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     _clickedButton(true);
                        //   },
                        //   child: Container(
                        //     height: 50,
                        //     width: 90,
                        //     decoration: BoxDecoration(
                        //         boxShadow: [
                        //           BoxShadow(
                        //               offset: Offset(0, 20),
                        //               blurRadius: 30,
                        //               color: Colors.black12)
                        //         ],
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(22)),
                        //     child: Row(
                        //       children: <Widget>[
                        //         Container(
                        //           height: 50,
                        //           width: 110,
                        //           child: Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 vertical: 12, horizontal: 12),
                        //             child: Text(
                        //               'スタート',
                        //               style: TextStyle(
                        //                   fontSize: 15, color: Colors.white),
                        //             ),
                        //           ),
                        //           decoration: BoxDecoration(
                        //               color: Colors.greenAccent,
                        //               borderRadius: BorderRadius.only(
                        //                   bottomLeft: Radius.circular(22),
                        //                   topLeft: Radius.circular(22),
                        //                   bottomRight: Radius.circular(200))),
                        //         ),
                        //         Icon(
                        //           Icons.person_add_alt_1_rounded,
                        //           size: 30,
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // )
                      ),
                    )),
                Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (ctx) => PPScreen()));
                    },
                    child: Text(
                      "プライバシーポリシー",
                      style: TextStyle(
                          color: Colors.lightBlue,
                          decoration: TextDecoration.underline),
                    ))
              ]),
            )));
  }
}

// _clickedButton(false);
