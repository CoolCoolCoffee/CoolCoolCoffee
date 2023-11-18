import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileChangePage extends StatefulWidget {
  const ProfileChangePage({super.key});

  @override
  State<ProfileChangePage> createState() => _ProfileChangePageState();
}

class _ProfileChangePageState extends State<ProfileChangePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  String? userEmail;
  String? userName;
  int? userAge;
  String? bedTime;
  String? bedTimeHour;
  String? bedTimeMin;
  String? goodSleepTime;
  String? goodSleepTimeHour;
  String? goodSleepTimeMin;
  List<String>? favoriteBrand;

  getUserInfo() async {
    var result = await FirebaseFirestore.instance.collection('Users').doc(_user?.uid).get();
    return result.data();
  }

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('프로필 수정', style: TextStyle(color: Colors.black),),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.brown.withOpacity(0.1),
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder(
          future: getUserInfo(),
          builder: (context, snapshot) {
            return
              snapshot.hasData?
              Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    //  유저 정보 위젯
                    const Text(' 유저 정보', style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),),
                    const SizedBox(height: 10),
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
                                  const Text('닉네임', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['user_name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('이메일', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['user_email'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('나이', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['user_age'].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // 수면 정보 위젯
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(' 수면 정보', style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),),
                        IconButton(
                          onPressed: (){
                            sleepEdit();
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
                                  const Text('평균 취침 시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['avg_bed_time'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('적정 수면 시간', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['good_sleep_time'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // 선호 브랜드 정보
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(' 선호 브랜드', style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),),
                        IconButton(
                          onPressed: (){
                            brandEdit();
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
                                  const Text('1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['avg_bed_time'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['good_sleep_time'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                  Text((snapshot.data as Map)['good_sleep_time'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                  : const Center(child: CircularProgressIndicator());
          }
        ),
      ),
    );
  }

}


void sleepEdit(){
  return print('수면 수정 누름');
}

void brandEdit(){
  return print('브랜드 수정 누름');
}
