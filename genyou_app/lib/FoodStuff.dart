import 'dart:async';
import 'package:genyou_app/utils/HttpIF.dart';
import 'package:genyou_app/utils/Constants.dart';

class FoodStuff {
  static final _instance = FoodStuff._internal();
  static var _initialized = false;

  List<String> foodCategory = [];
  List<List<String>> foodStuff = [];
  List<List<bool>> checked = [];
  List<List<bool>> shopping = [];
  List<List<bool>> checked2 = [];

  List<Map<String, dynamic>> foods = [];
  List<String> foodimages = [];

  factory FoodStuff() {
    return _instance;
  }

  FoodStuff._internal();

  Future<bool> init() async {
    if(_initialized) return true;

    _initialized = true;
    var response = await HttpIF.get(Constants.kmenuStuffURL);

    if (response[0] == 200) {
      final ncategory = response[1]['ncategory'];
      final stuffs = response[1]['stuffs'];
      for (int i=0; i<ncategory; ++i) {
        foodCategory.add(stuffs[i]['category']);
        foodStuff.add([]);
        for (int j=1; j<=32; ++j) {
          var stuff = stuffs[i]['stuff$j'];
          if (stuff == '') break;
          foodStuff[i].add(stuff);
        }
      }
      initCheckStatus();
      return true;
    } else {
      print('error');
      return false;
    }
  }

  void initCheckStatus() {
    int n = foodCategory.length;
    for (int category=0; category<n; ++category) {
      checked.add([]);
      shopping.add([]);
      checked2.add([]);

      int nstuff = foodStuff[category].length;
      for (int i=0; i<nstuff; ++i) {
        checked[category].add((false));
        shopping[category].add((false));
        checked2[category].add((false));
      }
    }
  }

  void getSelectedStuffs(List<String> stuff, List<bool>shoppingchecked) {
    if (stuff.length != 0) stuff.removeRange(0, stuff.length);
    if (shoppingchecked.length != 0) shoppingchecked.removeRange(0, shoppingchecked.length);

    for (int i=0; i<checked.length; ++i) {
      for (int j=0; j<checked[i].length; ++j) {
        if (checked[i][j]) {
          stuff.add(foodStuff[i][j]);
          shoppingchecked.add(shopping[i][j]);
        } else {
          shopping[i][j] = false;
        }
      }
    }
  }

  void getSelectedStuffsOnly(List<String> stuff) {
    if (stuff.length != 0) stuff.removeRange(0, stuff.length);

    for (int i=0; i<checked2.length; ++i) {
      for (int j=0; j<checked2[i].length; ++j) {
        if (checked2[i][j]) {
          stuff.add(foodStuff[i][j]);
        }
      }
    }
  }

  void checkShopping(int idx, bool status) {
    var cur = 0;
    for (int i=0; i<checked.length; ++i) {
      for (int j=0; j<checked[i].length; ++j) {
        if (checked[i][j]) {
           if(cur == idx) {
             shopping[i][j] = status;
             break;
           }
           ++cur;
        }
      }
    }
  }
}