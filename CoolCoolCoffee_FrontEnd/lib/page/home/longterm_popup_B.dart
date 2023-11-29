import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'dart:math';


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
            await _updateCaffeineHalfTime();
            _showB2Dialog(context);
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
      context: context,
      builder: (BuildContext context) {
        return _ChangeDialog();
      },
    );
  }

  void _showB2Dialog(BuildContext context) {
    showDialog(
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

class _ChangeDialog extends StatefulWidget {
  @override
  _ChangeDialogState createState() => _ChangeDialogState();
}

class _ChangeDialogState extends State<_ChangeDialog> {
  TextEditingController averageSleepHoursController = TextEditingController();
  TextEditingController averageSleepMinutesController = TextEditingController();
  TextEditingController goodSleepHoursController = TextEditingController();
  TextEditingController goodSleepMinutesController = TextEditingController();
  bool averageSleepIsAM = true;
  bool goodSleepIsAM = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('B1_Yes'),
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

                updateFirestoreDocument(avgBedTime, goodSleepTime);

                Navigator.of(context).pop();
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }

  void updateFirestoreDocument(String avgBedTime, String goodSleepTime) {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference userDoc = firestore.collection('Users').doc(uid);

      final data = {'avg_bed_time': avgBedTime, 'good_sleep_time': goodSleepTime};
      userDoc.set(data, SetOptions(merge: true));

      print('평균 취침 시간: $avgBedTime');
      print('적정 수면 시간: $goodSleepTime');
    } catch (e) {
      print('Error : $e');
    }
  }
}
