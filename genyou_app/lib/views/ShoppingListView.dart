import 'package:flutter/material.dart';
import 'package:genyou_app/FoodStuff.dart';

class ShoppingListView extends StatefulWidget {
  @override
  _ShoppingListView createState() => new _ShoppingListView();
}

class _ShoppingListView extends State<ShoppingListView> {
  FoodStuff _foodstuff;
  List<String> _mystuffs = [];
  List<bool> _shopping = [];

  @override
  void initState() {
    super.initState();
    Future(() async {
      _foodstuff = FoodStuff();
      await _foodstuff.init();
      _foodstuff.getSelectedStuffs(_mystuffs, _shopping);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: selectedStuff());
  }

  Widget selectedStuff() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Align(
              alignment: Alignment.center,
              child: _shopping[index]
                  ? ListTile(
                      leading: Text(_mystuffs[index],
                          style: TextStyle(color: Colors.black, fontSize: 18)),
                      trailing: Container(
                        height: 40,
                        width: 90,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '個・g',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                        ),
                      ),
                    )
                  // ? Text(_mystuffs[index],
                  //     style: TextStyle(color: Colors.black, fontSize: 18))
                  : Container(
                      height: 0,
                    ));
        },
        itemCount: _mystuffs.length);
  }
}
