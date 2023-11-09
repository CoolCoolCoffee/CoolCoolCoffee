
import 'package:coolcoolcoffee_front/page/menu/menu_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'brand_list_view.dart';
import 'camera_button.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
              Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
            "음료 검색하기",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        actions: [
          FractionallySizedBox(
            heightFactor: 0.7,
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                "assets/star_unfilled_with_outer.png",
                fit: BoxFit.fill,
              ),
            ),
          )
        ],
      ),
      body:Column(
        children: [
          Container(height: 20,),
          Expanded(child: BrandListView()),
          Expanded(
            flex: 9,
            child: MenuListView(brandName: '스타벅스',)
          )
        ],
      ),
      floatingActionButton: CameraButton(),
    );
  }
}
