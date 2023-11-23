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
                onPressed: () async {
                  await saveSelectedCondition(); // Use 'await' here
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

  Future<void> saveSelectedCondition() async {
    String currentDate = DateTime.now().toLocal().toString().split(' ')[0];

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = FirebaseAuth.instance.currentUser!.uid;
    CollectionReference userSleepCollection = firestore.collection('Users').doc(uid).collection('user_sleep');
    DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();

    // user_sleep 컬렉션 없으면 생성
    if (!await userSleepCollection.doc('dummy').get().then((doc) => doc.exists)) {
      await userSleepCollection.doc('dummy').set({});
    }

    if (todayDocument.exists) {
      // 문서가 있으면 sleep_quality_score 필드 업데이트
      await userSleepCollection.doc(currentDate).update({
        'sleep_quality_score': selectedCondition.toInt(),
      });
    } else {
      // 문서가 없으면 경우 오늘 날짜 문서 생성 후 추가
      await userSleepCollection.doc(currentDate).set({
        'sleep_quality_score': selectedCondition.toInt(),
      });
    }

    print('!!selectedCondition : $selectedCondition');
    widget.onConditionSelected(selectedCondition.toInt());
  }


  String getConditionLevel(int conditionLevel) {
    return conditionLevel.toString();
  }
}
