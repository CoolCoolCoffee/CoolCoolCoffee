import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

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
      content: SingleChildScrollView(
        child: Container(
          //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 100),
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
            ],
          ),
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
          onPressed: () async {
            String sleepEnteredTime =
                '${sleepHoursController.text}:${sleepMinutesController.text} ${sleepIsAM ? 'AM' : 'PM'}';

            List<String> timeComponents = sleepEnteredTime.split(':');
            int hours = int.parse(timeComponents[0]);
            if (!sleepIsAM && hours < 12) {
              hours += 12;
            } else if (sleepIsAM && hours == 12) {
              hours = 0;
            }
            String convertedTime = '$hours:${timeComponents[1]}';
            convertedTime = convertedTime.replaceAll(RegExp(r'\s?[APMapm]{2}\s?$'), '');

            String uid = FirebaseAuth.instance.currentUser!.uid;
            DocumentReference userDocRef = FirebaseFirestore.instance.collection('Users').doc(uid);
            bool docExists = (await userDocRef.get()).exists;

            Future<void> updateFirestore() async {
              try {
                if (docExists) {
                  // 필드 있으면 goal_sleep_time 필드를 업데이트
                  await userDocRef.update({
                    'goal_sleep_time': convertedTime,
                  });
                } else {
                  // 필드 없으면 만들어 업데이트
                  await userDocRef.set({
                    'goal_sleep_time': convertedTime,
                  });
                }
                widget.updateParentState(sleepEnteredTime);

                Navigator.of(context).pop();
              } catch (error) {
                print('error : $error');
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


class ClockWidget extends ConsumerStatefulWidget {
  const ClockWidget({Key? key}) : super(key: key);

  @override
  _ClockWidgetState createState() => _ClockWidgetState();
}

class _ClockWidgetState extends ConsumerState<ClockWidget>{
  String sleepEnteredTime = '';
  String resultText = '';

  @override
  void initState() {
    super.initState();
    _getSleepEnteredTime();
    //여기서부터 추가
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(sleepParmaProvider);
      if(ref.watch(sleepParmaProvider.notifier).state.goal_sleep_time.isNotEmpty){
        setState(() {});
      }
    });
  }

  Future<void> _getSleepEnteredTime() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot<Map<String, dynamic>> userDoc =
      await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists && userDoc.data()!.containsKey('goal_sleep_time')) {
        print("hoal here!!");
        String storedTime = userDoc['goal_sleep_time'];
        print(storedTime);
        List<String> timeComponents = storedTime.split(':');
        int hours = int.parse(timeComponents[0]);
        String minutes = timeComponents[1];

        String amPm = (hours >= 12) ? 'PM' : 'AM';

        if (hours > 12) {
          hours -= 12;
        }

        String formattedTime = '$hours:$minutes $amPm';
        print(formattedTime);
        setState(() {
          sleepEnteredTime = formattedTime;
          print('sleepEnteredTime $sleepEnteredTime');
          ref.watch(sleepParmaProvider.notifier).changeGoalSleepTime(sleepEnteredTime);
          ref.watch(sleepParmaProvider.notifier).changeTw(userDoc['tw']);
          ref.watch(sleepParmaProvider.notifier).changeHalfTime(userDoc['caffeine_half_life']);
        });
      } else {
        print('error1');
      }
    } catch (e) {
      print('error2 : $e');
    }
  }

  @override
  Widget build(BuildContext context){
    final prov = ref.watch(sleepParmaProvider);
    print('build ${prov.goal_sleep_time}');
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
                  if (prov.goal_sleep_time.isNotEmpty)
                    TextSpan(
                      text: "카페인 섭취 제한 시작까지\n",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (prov.goal_sleep_time.isNotEmpty)
                    TextSpan(
                      text: "n시간 m분",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 20,
                      ),
                    ),
                  if (prov.goal_sleep_time.isNotEmpty)
                    TextSpan(
                      text: " 남았어요!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  if (prov.goal_sleep_time.isEmpty)
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
                print("dddd $sleepEnteredTime");
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
                    prov.goal_sleep_time.isNotEmpty
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
                    //'취침 시간\n $sleepEnteredTime',
                    prov.goal_sleep_time.isNotEmpty
                        ? '취침 시간\n ${prov.goal_sleep_time}'
                        : '아직 목표 취침시간이 설정되지 않았네요!\n 목표 취침시간을 설정해볼까요?',
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
              ref.watch(sleepParmaProvider.notifier).changeGoalSleepTime(sleepEnteredTime);
            });
          },
          sleepTime: sleepEnteredTime,
        );
      },
    );
  }
}