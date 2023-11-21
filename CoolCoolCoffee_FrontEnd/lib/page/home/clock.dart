import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditPopup extends StatefulWidget {
  final Function(String, String) onSave;
  final void Function(String, String) updateParentState;
  final String sleepTime;
  final String wakeTime;

  const EditPopup({
    Key? key,
    required this.onSave,
    required this.updateParentState,
    required this.sleepTime, // Add sleepTime parameter to the constructor
    required this.wakeTime,  // Add wakeTime parameter to the constructor
  }) : super(key: key);

  @override
  _EditPopupState createState() => _EditPopupState();
}

class _EditPopupState extends State<EditPopup> {
  TextEditingController sleepHoursController = TextEditingController();
  TextEditingController sleepMinutesController = TextEditingController();
  TextEditingController wakeHoursController = TextEditingController();
  TextEditingController wakeMinutesController = TextEditingController();

  bool sleepIsAM = true;
  bool wakeIsAM = true;
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

    List<String> wakeTimeParts = widget.wakeTime.split(':');
    if (wakeTimeParts.length == 2) {
      wakeHoursController.text = wakeTimeParts[0];
      List<String> minutesAndAMPM = wakeTimeParts[1].split(' ');
      if (minutesAndAMPM.length == 2) {
        wakeMinutesController.text = minutesAndAMPM[0];
        wakeIsAM = minutesAndAMPM[1] == 'AM';
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
            Text(
              '기상시간',
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                // Hours TextField
                Container(
                  width: 60,
                  height: 40,
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
                // Minutes TextField
                Container(
                  width: 60,
                  height: 40,
                  child: TextField(
                    controller: wakeMinutesController,
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
                      wakeIsAM = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: wakeIsAM ? Colors.brown.withOpacity(0.6) : Colors.brown.withOpacity(0.2),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('AM'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      wakeIsAM = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: !wakeIsAM ? Colors.brown.withOpacity(0.6) : Colors.brown.withOpacity(0.2),
                    minimumSize: Size(40, 40),
                  ),
                  child: Text('PM'),
                ),
              ],
            ),
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
            String wakeEnteredTime =
                '${wakeHoursController.text}:${wakeMinutesController.text} ${wakeIsAM ? 'AM' : 'PM'}';

            String uid = FirebaseAuth.instance.currentUser!.uid;
            DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);
            Future<void> updateFirestore() async {
              try {
                // goal_sleep_time 필드를 업데이트
                await userDocRef.update({
                  'goal_sleep_time': sleepEnteredTime,
                });
                widget.updateParentState(sleepEnteredTime, wakeEnteredTime);

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
  String wakeEnteredTime = '';
  String resultText = '';

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
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    TextSpan(
                      text: "카페인 섭취 제한 시작까지\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    TextSpan(
                      text: "n시간 m분",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty)
                    TextSpan(
                      text: " 남았어요!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (sleepEnteredTime.isEmpty || wakeEnteredTime.isEmpty)
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
                    sleepEnteredTime.isNotEmpty && wakeEnteredTime.isNotEmpty
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
        // Container(
        //   height: 250,
        //   child: AnalogClock(
        //     decoration: BoxDecoration(
        //         border: Border.all(width: 2.0, color: Colors.black),
        //         color: Colors.transparent,
        //         shape: BoxShape.circle
        //     ),
        //     width: 250,
        //     isLive: true,
        //     hourHandColor: Colors.black,
        //     minuteHandColor: Colors.black,
        //     showSecondHand: true,
        //     numberColor: Colors.black87,
        //     showNumbers: true,
        //     showAllNumbers: true,
        //     textScaleFactor: 1.4,
        //     showTicks: true,
        //     showDigitalClock: false,
        //     datetime: DateTime.now(),
        //   ),
        // ),
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
                  Text(
                    '기상 시간\n $wakeEnteredTime',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
  void onSave(String sleepEnteredTime, String wakeEnteredTime) {
    setState(() {
      this.sleepEnteredTime = sleepEnteredTime;
      this.wakeEnteredTime = wakeEnteredTime;
    });
  }

  void _updateResultText() {
    setState(() {});
  }


//시간 수정 팝업
  void _showEditPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPopup(
          onSave: (sleepTime, wakeTime) {
          },
          updateParentState: (sleepTime, wakeTime) {
            setState(() {
              sleepEnteredTime = sleepTime;
              wakeEnteredTime = wakeTime;
            });
          },
          sleepTime: sleepEnteredTime,
          wakeTime: wakeEnteredTime,
        );
      },
    );
  }
}