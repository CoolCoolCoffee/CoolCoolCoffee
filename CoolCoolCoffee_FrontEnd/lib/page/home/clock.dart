import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPopup extends StatefulWidget {
  final Function(String) onSave;
  final void Function(String) updateParentState;
  final String sleepTime;

  const EditPopup({
    Key? key,
    required this.onSave,
    required this.updateParentState,
    required this.sleepTime, // Add sleepTime parameter to the constructor
  }) : super(key: key);

  @override
  _EditPopupState createState() => _EditPopupState();
}

class _EditPopupState extends State<EditPopup> {
  TextEditingController sleepHoursController = TextEditingController();
  TextEditingController sleepMinutesController = TextEditingController();

  bool sleepIsAM = true;
  bool isCancelled = false;

  @override
  void initState() {
    super.initState();
    // Set initial values for controllers based on sleepTime and wakeTime
    List<String> sleepTimeParts = widget.sleepTime.split(':');
    if (sleepTimeParts.length == 2) {
      sleepHoursController.text = sleepTimeParts[0];
      List<String> minutesAndAMPM = sleepTimeParts[1].split(' ');
      if (minutesAndAMPM.length == 2) {
        sleepMinutesController.text = minutesAndAMPM[0];
        sleepIsAM = minutesAndAMPM[1] == 'AM';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('목표 수면 시간'),
      content: Container(
        constraints: BoxConstraints(maxHeight: 200, maxWidth: 400),
        child: Column(
          children: [
            Text(
              '취침시간',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 40,
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
                  width: 60,
                  height: 40,
                  child: TextField(
                    controller: sleepMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '분',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sleepIsAM = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: sleepIsAM ? Colors.brown.withOpacity(0.6) : Colors.brown.withOpacity(0.2),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('AM'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      sleepIsAM = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: !sleepIsAM ? Colors.brown.withOpacity(0.6) : Colors.brown.withOpacity(0.2),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('PM'),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            isCancelled = true;
            Navigator.of(context).pop();
          },
          child: Text(
            '취소',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(60, 40),
          ),
        ),
        TextButton(
          onPressed: () {
            String sleepEnteredTime =
                '${sleepHoursController.text}:${sleepMinutesController.text} ${sleepIsAM ? 'AM' : 'PM'}';
            String uid = FirebaseAuth.instance.currentUser!.uid;
            DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);
            Future<void> updateFirestore() async {
              try {
                // goal_sleep_time 필드를 업데이트
                await userDocRef.update({
                  'goal_sleep_time': sleepEnteredTime,
                });
                widget.updateParentState(sleepEnteredTime);

                Navigator.of(context).pop();
              } catch (error) {
                print('goal_sleep_time 업데이트 중 오류 발생: $error');
              }
            }
            updateFirestore();
          },
          child: Text(
            '확인',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.brown,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(60, 40),
          ),
        ),
      ],
    );
  }
}


class ClockWidget extends StatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget>{

  String sleepEnteredTime = '';
  String resultText = '';

  Future<String> fetchDataAndUpdateUI() async {
    String goalSleepTime = ''; // Initialize with an empty string

    // 현재 사용자의 Firestore 문서에 대한 참조가 있다고 가정합니다.
    DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc('userId'); // 'userId'를 실제 사용자 ID로 교체하세요.

    try {
      // Firestore에서 사용자 문서를 불러옵니다.
      DocumentSnapshot userSnapshot = await userDocRef.get();

      // 사용자 문서에서 goal_sleep_time 필드의 존재 여부를 확인하고 값을 가져옵니다.
      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('goal_sleep_time')) {
          goalSleepTime = userData['goal_sleep_time'];
        }
      }
    } catch (error) {
      print('Firestore에서 데이터를 불러오는 중 오류 발생: $error');
      // 오류를 필요에 따라 처리합니다.
    }

    return goalSleepTime;
  }


  @override
  Widget build(BuildContext context){
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                children: [
                  if (sleepEnteredTime.isNotEmpty)
                    TextSpan(
                      text: "카페인 섭취 제한 시작까지\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isNotEmpty)
                    TextSpan(
                      text: "n시간 m분",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isNotEmpty)
                    TextSpan(
                      text: " 남았어요!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isEmpty)
                    TextSpan(
                      text: "목표 수면 시간을 설정해주세요.",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                ],
              ),
            ),
            //SizedBox(width: 55),
            ElevatedButton(
              onPressed: () {
                _showEditPopup(context);
              },
              style: ElevatedButton.styleFrom(
                primary: null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.edit, // 연필 아이콘
                    color: Colors.brown,
                    size: 18,

                  ),
                  SizedBox(width: 3),
                  Text(
                    sleepEnteredTime.isNotEmpty
                        ? '수정'
                        : '설정',
                    style: TextStyle(
                      color: Colors.brown,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(150),
          child: Container(
            width: 250,
            height: 250,
            color: Colors.brown.withOpacity(0.6),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '취침 시간\n $sleepEnteredTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  void onSave(String sleepEnteredTime) {
    setState(() {
      this.sleepEnteredTime = sleepEnteredTime;
    });
  }

//시간 수정 팝업
  void _showEditPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPopup(
          onSave: (sleepTime) {
          },
          updateParentState: (sleepTime) {
            setState(() {
              sleepEnteredTime = sleepTime;
            });
          },
          sleepTime: sleepEnteredTime,
        );
      },
    );
  }
}