import 'package:coolcoolcoffee_front/notification/notification_global.dart';
import 'package:coolcoolcoffee_front/page/home/longterm_popup_A.dart';
import 'package:coolcoolcoffee_front/provider/long_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:coolcoolcoffee_front/service/user_sleep_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../provider/sleep_param_provider.dart';
import '../home/longterm_popup_B.dart';

class SleepInfoWidget extends ConsumerStatefulWidget {
  final DateTime selectedDay;
  final String? sleepTime;
  final String? wakeTime;
  const SleepInfoWidget({Key? key, required this.selectedDay,this.sleepTime, this.wakeTime,}) : super(key: key);

  @override
  _SleepInfoWidgetState createState() => _SleepInfoWidgetState();
}

class _SleepInfoWidgetState extends ConsumerState<SleepInfoWidget> {
  final UserSleepService _userSleepService = UserSleepService();
  String resultText_start_real = '';
  String resultText_end_real = '';
  DateTime today = DateTime.now();
  String selecteddate = '';
  String todaydate = '';
  String today_wake_time = '';
  String today_sleep_time = '';

  @override
  void initState() {
    super.initState();
    // 값이 없는 경우에만 초기화
    if (today_wake_time.isEmpty || today_sleep_time.isEmpty) {
      _fetchSleepTimeAndUpdateState();
    }
  }

  List<HealthConnectDataType> types = [HealthConnectDataType.SleepSession];

