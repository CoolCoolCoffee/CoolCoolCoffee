import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'caffeine_left.dart';
import 'drink_list.dart';
import 'clock.dart';

import '../menu/menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*@override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(sleepParmaProvider);
    });
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.withOpacity(0.1),
        appBar: AppBar(
          title: const Center(
            child: Text(
              '홈 화면',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 50,
        iconTheme: IconThemeData(color: Colors.white),
    ),
      body: Column(
        children: [
          SizedBox(height: 10),
          ClockWidget(),
          SizedBox(height: 10),
          CaffeineLeftWidget(),
          SizedBox(height: 20),
          DrinkListWidget()
        ],
      )
    );
  }
}
