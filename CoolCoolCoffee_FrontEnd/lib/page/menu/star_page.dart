import 'package:coolcoolcoffee_front/page/menu/star_list_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StarPage extends StatelessWidget {
  const StarPage({super.key});

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
          '즐겨찾기',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: StarListView(),
    );
  }
}
