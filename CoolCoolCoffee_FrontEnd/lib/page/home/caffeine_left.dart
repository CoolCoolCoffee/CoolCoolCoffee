import 'dart:async';
import 'dart:math';

import 'package:coolcoolcoffee_front/function/sleep_cal_functions.dart';
import 'package:coolcoolcoffee_front/page/home/graph_page.dart';
import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:fl_chart/fl_chart.dart';
//import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_caffeine.dart';

class CaffeineLeftWidget extends ConsumerStatefulWidget {
  const CaffeineLeftWidget({Key? key}) : super(key: key);

  @override
  _CaffeineLeftWidgetState createState() => _CaffeineLeftWidgetState();
}

class _CaffeineLeftWidgetState extends ConsumerState<CaffeineLeftWidget> {
  SleepCalFunc sleepCalFunc = SleepCalFunc();
  String bedTime = '';
  late Timer timer;
  bool sleepNotYet = true;
  bool temp = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _calPredictSleepTime();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _setWidget();
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
              setState(() {
                bedTime = sleepCalFunc.setPredictedBedTime(t);
                ref.watch(shortTermNotiProvider.notifier).setPredictSleepTime(bedTime);
                print('set!!! ${ref.watch(shortTermNotiProvider).predict_sleep_time}');
                print('${ref.watch(shortTermNotiProvider).goal_sleep_time}');
                ref.watch(shortTermNotiProvider.notifier).setCaffCompare();
                //여기서 이제 todayAlarm이 false 면 short term alarm 보내기
                //hour 랑 Minute 잘 생각하고 설정해야함!!!!!!!!!11
                print(bedTime);
              });
            }
          }
        }
      t+=step;
      count++;
      if(count%6 == 0) t = t.ceilToDouble();
    });
  }
  void _setWidget(){
    final provider = ref.watch(sleepParmaProvider);
    sleepNotYet = (provider.goal_sleep_time == "" ||provider.wake_time == ""|| provider.sleep_quality == -1);
    print('slleep $sleepNotYet temp $temp');
    if(temp != sleepNotYet) {
      print('temp $temp');
      setState(() {
        temp = sleepNotYet;
      });
    }
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
  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(sleepParmaProvider.notifier);

    //listen으로 바꾸는 거 고려해야할듯
    _calPredictSleepTime();
    _setWidget();
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: MediaQuery.of(context).size.width - 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: setText(sleepNotYet, bedTime),
            ),
            ElevatedButton(
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
                primary: Colors.brown,
                minimumSize: Size(5, 90),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '그래프',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget setText(bool sleepNotYet, String bedTime){
    if(sleepNotYet){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
          '수면 정보 입력을',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        SizedBox(height: 15),
        Text(
          '완료해주jj세요!',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
        )
      ],
      );
    }
    else{
      if(bedTime == ''){
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(
            '예상 jj수면 시간',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
            SizedBox(height: 15),
            Text(
              '계산중....',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            )],
        );
      }else{
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(
            '예상 jj수면 시간',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
            SizedBox(height: 15),
            Text(
              bedTime,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            )],
        );
      }
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
}
