import 'package:flutter/material.dart';
import 'package:genyou_app/utils/FileController.dart';
import 'package:genyou_app/utils/Constants.dart';
import 'package:genyou_app/utils/HttpIF.dart';
import 'package:genyou_app/ui/MyDialogs.dart';
import 'package:genyou_app/MenuDisplayWidget.dart';
import 'package:genyou_app/ui/Indicator.dart';
import 'package:genyou_app/StuffsWidget.dart';
import 'package:genyou_app/CurrentInfo.dart';

class CookingView extends StatefulWidget {
  @override
  _CookingView createState() => new _CookingView();
}

class _CookingView extends State<CookingView> {
  StuffsWidget _stuffWidget;
  CurrentInfo _currentInfo = CurrentInfo();

  Future _clickedButton() async {
    if (_stuffWidget.mystuffs.length == 0) {
      MyDialogs.confirmDialog(context, 'エラー', '冷蔵庫にある　または、仕入れ予定の材料を選択してください', ['OK']);
      return;
    }

    var menu = '?keys=';
    for (int i = 0; i < _stuffWidget.mystuffs.length; ++i) {
      if (i != 0) menu += ',';
      menu += _stuffWidget.mystuffs[i];
    }

    // MyIndicator.showIndicator(context, IndicatorType.Circle);

    final url = Constants.ksearchMenuURL + menu;
    var response = await HttpIF.get(url);
    if (response[0] == 200) {
      final n = response[1]['hits'];
      if (n == 0) {
        MyDialogs.confirmDialog(context, 'エラー', '該当する料理が見つかりませんでした。', ['OK']);
        return;
      }
      if (_currentInfo.foods.length != 0) {
        _currentInfo.foods.removeRange(0, _currentInfo.foods.length);
        _currentInfo.foodimages.removeRange(0, _currentInfo.foods.length);
      }
      for (int i = 0; i < n; ++i) {
        _currentInfo.foods.add(response[1][i.toString()]);
        final url =
            Constants.kDomain + 'storage/' + _currentInfo.foods[i]['image'];
        final path = await FileController.tempPath + 'img$i';
        await HttpIF.downFileToPath(url, path);
        _currentInfo.foodimages.add(path);
      }
    } else {
      MyDialogs.confirmDialog(context, 'エラー', '通信エラーです。再度、試してください。', ['OK']);
    }
    //検索ボタンを押したら、TopViewに戻る
    // Navigator.of(context).pop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.height;
    if (_stuffWidget == null) {
      _stuffWidget =
          StuffsWidget(width: 250, height: 0.25 * size, search: true);
    }
    return Container(
      child: Column(
        children: <Widget>[
          // SizedBox(
          //   height: 20,
          // ),
          //食材選択
          _stuffWidget,
          Align(
            alignment: Alignment.center,
            // child: TextButton(
            //     child: Text(
            //       '検索',
            //       style: TextStyle(color: Colors.white),
            //     ),
            //     style: TextButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     onPressed: () {
            //       _clickedButton();
            //     }),

            //検索ボタン
            child: InkWell(
              onTap: () {
                _clickedButton();
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 20),
                          blurRadius: 30,
                          color: Colors.black12)
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 110,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        child: Text(
                          '検索',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(22),
                              topLeft: Radius.circular(22),
                              bottomRight: Radius.circular(200))),
                    ),
                    Icon(
                      Icons.search,
                      size: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          //料理検索結果
          Expanded(
              child: Container(
            width: 300,
            decoration: BoxDecoration(
              //border: Border.all(color: Colors.red, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: _currentInfo.foods.length != 0
                ? ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return MenuDisplayWidget(
                          width: 300,
                          height: 200,
                          name: _currentInfo.foods[index]['menu'],
                          stuffs: _currentInfo.foods[index]['stuff'],
                          imgpath: _currentInfo.foodimages[index],
                          mystuffs: _stuffWidget.mystuffs);
                    },
                    itemCount: _currentInfo.foods.length)
                : Container(),
          ))
        ],
      ),
    );
  }
}
