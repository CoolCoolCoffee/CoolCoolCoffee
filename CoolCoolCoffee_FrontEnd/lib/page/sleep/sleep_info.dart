import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';
import 'package:coolcoolcoffee_front/service/user_sleep_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SleepInfoWidget extends StatefulWidget {
  final DateTime selectedDay;
  final String? sleepTime;
  final String? wakeTime;
  const SleepInfoWidget({Key? key, required this.selectedDay,this.sleepTime, this.wakeTime,}) : super(key: key);

  @override
  _SleepInfoWidgetState createState() => _SleepInfoWidgetState();
}

class _SleepInfoWidgetState extends State<SleepInfoWidget> {
  final UserSleepService _userSleepService = UserSleepService();
  String resultText_start_real = '';
  String resultText_end_real = '';
  DateTime today = DateTime.now();
  String selecteddate = '';
  String todaydate = '';

  @override
  void initState() {
    super.initState();
    // 값이 없는 경우에만 초기화
    if (resultText_start_real.isEmpty || resultText_end_real.isEmpty) {
      _fetchSleepTimeAndUpdateState();
    }
  }


  List<HealthConnectDataType> types = [HealthConnectDataType.SleepSession];

  @override
  Widget build(BuildContext context) {
    String selecteddate = widget.selectedDay!.toLocal().toIso8601String().split('T')[0];
    String todaydate = today.toLocal().toIso8601String().split('T')[0];
    // print('Selected Day: ${widget.selectedDay}');
    // print('SleepTime in initState: ${widget.sleepTime}');
    // print('Wake in initState: ${widget.wakeTime}');
    // print('selecteddate $selecteddate');
    // print('todaydate $todaydate');
    // resultText_start_real = widget.sleepTime ?? '';
    // resultText_end_real = widget.wakeTime ?? '';
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selecteddate == todaydate
                      ? '오늘의 수면정보를 불러와요!'
                      : '$selecteddate의 수면 정보',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 10),
                //if (selecteddate == todaydate)
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
                        resultText_end_real = formatter.format(resultText_end);
                      } catch (e) {
                        print(e.toString());
                      }
                      _updateResultText();
                      _updateFirestore();
                      print(resultText_start_real);
                      print(resultText_end_real);

                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      primary: selecteddate == todaydate ? Colors.brown : Colors.white,
                      shape: selecteddate == todaydate
                          ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )
                          : null, // Set shape to null if it's not today's date
                      elevation: selecteddate == todaydate ? 5 : 0,
                    ),
                    child: Text(selecteddate == todaydate ? '가져오기' : ''),
                  ),
                SizedBox(width: 10),
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
                    ),
                    child: Text('입력'),
                  ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 165,
                  height: 100,
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
                        selecteddate == todaydate ? resultText_start_real : widget.sleepTime ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 165,
                  height: 100,
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
                        selecteddate == todaydate ? resultText_end_real : widget.wakeTime ?? '',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 23.0,
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

    // 오늘날짜의 문서 가져오기
    DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();

    if (todayDocument.exists) {
      // 문서 있으면 sleep_time 및 wake_time 필드 업데이트
      await userSleepCollection.doc(currentDate).update({
        'sleep_time': resultText_start_real,
        'wake_time': resultText_end_real,
      });
    } else {
      // 문서 없으면 경우 새로운 문서 생성
      await userSleepCollection.doc(currentDate).set({
        'sleep_time': resultText_start_real,
        'wake_time': resultText_end_real,
      });
    }
    //print("sssssssssssssss $currentDate");
  }


  void _updateResultText() {
    setState(() {});
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
      await Future.wait(requests);

      final currentDate = widget.selectedDay.toLocal().toString().split(' ')[0];
      final firestore = FirebaseFirestore.instance;
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDocRef = firestore.collection('Users').doc(uid);
      final userSleepCollection = userDocRef.collection('user_sleep');

      final todayDocument = await userSleepCollection.doc(currentDate).get();

      if (todayDocument.exists) {
        // Firestore에서 데이터 가져오기
        resultText_start_real = todayDocument['sleep_time'] ?? '';
        resultText_end_real = todayDocument['wake_time'] ?? '';
      } else {
        // 문서가 없으면 빈 문자열로 설정
        resultText_start_real = '';
        resultText_end_real = '';
      }

      _updateResultText();
      _updateFirestore();
      print(resultText_start_real);
      print(resultText_end_real);
    } catch (e) {
      resultText_start_real = '';
      resultText_end_real = '';
      _updateResultText();
      print(e.toString());
    }
  }

  Future<void> _showManualInputPopup(BuildContext context) async {
    TextEditingController sleepHoursController = TextEditingController();
    TextEditingController sleepMinutesController = TextEditingController();
    TextEditingController wakeHoursController = TextEditingController();
    TextEditingController wakeMinutesController = TextEditingController();
    bool sleepIsAM = true;
    bool wakeIsAM = true;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('입력'),
              content: SingleChildScrollView( // Wrap with SingleChildScrollView
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
                    SizedBox(height: 10),
                    Text(
                      '기상시간',
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
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
                    Navigator.of(context).pop(); // Close the dialog when cancel is pressed
                  },
                  child: Text('취소'),
                  style: TextButton.styleFrom(
                    minimumSize: Size(60, 40),
                    primary: Colors.black,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    String selectedSleepTime = '${sleepHoursController.text}:${sleepMinutesController.text} ${sleepIsAM ? 'AM' : 'PM'}';
                    String selectedWakeTime = '${wakeHoursController.text}:${wakeMinutesController.text} ${wakeIsAM ? 'AM' : 'PM'}';

                    await _updateFirestoreWithManualInput(selectedSleepTime, selectedWakeTime);

                    await _fetchSleepTimeAndUpdateState();

                    print('Selected Sleep Time: $selectedSleepTime');
                    print('Selected Wake Time: $selectedWakeTime');
                  },
                  child: Text('확인'),
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
          },
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

    // 오늘날짜의 문서 가져오기
    DocumentSnapshot todayDocument = await userSleepCollection.doc(currentDate).get();

    if (todayDocument.exists) {
      // 문서 있으면 sleep_time 및 wake_time 필드 업데이트
      await userSleepCollection.doc(currentDate).update({
        'sleep_time': selectedSleepTime,
        'wake_time': selectedWakeTime,
      });
    } else {
      // 문서 없으면 경우 새로운 문서 생성
      await userSleepCollection.doc(currentDate).set({
        'sleep_time': selectedSleepTime,
        'wake_time': selectedWakeTime,
      });
    }

    print("sssssssssssssss $currentDate");
  }

}
