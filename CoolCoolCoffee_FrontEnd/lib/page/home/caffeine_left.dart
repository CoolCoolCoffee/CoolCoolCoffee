import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/function/sleep_cal_functions.dart';
import 'package:coolcoolcoffee_front/model/sleep_param.dart';
import 'package:coolcoolcoffee_front/page/home/graph_page.dart';
import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../function/mode_color.dart';
import '../../model/user_caffeine.dart';
import '../../provider/color_mode_provider.dart';
import '../../service/user_caffeine_service.dart';

class CaffeineLeftWidget extends ConsumerStatefulWidget {
  final dynamic snapshots;
  const CaffeineLeftWidget({Key? key, required this.snapshots}) : super(key: key);

  @override
  _CaffeineLeftWidgetState createState() => _CaffeineLeftWidgetState();
}

class _CaffeineLeftWidgetState extends ConsumerState<CaffeineLeftWidget> {
  SleepCalFunc sleepCalFunc = SleepCalFunc();
  String bedTime = '';
  late Timer timer;
  bool sleepNotYet = true;
  bool temp = false;
  late SleepParam provider;
  late dynamic snapshots;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_calPredictSleepTime();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _getSleepEnteredTime();
      //_setWidget();
    });
    _initializeSleepParam();
  }

  Future<void> _getSleepEnteredTime() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userDoc.exists && userDoc.data()!.containsKey('goal_sleep_time')) {
        String storedTime = userDoc['goal_sleep_time'];
        List<String> timeComponents = storedTime.split(':');
        int hours = int.parse(timeComponents[0]);
        String minutes = timeComponents[1];

        String amPm = (hours >= 12) ? 'PM' : 'AM';

        if (hours > 12) {
          hours -= 12;
        }

        String formattedTime = '$hours:$minutes $amPm';

        ref.watch(sleepParmaProvider.notifier).changeGoalSleepTime(formattedTime);
        ref.watch(shortTermNotiProvider.notifier).setGoalSleepTime(formattedTime);
        ref.watch(sleepParmaProvider.notifier).changeTw(userDoc['tw']);
        ref.watch(sleepParmaProvider.notifier).changeHalfTime(userDoc['caffeine_half_life']);
      } else {
        print('error1');
      }
    } catch (e) {
      print('error2 : $e');
    }
    setState(() {
      _calPredictSleepTime();
      if(ref.watch(sleepParmaProvider).goal_sleep_time !=''&& ref.watch(shortTermNotiProvider).predict_sleep_time!=''){
        _calRecommendCaff();
      }
    });
  }
  void _calPredictSleepTime(){
    double t = 0;
    double step = 0.1666666;
    double h1 = 0.75;
    double h2 = 0.2469;
    double a = 0.09478;
    int count = 0;
    int predict = 0;
    double minus = 0;

    timer = Timer.periodic(const Duration(milliseconds: 5), (timer) {
      if(t>40) {
        timer.cancel();
      }
      if(calSleepGraph(t) != -1) {
        minus = 100 *(h1 + a * sin(2 * pi * sleepCalFunc.timeMap(t))) - calSleepGraph(t);
        if(predict == 0 && minus < 0) {
          predict++;
        }
        if(predict == 1){
          predict = 2;
          if(bedTime != sleepCalFunc.setPredictedBedTime(t)){
            bedTime = sleepCalFunc.setPredictedBedTime(t);
            ref.watch(shortTermNotiProvider.notifier).setPredictSleepTime(bedTime);
            print('set!!! ${ref.watch(shortTermNotiProvider).predict_sleep_time}');
            print('${ref.watch(shortTermNotiProvider).goal_sleep_time}');
            ref.watch(shortTermNotiProvider.notifier).setCaffCompare(ref.watch(sleepParmaProvider).caff_list.length);
            _updateFirestore();
            _setWidget();
            //여기서 이제 todayAlarm이 false 면 short term alarm 보내기
            //hour 랑 Minute 잘 생각하고 설정해야함!!!!!!!!!11
            print('잘 시간이다 임마 $bedTime');
            print('잘자라 ${ref.watch(shortTermNotiProvider).predict_sleep_time}');
          }
        }
      }
      t+=step;
      count++;
      if(count%6 == 0) t = t.ceilToDouble();
    });
  }
  void _calRecommendCaff(){
    double h1 = 0.75;
    double h2 = 0.2469;
    double a = 0.09478;
    double step = 0.1666666;
    String goal_time = ref.watch(sleepParmaProvider).goal_sleep_time;
    //goal 이랑 predict 모두 AM , PM 형태임
    //am이면 24더해야함 -> 새벽 2시 26시간
    double goal_time_double = 0;
    String predict_time = ref.watch(shortTermNotiProvider).predict_sleep_time;
    double predict_time_double = 0;
    print('$goal_time !!!!!!!!! $predict_time');
    if(goal_time.contains('AM')){
      var arr = goal_time.split(' ');
      var hour_min = arr[0].split(':');
      double hour = double.parse(hour_min[0])+24;
      double min = (int.parse(hour_min[1])/10) * step;
      goal_time_double = hour+min;
    }else{
      var arr = goal_time.split(' ');
      var hour_min = arr[0].split(':');
      double hour = double.parse(hour_min[0])+12;
      double min = (int.parse(hour_min[1])~/10) * step;
      goal_time_double = hour+min;
    }
    if(predict_time.contains('AM')){
      var arr = predict_time.split(' ');
      var hour_min = arr[0].split(':');
      double hour = double.parse(hour_min[0])+24;
      double min = (int.parse(hour_min[1])/10) * step;
      predict_time_double = hour+min;
    }else{
      var arr = predict_time.split(' ');
      var hour_min = arr[0].split(':');
      double hour = double.parse(hour_min[0])+12;
      double min = (int.parse(hour_min[1])~/10) * step;
      predict_time_double = hour+min;
    }

    if(goal_time_double - predict_time_double>=0){
      DateTime dt = DateTime.now();
      int hour = dt.hour;
      int minute = dt.minute;
      double min_scale = minute~/10 * step;
      if(hour < 12){
        hour+=24;
      }
      double now = hour + min_scale;
      print('recomment = $goal_time : $goal_time_double, $dt : $now');
      int recommend = sleepCalFunc.calRecommend(calSleepGraph(goal_time_double), 100 *(h1 + a * sin(2 * pi * sleepCalFunc.timeMap(goal_time_double))), now, goal_time_double, ref.watch(sleepParmaProvider).half_time);
      ref.watch(sleepParmaProvider.notifier).changeRecommendCaff(recommend);
      print('recommend : ${ref.watch(sleepParmaProvider).recommendCaff}');
    }
    else{
      ref.watch(sleepParmaProvider.notifier).changeRecommendCaff(0);
      print('닌 커피 마시지 마라');
    }
  }
  void _setWidget(){
    final provider = ref.watch(sleepParmaProvider);
    sleepNotYet = (provider.goal_sleep_time == "" ||provider.wake_time == ""|| provider.sleep_quality == -1);
    setState(() { bedTime = ref.watch(shortTermNotiProvider).predict_sleep_time;});
  }
  Future<void> _initializeSleepParam() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime today = DateTime.now();
    String todaydate = today.toLocal().toIso8601String().split('T')[0];
    DateTime yesterday = today.subtract(Duration(days: 1));
    String yesterdaydate = yesterday.toLocal().toIso8601String().split('T')[0];

    DocumentSnapshot<Map<String, dynamic>> userSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(todaydate).get();

    DocumentSnapshot<Map<String, dynamic>> yesUserSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(yesterdaydate).get();
    //오늘의 수면 정보 받아오기
    bool isToday = userSleepDoc.exists && userSleepDoc.data()!.containsKey('wake_time')&&userSleepDoc.data()!.containsKey('sleep_quality_score');
    bool isYesterday = yesUserSleepDoc.exists&&yesUserSleepDoc.data()!.containsKey('wake_time')&&yesUserSleepDoc.data()!.containsKey('sleep_quality_score');

    if(isToday){
      ref.watch(sleepParmaProvider.notifier).changeWakeTime(userSleepDoc['wake_time']);
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(userSleepDoc['sleep_quality_score']);
    }
    //오늘 꺼가 없으면 어제꺼로
    else if(isYesterday){
      ref.watch(sleepParmaProvider.notifier).changeWakeTime(yesUserSleepDoc['wake_time']);
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(yesUserSleepDoc['sleep_quality_score']);
    }
    else{
      ref.watch(sleepParmaProvider.notifier).changeWakeTime("");
      ref.watch(sleepParmaProvider.notifier).changeSleepQuality(-1);
    }
    setState(() {
      _calPredictSleepTime();
    });
  }
  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(sleepParmaProvider.notifier);

    _calPredictSleepTime();
    if(ref.watch(sleepParmaProvider).goal_sleep_time !=''&& ref.watch(shortTermNotiProvider).predict_sleep_time!=''){
      _calRecommendCaff();
    }
    //listen으로 바꾸는 거 고려해야할듯
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.9,
              height: 100,
              decoration: BoxDecoration(
                color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['white_color']:modeColor.noSleepModeColor['light_brown_color'],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                      child: setText(sleepNotYet, bedTime),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    width: 90,
                    height: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        if(prov.state.goal_sleep_time == ""){
                          _showGoalSleepTimeUpdatePopup(context);
                        }else if(prov.state.wake_time == ""|| prov.state.sleep_quality == -1) {
                          _showSleepDataUpdatePopup(context);
                        }else{
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>GraphPage(bedTime: bedTime,)));
                        }
                        // 버튼을 누르면 팝업 창 표시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.trending_up,
                            color: Colors.white,
                            size: 28,
                          ),
                          SizedBox(width: 5),
                          Text(
                            '그래프',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
  double calSleepGraph(double t){
    double h2 = 0.2469;
    double a = 0.09478;
    double tired_scale = 0.01;
    double ret = -1;

    var prov = ref.watch(sleepParmaProvider.notifier);
    var tiredness = prov.state.sleep_quality * tired_scale;
    var user_wake_time = sleepCalFunc.formatTime(prov.state.wake_time);
    var tw = prov.state.tw;
    var half_time = prov.state.half_time;
    var caff_list = sleepCalFunc.formatCaff(prov.state.caff_list);
    var user_t0 = sleepCalFunc.timeMap(user_wake_time);

    double caff_threshold = 50 * 0.0012;
    double caff = 0;
    if(t<user_wake_time) return ret;

    var user_wake_h_graph = h2 + a * sin(2 * pi * sleepCalFunc.timeMap(user_wake_time));
    var r_t = (sleepCalFunc.timeMap(t) - user_t0);
    if(r_t<0) r_t+=1;
    for(var key in caff_list.keys){
      caff += double.parse(sleepCalFunc.calCaff(caff_list[key]!, key, t, half_time.toDouble()).toStringAsFixed(8));
    }
    if(caff <=caff_threshold) {
      ret = 1-(1-user_wake_h_graph)*exp(-r_t/tw) +tiredness;
    } else {
      ret = 1-(1-user_wake_h_graph)*exp(-r_t/tw) +tiredness - caff;
    }
    ret = ret*100;
    double minus = 100 *(0.75 + a * sin(2 * pi * sleepCalFunc.timeMap(t))) - ret;
    return ret;
  }
  Widget setText(bool sleepNotYet, String bedTime){
    if(sleepNotYet){
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '수면 정보를',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 15),
          Text(
            '입력해주세요!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          )
        ],
      );
    }
    if(bedTime == ''){
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(
          '예상 수면 시간',
          style: TextStyle(
            color: Colors.black,
            fontSize: 28.0,
          ),
        ),
          SizedBox(height: 5),
          Text(
            '계산중....',
            style: TextStyle(
              color: Colors.black,
              fontSize: 28.0,
            ),
          )],
      );
    }else{
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(
          '예상 수면 시간',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22.0,
          ),
        ),
          SizedBox(height: 5),
          Text(
            bedTime,
            style: TextStyle(
              color: Colors.black,
              fontSize: 26.0,
              fontWeight: FontWeight.bold,
            ),
          )],
      );
    }
  }
  void _showGoalSleepTimeUpdatePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
          content: const Text("목표 수면 시간을 설정해주세요!"),
          insetPadding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
  void _showSleepDataUpdatePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((10.0))),
          content: const Text("오늘의 수면 정보를 업데이트 해주세요!"),
          insetPadding: const EdgeInsets.fromLTRB(10, 100, 10, 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _updateFirestore() async {
    String temp = ref.watch(shortTermNotiProvider).predict_sleep_time;
    String predict_sleep_time = '';
    if(temp.contains('AM')){
      temp = temp.split(' ')[0];
      int hour = int.parse(temp.split(':')[0]);
      int minute = int.parse(temp.split(':')[1]);
      //자정인거임
      if(hour ==12){
        hour-=12;
      }
      predict_sleep_time = '$hour:$minute';
    }else{
      temp = temp.split(' ')[0];
      int hour = int.parse(temp.split(':')[0]);
      int minute = int.parse(temp.split(':')[1]);
      hour+=12;
      predict_sleep_time = '$hour:$minute';
    }
    String today = DateTime.now().toLocal().toIso8601String().split('T')[0];
    String yesterday = DateTime.now().subtract(Duration(days: 1)).toLocal().toIso8601String().split('T')[0];
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot<Map<String, dynamic>> userSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(today).get();

    DocumentSnapshot<Map<String, dynamic>> yesUserSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(yesterday).get();
    bool isToday = userSleepDoc.exists && userSleepDoc.data()!.containsKey('wake_time')&&userSleepDoc.data()!.containsKey('sleep_quality_score');
    if(isToday){
      await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(today).set(
          {'predict_sleep_time': predict_sleep_time}, SetOptions(merge: true)
      );
    }else{
      if(yesUserSleepDoc.exists){
        await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(yesterday).set(
            {'predict_sleep_time': predict_sleep_time}, SetOptions(merge: true)
        );
      }
    }
    //print("sssssssssssssss $currentDate");
  }
}
