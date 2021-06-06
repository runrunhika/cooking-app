import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:genyou_app/views/RegisterView.dart';
import 'package:genyou_app/views/TopView.dart';
import 'package:genyou_app/utils/FileController.dart';
import 'package:genyou_app/utils/Constants.dart';
import 'package:genyou_app/utils/HttpIF.dart';
import 'package:genyou_app/ui/Indicator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cooking App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: '私のクッキング'),
        routes: <String, WidgetBuilder>{
          '/register': (BuildContext context) => RegisterView(),
          '/cooking': (BuildContext context) => TopView(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _initialized = false;
  var _login = false;
  Map<String, dynamic> _auth = {'name': '', 'email': '', 'password': ''};

  Future _register() async {
    final result = await Navigator.pushNamed(context, '/register');
    _login = result;
    setState(() {});
  }

  Future _searchmenu() async {
    Navigator.pushNamed(context, '/cooking');
  }

  _MyHomePageState() {
    Future(() async {});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      Future(() async {
        final path = await FileController.localPath + '/auth.txt';
        final auth = await FileController.readStringFile(path);
        if (auth != null) {
          MyIndicator.showIndicator(context, IndicatorType.Circle);
          _auth = json.decode(auth);
          final url = Constants.kloginURL +
              '?email=' +
              _auth['email'] +
              '&password=' +
              _auth['password'];
          var response = await HttpIF.get(url);
          if (response[0] == 200) {
            print('OK: ' + response[1]['id'].toString());
            _login = true;
          } else {
            print('error');
          }
          Navigator.of(context).pop(); // hide indicator
        }
        _initialized = true;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ごはんの時間"),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.lightBlueAccent],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft)),
          ),
        ),
        body: SafeArea(child: Center(child: menu())));
  }

  Widget menu() {
    if (!_initialized) return Container();

    if (_login) {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text('ようこそ！　クッキングアプリへ。'),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              _searchmenu();
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: 48,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      colors: [Colors.purpleAccent, Colors.orange]),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.purpleAccent.withOpacity(.6),
                        spreadRadius: 1,
                        blurRadius: 16,
                        offset: Offset(8, 8))
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 10),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "ごはんの時間",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        )
        // RaisedButton(
        //     child:  Text('はじめる',),
        //     color: Colors.blue,
        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
        //     textColor: Colors.white,
        //     onPressed: () {_searchmenu();}),
      ]);
    } else {
      return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text('ようこそ！　クッキングアプリへ。'),
        Text('下記からユーザー登録をお願いします。'),
        SizedBox(
          height: 20,
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 180,
              height: 40,
              child: ButtonTheme(
                minWidth: 100.0,
                height: 100.0,
                child: GestureDetector(
                  onTap: () {
                    _register();
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.yellowAccent]),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.purpleAccent.withOpacity(.6),
                              spreadRadius: 1,
                              blurRadius: 16,
                              offset: Offset(8, 8))
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 10),
                          child: Icon(
                            Icons.person_add_alt_1_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "スタート",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ]);
    }
  }
}
