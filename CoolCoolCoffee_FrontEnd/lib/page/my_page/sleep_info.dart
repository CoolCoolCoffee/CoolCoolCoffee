import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Widget sleepInfoWidget({required Map<String, dynamic> userData}) {
    double screenWidth = MediaQuery.of(context).size.width;

    String avg_bed_time = userData['avg_bed_time'];
    int bedTimeHour = int.parse(avg_bed_time.split(':')[0]);
    int bedTimeMin = int.parse(avg_bed_time.split(':')[1]);

    String good_sleep_time = userData['good_sleep_time'];
    int sleepTimeHour = int.parse(avg_bed_time.split(':')[0]);
    int sleepTimeMin = int.parse(avg_bed_time.split(':')[1]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 수면 정보 위젯
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(' 수면 정보', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),),
            IconButton(
              onPressed: () {
                showEditSleepDialog(context, bedTimeHour, bedTimeMin, sleepTimeHour, sleepTimeMin);
              },
              icon: const Icon(Icons.edit),
              iconSize: 20,)
          ],
        ),
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
                Center(
                  child: Container(
                    width: screenWidth * 0.85,
                    height: 1,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),
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

  void showEditSleepDialog(BuildContext context, int bedTimeHour, int bedTimeMin, int sleepTimeHour, int sleepTimeMin) {
    int bedHour = bedTimeHour;
    int bedMin = bedTimeHour;
    int goodSleepHour = sleepTimeHour;
    int goodSleepMin = sleepTimeMin;

    TextEditingController _bedHourController = TextEditingController();
    TextEditingController _bedMinController = TextEditingController();
    TextEditingController _goodSleepHourController = TextEditingController();
    TextEditingController _goodSleepMinController = TextEditingController();

    bool isAM = true;
    void toggleSelect(int index) {
      setState(){
        if(index == 0){
          isAM = true;
        } else{
          isAM = false;
        }
      }
    }

    void updateSleepInfo(bool isAM, int bedHour, int bedMin, int goodSleepHour, int goodSleepMin) {
      int bedH = bedHour; int bedM = bedMin; int sleepM = goodSleepMin;
      if(!isAM){
        bedH = bedH+12;
      }

      String bedTime = '${bedHour.toString()}:${bedMin.toString().padLeft(2, '0')}';
      String goodSleepTime = '${goodSleepHour.toString()}:${goodSleepMin.toString().padLeft(2, '0')}';

      final data = {'avg_bed_time' : bedTime, "good_sleep_time" : goodSleepTime};

      var db = FirebaseFirestore.instance;

      final userRef = db
          .collection("Users")
          .doc(uid)
          .set(data, SetOptions(merge: true));

      print('업데이트 완료');
      print('취침 시간: $bedHour시 $bedMin분');
      print('적정 수면 시간: $goodSleepHour시 $goodSleepMin분');
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Center(child: Text('수면 정보 수정')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('평균 취침 시간'),
                  Row(
                    children: [
                      Column(
                        children: [
                          ToggleButtons(
                              direction: Axis.vertical,
                              isSelected: [isAM, !isAM],
                              onPressed: toggleSelect,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text('AM', style: TextStyle(fontSize: 16),),),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                          controller: _bedHourController,
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
                          controller: _bedMinController,
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
                  const SizedBox(height: 60),

                  // 적정 수면 시간을 입력받는 위젯
                  const Text('적정 수면 시간'),
                  Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 50,),
                          // 취침 시간 '시'
                          SizedBox(
                            width: 70,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: _goodSleepHourController,
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
                              controller: _goodSleepMinController,
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
                  updateSleepInfo(isAM, bedHour, bedMin, goodSleepHour, goodSleepMin);
                  Navigator.pop(context);
                },
                child: const Text('수정', style: TextStyle(color: Colors.redAccent),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(), // 이 부분은 변경하지 않아도 됩니다.
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var userData = snapshot.data as Map<String, dynamic>;

            return sleepInfoWidget(userData: userData);
          } else {
            return Text('No dadta available');
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
