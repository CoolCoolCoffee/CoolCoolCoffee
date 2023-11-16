import 'package:coolcoolcoffee_front/page/my_page/my_page.dart';
import 'package:coolcoolcoffee_front/page/recommend/recommend_page.dart';
import 'package:coolcoolcoffee_front/page/sleep/sleep_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../page/home/home_page.dart';

class PageStates extends StatefulWidget {
  const PageStates({Key? key}) : super(key: key);

  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<PageStates> {
  int _selectedIndex = 0;

  List<Widget> pages = <Widget>[
    HomePage(),
    SleepPage(),
    RecommendPage(),
    MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: '홈'),
          const BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: '캘린더'),
          const BottomNavigationBarItem(icon: Icon(Icons.recommend), label: '음료 추천'),
          const BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}