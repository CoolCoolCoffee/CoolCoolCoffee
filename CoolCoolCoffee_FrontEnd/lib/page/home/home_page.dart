import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../menu/menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color:Colors.cyan,
          child: ElevatedButton(onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
          },
            child: Text("음료 추가하기"),
          ),

      ),
    );
  }
}
