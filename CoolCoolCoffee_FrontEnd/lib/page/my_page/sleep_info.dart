import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditSleepDialog extends StatefulWidget {
  const EditSleepDialog({super.key});

  @override
  State<EditSleepDialog> createState() => _EditSleepDialogState();
}

class _EditSleepDialogState extends State<EditSleepDialog> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  late int bedHour;
  late int bedMin;
  late int goodSleepHour;
  late int goodSleepMin;

  /// 수정된 수면 정보 업데이트하는 함수
  void updateSleepInfo(bool am, int bedHour, int bedMin, int goodSleepHour, int goodSleepMin) {
    int bedH = bedHour; int bedM = bedMin; int sleepH = goodSleepHour; int sleepM = goodSleepMin;

    if(!am){
      bedH = bedH + 12;
    }

    String bedTime = '${bedH.toString()}:${bedM.toString().padLeft(2, '0')}';
    String goodSleepTime = '${sleepH.toString()}:${sleepM.toString().padLeft(2, '0')}';

    final data = {'avg_bed_time' : bedTime, "good_sleep_time" : goodSleepTime};

    var db = FirebaseFirestore.instance;
    db.collection("Users").doc(uid).set(data, SetOptions(merge: true));

    print('업데이트 완료');
    print('취침 시간: $bedHour시 $bedMin분');
    print('적정 수면 시간: $goodSleepHour시 $goodSleepMin분');
  }

    bool isAm = true;

  @override
  Widget build(BuildContext context) {

    List<bool> _isSelected = [isAm, !isAm];
    void toggleSelect(value) {
      print(value);

      if(value == 0){
        isAm = true;
      } else{
        isAm = false;
      }

      setState(() {
        _isSelected = [isAm, !isAm];
        print(_isSelected);
      });
    }

    return AlertDialog(// RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Center(child: Text('수면 정보 수정')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('평균 취침 시간'),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      Column(
                        children: [
                          ToggleButtons(
                              direction: Axis.vertical,
                              isSelected: _isSelected,
                              onPressed: toggleSelect,
                              selectedColor: Colors.black,
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
                      const SizedBox(width: 20,),
                      // 취침 시간 '시'
                      SizedBox(
                        width: 70,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '시',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value){
                            setState(() {
                              print('취침 시간 $value 시');
                              bedHour = int.parse(value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                      const Text(':', style: TextStyle(fontSize: 30),),
                      const SizedBox(width: 10,),
                      // 취침 시간 '분'
                      SizedBox(
                        width: 70,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: '분',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value){
                            setState(() {
                              print('취침 시간 $value 분');
                              bedMin = int.parse(value);
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 50),

                  // 적정 수면 시간을 입력받는 위젯
                  const Text('적정 수면 시간'),
                  Column(
                    children: [
                      const SizedBox(height: 5,),
                      Row(
                        children: [
                          const SizedBox(width: 30,),
                          // 취침 시간 '시'
                          SizedBox(
                            width: 70,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: '시',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value){
                                setState(() {
                                  print('적정수면시간 $value 시');
                                  goodSleepHour = int.parse(value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          const Text('시간', style: TextStyle(fontSize: 15),),
                          const SizedBox(width: 10,),
                          // 취침 시간 '분'
                          SizedBox(
                            width: 70,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: '분',
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value){
                                setState(() {
                                  print('적정수면시간 $value 분');
                                  goodSleepMin = int.parse(value);
                                });
                              },
                            ),
                          ),
                          const SizedBox(width: 10,),
                          const Text('분', style: TextStyle(fontSize: 15),),
                          const SizedBox(width: 10,),
                        ],
                      ),
                    ],
                  ),

                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("취소", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: () {
                  updateSleepInfo(isAm, bedHour, bedMin, goodSleepHour, goodSleepMin);
                  Navigator.pop(context);
                },
                child: const Text('수정', style: TextStyle(color: Colors.redAccent),),
              ),
            ],
          );
        }
  }



class SleepInfo extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const SleepInfo({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  State<SleepInfo> createState() => _SleepInfoState();
}

class _SleepInfoState extends State<SleepInfo> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  

  getUserInfo() async {
    var result = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .get();
    return result.data();
  }

  // 홈 화면에 보여질 수면 정보 위젯
  Widget sleepInfoWidget({required Map<String, dynamic> userData}) {
    double screenWidth = MediaQuery.of(context).size.width;

    // 취침 시간 받아와서
    String avg_bed_time = userData['avg_bed_time'];
    int bedTimeHour = int.parse(avg_bed_time.split(':')[0]);
    int bedTimeMin = int.parse(avg_bed_time.split(':')[1]);

    // 적정 수면 시간 받아와서
    String good_sleep_time = userData['good_sleep_time'];
    int sleepTimeHour = int.parse(good_sleep_time.split(':')[0]);
    int sleepTimeMin = int.parse(good_sleep_time.split(':')[1]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // '수면 정보' + 수정 아이콘
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(' 수면 정보', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),),
            IconButton(
              onPressed: () {
                // 수정화면 보여주는 함수
                _showEditSleepDialog(context);
              },
              icon: const Icon(Icons.edit),
              iconSize: 20,)
          ],
        ),

        // 네모 박스로 이쁘게 감싸줄거야
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 평균 취침 시간
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '평균 취침 시간',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(avg_bed_time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // 구분선 넣어주고
                Center(
                  child: Container(
                    width: screenWidth * 0.85,
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),

                // 적정 수면 시간
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '적정 수면 시간',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(good_sleep_time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            // 사용자 데이터 담아서
            var userData = snapshot.data as Map<String, dynamic>;
            // 있으면 수면 정보 보여주는 위젯에다가 넘겨서 보여주자
            return sleepInfoWidget(userData: userData);
          } else {
            return const Text('No dadta available');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  // 수면 정보 수정 팝업
  void _showEditSleepDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const EditSleepDialog();
      },
    );
  }
}
