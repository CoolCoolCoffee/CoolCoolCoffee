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
    var result = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return result.data();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: getUserInfo(), // 이 부분은 변경하지 않아도 됩니다.
      builder: (context, snapshot) {
        return snapshot.hasData
            ? Column(
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
                  onPressed: (){
                    // 브랜드 수정
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
                        Text(
                          (snapshot.data as Map)['avg_bed_time'],
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
                        Text(
                          (snapshot.data as Map)['good_sleep_time'],
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
        )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
