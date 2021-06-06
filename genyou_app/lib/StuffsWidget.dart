import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:genyou_app/FoodStuff.dart';
import 'package:genyou_app/ui/MyDialogs.dart';

import 'data/data.dart';

class StuffsWidget extends StatefulWidget {
  final double width;
  final double height;
  final bool search;
  final List<String> mystuffs = [];
  final List<bool> shopping = [];

  StuffsWidget({Key key, this.width, this.height, this.search})
      : super(key: key);

  @override
  _StuffsWidget createState() => _StuffsWidget();
}

class _StuffsWidget extends State<StuffsWidget> {
  PageController pageController;
  double pageOffset = 0;

  FoodStuff _foodstuff;

  void _menuSelected(int n) async {
    if (widget.search)
      await MyDialogs.chkboxDialog(context, _foodstuff.foodCategory[n],
          _foodstuff.foodStuff[n], _foodstuff.checked[n]);
    else
      await MyDialogs.chkboxDialog(context, _foodstuff.foodCategory[n],
          _foodstuff.foodStuff[n], _foodstuff.checked2[n]);

    if (widget.search)
      _foodstuff.getSelectedStuffs(widget.mystuffs, widget.shopping);
    else
      _foodstuff.getSelectedStuffsOnly(widget.mystuffs);
    setState(() {});
  }

  void _shoppingCheck(int n, bool val) {
    widget.shopping[n] = val;
    _foodstuff.checkShopping(n, val);
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      _foodstuff = FoodStuff();
      await _foodstuff.init();
      if (widget.search)
        _foodstuff.getSelectedStuffs(widget.mystuffs, widget.shopping);
      else
        _foodstuff.getSelectedStuffsOnly(widget.mystuffs);
      setState(() {});
    });

    pageController = PageController(viewportFraction: 0.7);
    pageController.addListener(() {
      setState(() {
        pageOffset = pageController.page;
      });
    });
  }

  // @override
  // Widget build(BuildContext context) => Container(
  //       width: widget.width,
  //       height: widget.height,
  //       child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
  //         Text(
  //           '食材',
  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //         ),
  //         SizedBox(
  //           height: 5,
  //         ),
  //         Row(children: <Widget>[
  //           Container(
  //               width: 0.6 * widget.width,
  //               height: widget.height - 40,
  //               decoration: BoxDecoration(
  //                 border: Border.all(color: Colors.grey),
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               child: _foodstuff != null ? selectedStuff() : Container()),
  //           SizedBox(
  //             width: 0.05 * widget.width,
  //           ),
  //           Container(
  //               width: 0.35 * widget.width,
  //               height: widget.height - 40,
  //               child: _foodstuff != null
  //                   ? makeListMenu(_foodstuff.foodCategory)
  //                   : Container())
  //         ]),
  //       ]),
  //     );

  @override
  Widget build(BuildContext context) => Container(
        // width: widget.width,
        // height: widget.height,
        width: double.infinity,
        height: 2 * widget.height,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
              width: 1.5 * widget.width,
              height: widget.height - 40,
              child: _foodstuff != null
                  ? makeListMenu(_foodstuff.foodCategory)
                  : Container()),
          SizedBox(
            height: 10,
          ),
          Container(
              width: 1.2 * widget.width,
              height: widget.height - 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _foodstuff != null ? selectedStuff() : Container()),
        ]),
      );

  //食材選択
  Widget selectedStuff() {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return widget.search
              ? Row(children: <Widget>[
                  Container(
                    height: 35,
                    child: Row(
                      children: <Widget>[
                        //食材名選択
                        Checkbox(
                          value: widget.shopping[index],
                          onChanged: (bool value) {
                            setState(() {
                              _shoppingCheck(index, value);
                            });
                          },
                        ),
                        Container(
                          width: 0,
                        ),
                        Text(widget.mystuffs[index],
                            style:
                                TextStyle(color: Colors.black, fontSize: 16)),
                      ],
                    ),
                  )
                ])
              : Align(
                  alignment: Alignment.center,
                  child: Text(widget.mystuffs[index],
                      style: TextStyle(color: Colors.black, fontSize: 16)));
        },
        itemCount: widget.mystuffs.length);
  }

//versionA
  // Widget makeListMenu(List<String> items) {
  //   return ListView.builder(
  //       itemBuilder: (BuildContext context, int index) {
  //         return GestureDetector(
  //             child: menuItem(items[index]),
  //             onTap: () {
  //               _menuSelected(index);
  //             });
  //       },
  //       itemCount: items.length);
  // }

//versionB
  // Widget makeListMenu(List<String> items) {
  //   return Container(
  //     child: PageView.builder(
  //         controller: pageController,
  //         itemBuilder: (context, index) {
  //           return Transform.scale(
  //             scale: 1,
  //             child: Container(
  //               padding: EdgeInsets.only(right: 20),
  //               child: Stack(
  //                 children: [
  //                   ClipRRect(
  //                     borderRadius: BorderRadius.circular(15),
  //                     child: Image.asset(
  //                       stuffImage[index]['image'],
  //                       width: widget.width,
  //                       height: 370,
  //                       fit: BoxFit.cover,
  //                       alignment: Alignment(-pageOffset.abs() + index, 0),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     left: 10,
  //                     bottom: 20,
  //                     right: 10,
  //                     child: GestureDetector(
  //                         child: menuItem(items[index]),
  //                         onTap: () {
  //                           _menuSelected(index);
  //                         }),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //         itemCount: items.length),
  //   );
  // }

//version3
  Widget makeListMenu(List<String> items) {
    return Container(
      child: Swiper(
        viewportFraction: .6,
        scale: .5,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _menuSelected(index);
            },
            child: Container(
              padding: EdgeInsets.only(right: 20),
              child: Stack(children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    stuffImage[index]['image'],
                    width: widget.width,
                    height: 370,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: 10,
                  bottom: 20,
                  right: 10,
                  child: menuItem(items[index]),
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  //肉・魚　...
  Widget menuItem(String title) {
    return Container(
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 34.0),
            )));
  }
}
