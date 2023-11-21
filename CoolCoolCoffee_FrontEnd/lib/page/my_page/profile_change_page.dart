import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'my_info.dart';
import 'sleep_info.dart';

class ProfileChangePage extends StatefulWidget {
  const ProfileChangePage({super.key});

  @override
  State<ProfileChangePage> createState() => _ProfileChangePageState();
}

class _ProfileChangePageState extends State<ProfileChangePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Colors.brown.withOpacity(0.1),
          width: double.infinity,
          height: double.infinity,

          child: Column(
            children: [
              MyInfo(auth: _auth, firestore: _firestore),
              const SizedBox(height: 40),
              SleepInfo(auth: _auth, firestore: _firestore),
              const SizedBox(height: 40),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(' 선호 브랜드', style: TextStyle(
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
                                const Text('1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                Text('일단 스타벅스', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                Text('일단 투썸', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                Text('일단 이디야', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
