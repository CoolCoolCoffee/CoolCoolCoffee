
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
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: Text("음료 검색하기"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.star))
        ],
        /*bottom: IconButton(
          onPressed: () {},
          icon: Icon(Icons.star),
        ),*/
      ),
      body:BrandListView(),
      floatingActionButton: CameraButton(),
    );
  }
}