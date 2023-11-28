import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
    }else{
      ref.watch(sleepParmaProvider.notifier).changeWakeTime("");
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(-1);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown.withOpacity(0.1),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            '홈 화면',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
                    ),
        actions: [
          // 조절, 밤샘 모드 선택 토글
          Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: ToggleSwitch(
              minWidth: 50.0,
              initialLabelIndex: 0,
              cornerRadius: 10.0,
              activeFgColor: Colors.white,
              activeBgColors: [[Colors.brown.withOpacity(0.6)], const [Colors.brown]],
              inactiveFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              totalSwitches: 2,
              labels: const ['조절', '밤샘'],
              onToggle: (index) {
                print('switched to: $index');
                if(index == 0){
                  ThemeProvider.controllerOf(context).setTheme("조절모드");
                } else if(index == 1){
                  ThemeProvider.controllerOf(context).setTheme("밤샘모드");
                }
              },
            ),
          ),
        ],
        backgroundColor: Colors.white,
        toolbarHeight: 50,
        iconTheme: const IconThemeData(color: Colors.white),
    ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            ClockWidget(),
            SizedBox(height: 10),
            CaffeineLeftWidget(),
            SizedBox(height: 20),
            DrinkListWidget(),
          ],
        ),
      )
    );
  }
}
