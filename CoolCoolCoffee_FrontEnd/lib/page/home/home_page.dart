import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'caffeine_left.dart';
import 'drink_list.dart';
import 'clock.dart';

import '../menu/menu_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState(){
    super.initState();
    _initializeSleepParam();
  }
  Future<void> _initializeSleepParam() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime today = DateTime.now();
    String todaydate = today.toLocal().toIso8601String().split('T')[0];
    DocumentSnapshot<Map<String, dynamic>> userSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(todaydate).get();
    if(userSleepDoc.exists && userSleepDoc.data()!.containsKey('wake_time')&&userSleepDoc.data()!.containsKey('sleep_quality_score')){
      ref.watch(sleepParmaProvider.notifier).changeWakeTime(userSleepDoc['wake_time']);
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(userSleepDoc['sleep_quality_score']);
    }
  }
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