  @override
  Widget build(BuildContext context) {
    String selecteddate = widget.selectedDay!.toLocal().toIso8601String().split('T')[0];
    String todaydate = today.toLocal().toIso8601String().split('T')[0];
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(right:5),
                  child: Text(
                    selecteddate == todaydate
                        ? '오늘의 수면정보'
                        : '$selecteddate의 수면 정보',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        //_fetchSleepTimeAndUpdateState();
                        tz.initializeTimeZones();
                        var startTime = widget.selectedDay.subtract(const Duration(days: 1));
                        var endTime = widget.selectedDay;
                        try {
                          final requests = <Future>[];
                          Map<String, dynamic> typePoints = {};
                          for (var type in types) {
                            requests.add(
                              HealthConnectFactory.getRecord(
                                type: type,
                                startTime: startTime,
                                endTime: endTime,
                              ).then(
                                    (value) => typePoints.addAll({type.name: value}),
                              ),
                            );
                          }
                          await Future.wait(requests);
                          final resultText = '$typePoints';

                          final startTimeEpochSecond_start =
                          typePoints['SleepSession']['records'][0]['startTime']['epochSecond'];
                          final seoul = getLocation('Asia/Seoul');
                          final resultText_start = TZDateTime.fromMillisecondsSinceEpoch(
                            seoul,
                            startTimeEpochSecond_start * 1000,
                          );

                          final startTimeEpochSecond_end =
                          typePoints['SleepSession']['records'][0]['endTime']['epochSecond'];
                          final resultText_end = TZDateTime.fromMillisecondsSinceEpoch(
                            seoul,
                            startTimeEpochSecond_end * 1000,
                          );

                          final formatter = DateFormat('h:mm a');
                          resultText_start_real = formatter.format(resultText_start);
                          today_sleep_time=resultText_start_real;

                          resultText_end_real = formatter.format(resultText_end);
                          today_wake_time=resultText_end_real;
                          ref.watch(shortTermNotiProvider.notifier).resetTodayAlarm();
                          _showConfirmationDialog_get_auto();
                        } catch (e) {
                          print(e.toString());
                          _showConfirmationDialog_get_auto_fail();
                        }
                        _updateResultText();
                        _updateFirestore();
                        _updateLongTerm(today_sleep_time);
                        print(resultText_start_real);
                        print(resultText_end_real);
                        ref.watch(shortTermNotiProvider.notifier).resetCaffCompare();
                        ref.watch(shortTermNotiProvider.notifier).resetTodayAlarm();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        primary: selecteddate == todaydate ? Colors.brown : Colors.white,
                        shape: selecteddate == todaydate
                            ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        )
                            : null, // Set shape to null if it's not today's date
                        elevation: selecteddate == todaydate ? 3 : 0,
                      ),
                      child: Text(selecteddate == todaydate ? '가져오기' : '', style: const TextStyle(color: Color(0xffF9F8F7)),),
                    ),
                    SizedBox(width: 10,),
                    if (selecteddate == todaydate)
                      ElevatedButton(
                        onPressed: () async {
                          _showManualInputPopup(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.brown,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 3,
                        ),
                        child: Text('입력', style: TextStyle(color: Color(0xffF9F8F7)),),
                      ),
                  ],
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown,
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '취침시간',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        selecteddate == todaydate ? today_sleep_time : widget.sleepTime ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 160,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.brown,
                      width: 3.0,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '기상시간',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        selecteddate == todaydate ? today_wake_time : widget.wakeTime ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _updateLongTerm(String sleep_time) async {
    List<String> sleepTimeComponents = sleep_time.split(':');
    int sleepHours = int.parse(sleepTimeComponents[0]);
    if (sleepHours < 12 && sleep_time.toLowerCase().contains('pm')) {
      sleepHours += 12;
    }
    if(sleepHours==12&&sleep_time.toLowerCase().contains('am')){
      sleepHours-=12;
    }
    String convertedSleepTime = '$sleepHours:${sleepTimeComponents[1]}';
    convertedSleepTime = convertedSleepTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');

    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String yesterday = DateTime.now().subtract(Duration(days: 1)).toLocal().toString().split(' ')[0];
    DocumentSnapshot<Map<String, dynamic>> yesterdayDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(yesterday).get();
    DocumentSnapshot<Map<String,dynamic>>  userDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    //어제 수면 정보 존재함
    if(yesterdayDoc.exists&&yesterdayDoc.data()!.containsKey('predict_sleep_time')){
      //print('오늘꺼냐?? ${ref.watch(longTermNotiProvider).todayDate} 오늘: $currentDate');
      //아직 오늘꺼 계산 안함.
      if(ref.watch(longTermNotiProvider).todayDate != currentDate){
        String compare = _calLongTermFeedback(convertedSleepTime, yesterdayDoc['predict_sleep_time']);
        ref.watch(longTermNotiProvider.notifier).setTodayDate(currentDate);
        Map<String,dynamic> longterm_feed = userDoc['longterm_feedback'];
        longterm_feed[compare]++;
        await FirebaseFirestore.instance.collection('Users').doc(uid).set(
            {'longterm_feedback':longterm_feed},SetOptions(merge: true)
        );

        if(longterm_feed['same']+longterm_feed['less']+longterm_feed['over']==4){
          String max = _checkMax(longterm_feed);
          bool isTooEarly = false;
          bool isTooLate = false;
          if(max =='less'){
            isTooEarly = true;
          }
          if(max == 'over'){
            isTooLate = true;
          }
          if(isTooEarly){
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return LongPopup_A();
              },
            );
          }
          if(isTooLate){
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return LongPopup_B();
              },
            );
          }
        }
        if(longterm_feed['same']+longterm_feed['less']+longterm_feed['over']>4){
          for(var key in longterm_feed.keys){
            if(key==compare){
              longterm_feed[key]=1;
            }
            else{
              longterm_feed[key] = 0;
            }
          }
          await FirebaseFirestore.instance.collection('Users').doc(uid).set(
              {'longterm_feedback':longterm_feed},SetOptions(merge: true)
          );
        }
      }
      //오늘꺼 수정하는거임
      else{
        String temp = ref.watch(longTermNotiProvider).todayCal;
        String compare = _calLongTermFeedback(convertedSleepTime, yesterdayDoc['predict_sleep_time']);

        Map<String,dynamic> longterm_feed = userDoc['longterm_feedback'];
        longterm_feed[temp]--;
        longterm_feed[compare]++;

        await FirebaseFirestore.instance.collection('Users').doc(uid).set(
            {'longterm_feedback':longterm_feed},SetOptions(merge: true)
        );

        if(longterm_feed['same']+longterm_feed['less']+longterm_feed['over']==4){
          String max = _checkMax(longterm_feed);
          bool isTooEarly = false;
          bool isTooLate = false;

          if(max =='less'){
            isTooEarly = true;
          }
          if(max == 'over'){
            isTooLate = true;
          }
          if(isTooEarly){
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return LongPopup_A();
              },
            );
          }
          if(isTooLate){
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return LongPopup_B();
              },
            );
          }
        }
        if(longterm_feed['same']+longterm_feed['less']+longterm_feed['over']>4){
          for(var key in longterm_feed.keys){
            if(key==compare){
              longterm_feed[key]=1;
            }
            else{
              longterm_feed[key] = 0;
            }
          }
          await FirebaseFirestore.instance.collection('Users').doc(uid).set(
              {'longterm_feedback':longterm_feed},SetOptions(merge: true)
          );
        }
      }
    }else{
      ref.watch(longTermNotiProvider.notifier).setTodayDate(currentDate);
    }
  }
  String _checkMax(Map<String,dynamic> map){
    String max = '';
    int temp = -1;
    for(var key in map.keys){
      if(map[key]>temp){
        temp = map[key];
        max = key;
      }
    }
    if(map['over']==map['less']) return 'same';
    return max;
  }
  String _calLongTermFeedback(String realSleepTime, String predictSleepTime){
    int realSleepHour = 0;
    int realSleepMin = 0;
    int predictSleepHour = 0;
    int predictSleepMin=0;
    var splitRealTime = realSleepTime.split(':');
    realSleepHour = int.parse(splitRealTime[0]);
    realSleepMin = int.parse(splitRealTime[1]);
    var splitPredictTime = predictSleepTime.split(':');
    predictSleepHour = int.parse(splitPredictTime[0]);
    predictSleepMin = int.parse(splitPredictTime[1]);
    if(realSleepHour <12) realSleepHour+=24;
    if(predictSleepHour<12) predictSleepHour+=24;
    double realTime = realSleepHour.toDouble() + realSleepMin.toDouble()/60.0;
    double predictTime = predictSleepHour.toDouble() + predictSleepMin.toDouble()/60.0;

    if((realTime - predictTime)>0.5) {
      ref.watch(longTermNotiProvider.notifier).setTodayCal('over');
      return 'over';
    }
    if((realTime-predictTime)<-0.5) {
      ref.watch(longTermNotiProvider.notifier).setTodayCal('less');
      return 'less';
    } else {
      ref.watch(longTermNotiProvider.notifier).setTodayCal('same');
      return 'same';
    }
  }
  Future<void> _updateFirestore() async {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDocRef = firestore.collection('Users').doc(uid);

    // 오늘날짜의 user_sleep 컬렉션 가져오기
    CollectionReference userSleepCollection = userDocRef.collection('user_sleep');

    // user_sleep 컬렉션이 없는 경우 생성
    if (!(await userDocRef.get()).exists) {
      await userDocRef.set({
        'user_sleep': {},
      });
    }
    List<String> sleepTimeComponents = today_sleep_time.split(':');
    int sleepHours = int.parse(sleepTimeComponents[0]);
    if (sleepHours < 12 && today_sleep_time.toLowerCase().contains('pm')) {
      sleepHours += 12;
    }
    if(sleepHours==12&&today_sleep_time.toLowerCase().contains('am')){
      sleepHours-=12;
    }
    String convertedSleepTime = '$sleepHours:${sleepTimeComponents[1]}';
    convertedSleepTime = convertedSleepTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');

    // Convert selected wake time to 24-hour format
    List<String> wakeTimeComponents = today_wake_time.split(':');
    int wakeHours = int.parse(wakeTimeComponents[0]);
    if (wakeHours < 12 && today_wake_time.toLowerCase().contains('pm')) {
      wakeHours += 12;
    }
    if(wakeHours==12&&today_wake_time.toLowerCase().contains('am')){
      wakeHours-=12;
    }
    String convertedWakeTime = '$wakeHours:${wakeTimeComponents[1]}';
    convertedWakeTime = convertedWakeTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');

    // 오늘날짜의 문서 가져오기
    DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();
    ref.watch(sleepParmaProvider.notifier).changeWakeTime(today_wake_time);
    final prov = ref.watch(sleepParmaProvider.notifier);
    print(prov.state.wake_time);

    if (todayDocument.exists) {
      // 문서 있으면 sleep_time 및 wake_time 필드 업데이트
      await userSleepCollection.doc(currentDate).update({
        'sleep_time': convertedSleepTime,
        'wake_time': convertedWakeTime,
      });
    } else {
      // 문서 없으면 경우 새로운 문서 생성
      await userSleepCollection.doc(currentDate).set({
        'sleep_time': convertedSleepTime,
        'wake_time': convertedWakeTime,
      });
    }
  }
  void _updateResultText() {
    setState(() {});
  }
  String convertTo12HourFormat(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);

    String amPm = (hours >= 12) ? 'PM' : 'AM';

    if (hours > 12) {
      hours -= 12;
    }

    // Pad single-digit minutes with a leading zero
    String formattedMinutes = (minutes < 10) ? '0$minutes' : '$minutes';

    return '$hours:$formattedMinutes $amPm';
  }
  Future<void> _fetchSleepTimeAndUpdateState() async {
    try {
      tz.initializeTimeZones();
      var startTime = widget.selectedDay.subtract(const Duration(days: 1));
      var endTime = widget.selectedDay;

      final requests = <Future>[];
      Map<String, dynamic> typePoints = {};
      for (var type in types) {
        requests.add(
          HealthConnectFactory.getRecord(
            type: type,
            startTime: startTime,
            endTime: endTime,
          ).then(
                (value) => typePoints.addAll({type.name: value}),
          ),
        );
      }
      //print("??????");
      //await Future.wait(requests);
      print("??????");
      final currentDate = widget.selectedDay.toLocal().toString().split(' ')[0];
      final firestore = FirebaseFirestore.instance;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDocRef = firestore.collection('Users').doc(uid);
      final userSleepCollection = userDocRef.collection('user_sleep');
      //print("??????");
      final todayDocument = await userSleepCollection.doc(currentDate).get();


      if (todayDocument.exists) {
        today_sleep_time = todayDocument['sleep_time'] ?? '';
        today_wake_time = todayDocument['wake_time'] ?? '';
        today_sleep_time = convertTo12HourFormat(today_sleep_time);
        today_wake_time = convertTo12HourFormat(today_wake_time);
      } else {
        // 문서가 없으면 빈 문자열로 설정
        today_sleep_time = '';
        today_wake_time = '';
      }

      _updateResultText();
      _updateFirestore();
      print(today_sleep_time);
      print(today_wake_time);
    } catch (e) {
      today_sleep_time = '';
      today_wake_time = '';
      _updateResultText();
      print('Error!: $e');
    }
  }
  Future<void> _showManualInputPopup(BuildContext context) async {
    TextEditingController sleepHoursController = TextEditingController();
    TextEditingController sleepMinutesController = TextEditingController();
    TextEditingController wakeHoursController = TextEditingController();
    TextEditingController wakeMinutesController = TextEditingController();
    bool sleepIsAM = true;
    bool wakeIsAM = true;

    if (today_sleep_time.isNotEmpty && today_wake_time.isNotEmpty) {
      List<String> sleepTimeComponents = today_sleep_time.split(RegExp(r'[: ]'));
      List<String> wakeTimeComponents = today_wake_time.split(RegExp(r'[: ]'));

      sleepHoursController.text = sleepTimeComponents[0];
      sleepMinutesController.text = sleepTimeComponents[1];
      sleepIsAM = sleepTimeComponents[2] == 'AM';

      wakeHoursController.text = wakeTimeComponents[0];
      wakeMinutesController.text = wakeTimeComponents[1];
      wakeIsAM = wakeTimeComponents[2] == 'AM';
    }


    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {

            List<bool> _isSelected1 = [sleepIsAM, !sleepIsAM];
            void toggleSelect1(value) {
              print(value);

              if(value == 0){
                sleepIsAM = true;
              } else{
                sleepIsAM = false;
              }

              setState(() {
                _isSelected1 = [sleepIsAM, !sleepIsAM];
                print(_isSelected1);
              });
            }

            List<bool> _isSelected2 = [wakeIsAM, !wakeIsAM];
            void toggleSelect2(value) {
              print(value);

              if(value == 0){
                wakeIsAM = true;
              } else{
                wakeIsAM = false;
              }

              setState(() {
                _isSelected2 = [wakeIsAM, !wakeIsAM];
                print(_isSelected2);
              });
            }


            return AlertDialog(
              title: Center(child: Text('수면 정보 입력')),
              content: SingleChildScrollView( // Wrap with SingleChildScrollView
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          '취침시간',
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Column(
                              children: [
                                ToggleButtons(
                                    direction: Axis.vertical,
                                    isSelected: _isSelected1,
                                    onPressed: toggleSelect1,
                                    selectedColor: Colors.white,
                                    fillColor: Colors.brown.withOpacity(0.6),
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    constraints: const BoxConstraints(
                                      minHeight: 45.0,
                                      minWidth: 60.0,
                                    ),
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('AM', style: TextStyle(fontSize: 16),),),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 8),
                                        child: Text('PM', style: TextStyle(fontSize: 16),),),
                                    ]
                                ),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 30, right: 10),
                              width: 60,
                              height: 60,
                              child: TextField(
                                controller: sleepHoursController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '시',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            Text(
                              ' : ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, right: 10),
                              width: 60,
                              height: 60,
                              child: TextField(
                                controller: sleepMinutesController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '분',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '기상시간',
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Column(
                          children: [
                            ToggleButtons(
                                direction: Axis.vertical,
                                isSelected: _isSelected2,
                                onPressed: toggleSelect2,
                                selectedColor: Colors.white,
                                fillColor: Colors.brown.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                constraints: const BoxConstraints(
                                  minHeight: 45.0,
                                  minWidth: 60.0,
                                ),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('AM', style: TextStyle(fontSize: 16),),),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Text('PM', style: TextStyle(fontSize: 16),),),
                                ]
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 30, right: 10),
                          width: 60,
                          height: 60,
                          child: TextField(
                            controller: wakeHoursController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '시',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Text(
                          ' : ',
                          style: TextStyle(fontSize: 20),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          width: 60,
                          height: 60,
                          child: TextField(
                            controller: wakeMinutesController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: '분',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog when cancel is pressed
                  },
                  child: Text('취소'),
                  style: TextButton.styleFrom(
                    minimumSize: Size(60, 40),
                    primary: Colors.grey,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    _showConfirmationDialog_manual();

                    String selectedSleepTime = '${sleepHoursController.text}:${sleepMinutesController.text} ${sleepIsAM ? 'AM' : 'PM'}';
                    String selectedWakeTime = '${wakeHoursController.text}:${wakeMinutesController.text} ${wakeIsAM ? 'AM' : 'PM'}';

                    await _updateFirestoreWithManualInput(selectedSleepTime, selectedWakeTime);
                    ref.watch(shortTermNotiProvider.notifier).resetCaffCompare();
                    ref.watch(shortTermNotiProvider.notifier).resetTodayAlarm();
                    await _fetchSleepTimeAndUpdateState();
                    await _updateLongTerm(selectedSleepTime);
                    print('Selected Sleep Time: $selectedSleepTime');
                    print('Selected Wake Time: $selectedWakeTime');
                  },
                  child: Text('입력', style: TextStyle(color: Color(0xff93796A)),),
                  style: TextButton.styleFrom(
                    minimumSize: Size(60, 40),
                    primary: Colors.grey,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
  void _showConfirmationDialog_manual() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('취침시간, 기상시간이 새로 입력되었습니다!\n피곤도도 설정하러 가볼까요?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
  void _showConfirmationDialog_get_auto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('취침시간, 기상시간이 새로 입력되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
  void _showConfirmationDialog_get_auto_fail() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('삼성헬스를 정보를 불러오지 못했습니다!\n 입력 및 연결 상태를 확인해주세요'),
          actions: [
            TextButton(
              child: const Text("설정 가기", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
              onPressed: () async {
                await HealthConnectFactory.isApiSupported();
                await HealthConnectFactory.isAvailable();
                try {
                  await HealthConnectFactory.openHealthConnectSettings();
                } catch (e) {
                  print("error : $e");
                }
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // 팝업 닫기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _updateFirestoreWithManualInput(String selectedSleepTime, String selectedWakeTime) async {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDocRef = firestore.collection('Users').doc(uid);

    // 오늘날짜의 user_sleep 컬렉션 가져오기
    CollectionReference userSleepCollection = userDocRef.collection('user_sleep');

    // user_sleep 컬렉션이 없는 경우 생성
    if (!(await userDocRef.get()).exists) {
      await userDocRef.set({
        'user_sleep': {},
      });
    }
    // Convert selected sleep time to 24-hour format
    List<String> sleepTimeComponents = selectedSleepTime.split(':');
    int sleepHours = int.parse(sleepTimeComponents[0]);
    if (sleepHours < 12 && selectedSleepTime.toLowerCase().contains('pm')) {
      sleepHours += 12;
    }
    if(sleepHours==12&&selectedSleepTime.toLowerCase().contains('am')){
      sleepHours-=12;
    }
    String convertedSleepTime = '$sleepHours:${sleepTimeComponents[1]}';
    convertedSleepTime = convertedSleepTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');

    // Convert selected wake time to 24-hour format
    List<String> wakeTimeComponents = selectedWakeTime.split(':');
    int wakeHours = int.parse(wakeTimeComponents[0]);
    if (wakeHours < 12 && selectedWakeTime.toLowerCase().contains('pm')) {
      wakeHours += 12;
    }
    if(wakeHours==12&&selectedWakeTime.toLowerCase().contains('am')){
      wakeHours-=12;
    }
    String convertedWakeTime = '$wakeHours:${wakeTimeComponents[1]}';
    convertedWakeTime = convertedWakeTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');


    // 오늘날짜의 문서 가져오기
    DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();

    if (todayDocument.exists) {
      // 문서 있으면 sleep_time 및 wake_time 필드 업데이트

      await userSleepCollection.doc(currentDate).update({
        'sleep_time': convertedSleepTime,
        'wake_time': convertedWakeTime,
      });
    } else {
      // 문서 없으면 경우 새로운 문서 생성
      await userSleepCollection.doc(currentDate).set({
        'sleep_time': convertedSleepTime,
        'wake_time': convertedWakeTime,
      });
    }

    print("sssssssssssssss $currentDate");
  }

}
