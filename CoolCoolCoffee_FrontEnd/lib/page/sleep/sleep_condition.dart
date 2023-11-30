import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SleepConditionWidget extends StatefulWidget {
  final Function(int conditionLevel) onConditionSelected;

  const SleepConditionWidget({Key? key, required this.onConditionSelected})
      : super(key: key);

  @override
  _SleepConditionWidgetState createState() => _SleepConditionWidgetState();
}

class _SleepConditionWidgetState extends State<SleepConditionWidget> {
  double selectedCondition = 5.0; // Default value

  @override
  void initState() {
    super.initState();
    // 이니셜 상태에서 Firestore에서 값을 가져와서 설정합니다.
    _fetchSleepQualityScore();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '피곤도를 기록해주세요',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                // onPressed: () async {
                //   await saveSelectedCondition(); // Use 'await' here
                // },
                onPressed: () {
                  onPressedHandler();
                  _showConfirmationDialog();// Call asynchronously
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                ),
                child: Text('저장'),
              ),
            ],
          ),
          Container(
            width: 350,
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.brown, // Border color
                width: 3.0, // Border width
              ),
              borderRadius: BorderRadius.circular(12.0), // Border radius
            ),
            child: Column(
              children: [
                Slider(
                  value: selectedCondition,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value;
                    });
                    widget.onConditionSelected(selectedCondition.toInt());
                  },
                  activeColor: Colors.brown,
                  inactiveColor: Colors.grey[300],
                  thumbColor: Colors.brown,
                ),
                Text(
                  getConditionLevel(selectedCondition.toInt()),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.brown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text('피곤도가 새로 입력되었습니다!'),
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


  Future<void> _fetchSleepQualityScore() async {
    try {
      String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDocRef = firestore.collection('Users').doc(uid);
      CollectionReference userSleepCollection = userDocRef.collection('user_sleep');

      if (!(await userDocRef.get()).exists) {
        await userDocRef.set({
          'user_sleep': {},
        });
      }
      DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();

      if (todayDocument.exists) {
        // 문서 있으면 그거로 표시
        setState(() {
          selectedCondition = (todayDocument['sleep_quality_score'] ?? 5).toDouble();
          //print("tlqkf : $selectedCondition");
        });
      } else {
        // 문서 없으면 5.0
        setState(() {
          selectedCondition = 5.0;
        });
      }
    } catch (error) {
      print('Error fetching sleep quality score: $error');
    }
  }

  void saveSelectedCondition() async {
    try {
      String currentDate = DateTime.now().toLocal().toString().split(' ')[0];
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // 사용자 문서
      DocumentReference userDocRef = firestore.collection('Users').doc(uid);

      // 오늘날짜의 user_sleep 컬렉션 가져오기
      CollectionReference userSleepCollection = userDocRef.collection('user_sleep');

      // user_sleep 컬렉션이 없는 경우 생성
      if (!(await userDocRef.get()).exists) {
        await userDocRef.set({
          'user_sleep': {},
        });
      }

      // 오늘날짜의 문서 가져오기
      DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();

      if (todayDocument.exists) {
        // 문서 있으면 sleep_quality_score 필드 업데이트
        await userSleepCollection.doc(currentDate).update({
          'sleep_quality_score': selectedCondition.toInt(),
        });
      } else {
        // 문서 없으면 문서 생성
        await userSleepCollection.doc(currentDate).set({
          'sleep_quality_score': selectedCondition.toInt(),
        });
      }

      print('!!selectedCondition : $selectedCondition');
      widget.onConditionSelected(selectedCondition.toInt());
    } catch (error) {
      print('Error saving condition: $error');
    }
  }
  void onPressedHandler() {
    saveSelectedCondition(); // No need for 'await' here
  }

  String getConditionLevel(int conditionLevel) {
    return conditionLevel.toString();
  }
}
