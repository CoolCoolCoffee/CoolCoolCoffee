import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LongPopup_A extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('LongPopup_A'),
      content: Text('지난 한 주 카페인의 영향을 많이 받으셨나요?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            //타오 값 수정
            _showA2Dialog(context);
          },
          child: Text('예'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _showA1Dialog(context);
          },
          child: Text('아니오'),
        ),
      ],
    );
  }

  void _showA1Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('A1'),
          content: Text('평균 취침 시간, 적정 수면 시간)을 수정해야 할까요?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // 타오값 수정
                _showA2Dialog(context);
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

  void _showA2Dialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _A2Dialog();
      },
    );
  }
}


class _A2Dialog extends ConsumerStatefulWidget {
  @override
  _A2DialogState createState() => _A2DialogState();
}

class _A2DialogState extends ConsumerState<_A2Dialog> {
  TextEditingController averageSleepHoursController = TextEditingController();
  TextEditingController averageSleepMinutesController = TextEditingController();
  TextEditingController goodSleepHoursController = TextEditingController();
  TextEditingController goodSleepMinutesController = TextEditingController();
  bool averageSleepIsAM = true;
  bool goodSleepIsAM = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('A2'),
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
                  width: 55,
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
                  width: 55,
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

            // 저장 버튼
            ElevatedButton(
              onPressed: () {
                //DB에 바뀐 값들 저장 시키기
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
