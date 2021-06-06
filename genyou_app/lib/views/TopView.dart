import 'package:flutter/material.dart';
import 'package:genyou_app/views/CookingView.dart';
import 'package:genyou_app/views/ShoppingListView.dart';
import 'package:genyou_app/views/UploadMenuView.dart';

class TopView extends StatefulWidget {
  @override
  _TopView createState() => _TopView();
}

class _TopView extends State<TopView> {
  int _selectedIndex = 0;
  PageController _pageController;


  static List<Widget> _pageList = [
    CookingView(),
    ShoppingListView(),
    UploadMenuView(),
  ];

  static List<String> _pageTitle = [
    '食材で料理を検索',
    '買い物リスト',
    '私だけのメニューを登録',
  ];

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(_pageTitle[_selectedIndex]),
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
        body: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: _pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '検索',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: '買い物リスト',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: '私の料理',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              _selectedIndex = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            }));
  }
}
