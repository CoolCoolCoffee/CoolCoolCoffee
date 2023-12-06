import 'package:coolcoolcoffee_front/page/my_page/my_page.dart';
import 'package:coolcoolcoffee_front/page/recommend/recommend_page.dart';
import 'package:coolcoolcoffee_front/page/sleep/sleep_page.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../page/home/home_page.dart';

class PageStates extends StatefulWidget {
  final int index;
  const PageStates({super.key,required this.index});

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
  void initState(){
    super.initState();
    _onItemTapped(widget.index);
    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(sleepParmaProvider);
    });*/
  }
  @override
  Widget build(BuildContext context) {
   // ref.listen(sleepParmaProvider, (previous, next) {print('previous : $previous next : $next'); });
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xff93796A),
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