import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LongPopup_B extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('LongPopup_B'),
      content: Text('지난 한 주 카페인의 영향을 많이 받으셨나요?'),
      actions: <Widget>[
        TextButton(
          onPressed: () async {
            Navigator.of(context).pop();
            _showB2Dialog(context);
            await _updateCaffeineHalfTime();
            // 카페인 반감기 늘려주기
          },
          child: Text('예'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showB1Dialog(context);
          },
          child: Text('아니오'),
        ),
      ],
    );
  }


  void _showB1Dialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('B1'),
          content: Text('평균 취침 시간, 적정 수면 시간)을 수정해야 할까요?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 타오값 수정
                _showB1_YesDialog(context);
              },
              child: Text('예'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 자의로 일찍 자서 (ex. 운동, 반신욕) 그대로 두기
              },
              child: Text('아니오'),
            ),
          ],
        );
      },
    );
  }

  void _showB1_YesDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return _ChangeDialog();
      },
    );
  }

  void _showB2Dialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('B2'),
          content: Text('카페인 반감기를 늘렸어요!'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                //await _updateCaffeineHalfTime();
                //DB 카페인 반감기 늘려주기
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _updateCaffeineHalfTime() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDoc = firestore.collection('Users').doc(uid);

      DocumentSnapshot userSnapshot = await userDoc.get();
      num currentCaffeineHalfTime = userSnapshot.get('caffeine_half_life') ?? 0.0;

      await userDoc.update({
        'caffeine_half_life': currentCaffeineHalfTime + 0.5,
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}

class _ChangeDialog extends ConsumerStatefulWidget {
  @override
  _ChangeDialogState createState() => _ChangeDialogState();
}

class _ChangeDialogState extends ConsumerState<_ChangeDialog> {
  TextEditingController averageSleepHoursController = TextEditingController();
  TextEditingController averageSleepMinutesController = TextEditingController();
  TextEditingController goodSleepHoursController = TextEditingController();
  TextEditingController goodSleepMinutesController = TextEditingController();
  bool averageSleepIsAM = true;
  bool goodSleepIsAM = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('평균 취침 시간과 적정 수면 시간을 재입력해주세요!',style: TextStyle(fontSize: 15),),
      content: Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('평균 취침 시간'),
            Row(
              children: [
                Container(
                  width: 55,
                  height: 40,
                  child: TextField(
                    controller: averageSleepHoursController,
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
                  width: 55,
                  height: 40,
                  child: TextField(
                    controller: averageSleepMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '분',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      averageSleepIsAM = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: averageSleepIsAM ? Colors.brown.withOpacity(0.6) : Colors.brown.withOpacity(0.2),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('AM'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      averageSleepIsAM = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: !averageSleepIsAM ? Colors.brown.withOpacity(0.6) : Colors.brown.withOpacity(0.2),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('PM'),
                ),
              ],
            ),

            SizedBox(height: 10),

            Text('적정 수면 시간'),
            Row(
              children: [
                Container(
                  width: 65,
                  height: 40,
                  child: TextField(
                    controller: goodSleepHoursController,
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
                  width: 65,
                  height: 40,
                  child: TextField(
                    controller: goodSleepMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '분',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                int averageSleepHours = int.parse(averageSleepHoursController.text);
                int averageSleepMinutes = int.parse(averageSleepMinutesController.text);
                int goodSleepHours = int.parse(goodSleepHoursController.text);
                int goodSleepMinutes = int.parse(goodSleepMinutesController.text);

                if (!averageSleepIsAM) {
                  averageSleepHours += 12;
                }

                String avgBedTime = '$averageSleepHours:${averageSleepMinutes.toString().padLeft(2, '0')}';
                String goodSleepTime = '$goodSleepHours:${goodSleepMinutes.toString().padLeft(2, '0')}';

                updateSleepInfo(averageSleepIsAM, averageSleepHours, averageSleepMinutes, goodSleepHours, goodSleepMinutes);

                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void updateSleepInfo(bool am, int bedHour, int bedMin, int goodSleepHour, int goodSleepMin) {
    int bedH = bedHour; int bedM = bedMin; int sleepH = goodSleepHour; int sleepM = goodSleepMin;
    double h1 = 0.75; double h2 = 0.2469; double a = 0.09478; double C = 0.45145833333;
    if(!am){
      bedH = bedH + 12;
    }
    var good_sleep = sleepH + sleepM/60;
    var t0 = bedH + bedM/60 + good_sleep;
    if(t0 >= 24.0) t0 = t0 - 24.0;
    t0 = t0/24-C;

    var delta = (24 - good_sleep)/24;

    var x0 = h2 + a*sin(2*pi*t0);
    var x1 = h1 + a*sin(2*pi*(t0 + delta));
    var tw = double.parse((-delta / (log(1-x1)-log(1-x0))).toStringAsFixed(10));

    String bedTime = '${bedH.toString()}:${bedM.toString().padLeft(2, '0')}';
    String goodSleepTime = '${sleepH.toString()}:${sleepM.toString().padLeft(2, '0')}';

    final data = {'avg_bed_time' : bedTime, "good_sleep_time" : goodSleepTime, "tw": tw};
    ref.watch(sleepParmaProvider.notifier).changeTw(tw);
    var db = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    db.collection("Users").doc(uid).set(data, SetOptions(merge: true));

    print('업데이트 완료');
    print('취침 시간: $bedHour시 $bedMin분');
    print('적정 수면 시간: $goodSleepHour시 $goodSleepMin분');
    print('tw값 : $tw');
  }

}
