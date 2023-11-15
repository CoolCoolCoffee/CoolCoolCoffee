import 'package:flutter/material.dart';

class ProfileChangePage extends StatefulWidget {
  const ProfileChangePage({super.key});

  @override
  State<ProfileChangePage> createState() => _ProfileChangePageState();
}

class _ProfileChangePageState extends State<ProfileChangePage> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.brown.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('프로필 수정'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('유저 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                  SizedBox(height: 10),
                  Text('사용자 이메일 보여주기'),
                  Text('사용자 닉네임 보여주고, 수정하기 아이콘'),
                  Text('사용자 나이 보여주고, 수정하기 아이콘'),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('수면 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                  SizedBox(height: 10),
                  Text('평균 취침 시간 보여주고, 수정하기 아이콘'),
                  Text('적정 수면 시간 보여주고, 수정하기 아이콘'),
                ],
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('선호 브랜드 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                  SizedBox(height: 10),
                  Text('선호 브랜드 리스트 보여주고, 수정하기 아이콘'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
