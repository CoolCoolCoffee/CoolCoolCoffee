import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coolcoolcoffee_front/page/my_page/profile_change_page.dart';

import '../login/login_page.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String resultText = '';
  String userName = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    super.initState();
    loadUserName();
  }

  // 현재 사용자의 UID 가져오기
  String getCurrentUserUID() {
    String uid = _auth.currentUser?.uid ?? '';
    return uid;
  }

  // 사용자 이름을 가져와서 화면에 업데이트
  void loadUserName() async {
    String? name = await getUserName();
    if (name != null) {
      setState(() {
        userName = name;
      });
    }
  }

  // 사용자의 userName 가져오기
  Future<String?> getUserName() async {
    String uid = getCurrentUserUID();

    try {
      // Firestore에서 Users 컬렉션에서 해당 UID의 문서 가져오기
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      // userName 필드의 값을 가져오기
      String userName = userSnapshot['user_name'];

      return userName;
    } catch (e) {
      print("사용자 이름 가져오기 실패: $e");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor:  Color(0xffF9F8F7),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('마이페이지', style: TextStyle(color: Colors.black),),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 사용자 프로필 위젯
                Column(
                  children: [
                    // 사용자 프로필 캐릭터나 사진..?, 일단 원 모양으로 해놓음
                    Center(
                      child: Container(
                        child: Icon(Icons.person_rounded,color: Colors.white,size: 75,),
                        width: 100.0, // 원의 지름
                        height: 100.0, // 원의 지름
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle, // 원 모양 지정
                          color: Color(0xff725F51), // 원의 색상 지정
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                    Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),),
                  ],
                ),
                const SizedBox(height: 30,),

                // 유저 설정 위젯
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('유저 설정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileChangePage(),
                            ));
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.person, color: Colors.grey), // 아이콘 추가
                          SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격 조절
                          Text(
                            '프로필 수정',
                            style: TextStyle(
                              color: Colors.black,
                                fontSize: 22
                              // 텍스트 색상 설정
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 권한 설정
                    TextButton(
                      onPressed: () {
                        showPermissionDialog(context);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings_accessibility, color: Colors.grey), // 아이콘 추가
                          SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격 조절
                          Text(
                            '권한 설정',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22
                              // 텍스트 색상 설정
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 알림 설정
                    TextButton(
                      onPressed: () {
                        openAppSettings();
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_active, color: Colors.grey), // 아이콘 추가
                          SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격 조절
                          Text(
                            '알림 설정',
                            style: TextStyle(
                              color: Colors.black,
                                fontSize: 22
                              // 텍스트 색상 설정
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 로그아웃
                    TextButton(
                      onPressed: () {
                        showLogoutConfirmationDialog(context);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.exit_to_app, color: Colors.grey), // 아이콘 추가
                          SizedBox(width: 8.0), // 아이콘과 텍스트 사이 간격 조절
                          Text(
                            '로그아웃',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black, // 텍스트 색상 설정
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
                Center(child: Container(width: screenWidth * 0.9, height: 1, color: Colors.grey.withOpacity(0.5))),
              ],
            ),

          ),
        )
    );
  }

  void _updateResultText() {
    setState(() {});
  }

  // 로그아웃 확인 다이얼로그 표시
  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('로그아웃', style: TextStyle(fontSize: 20),),
          content: const Text('정말 로그아웃 하시겠어요?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 로그아웃 처리
                Navigator.of(context).pop();
                _auth.signOut();
              },
              child: const Text('예', style: TextStyle(color: Colors.red),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: const Text('아니오', style: TextStyle(color: Colors.black),),
            ),
          ],
        );
      },
    );
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            backgroundColor: Colors.white,
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Column(
              children: [
                Text("앱 권한 설정", style: TextStyle(fontSize: 20),),
              ],
            ),
            content: const SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text("사용자의 수면 정보 자동 입력을 위하여\n'헬스 커넥트' 어플 설치 및 접근 권한 설정이 필요합니다"),
                  SizedBox(height: 20),
                  Text("* 헬스 커넥트 어플을 설치하시려면"),
                  Text("'설치' 버튼을 눌러주세요"),
                  SizedBox(height: 10),
                  Text("* 헬스 커넥트 접근 권한을 설정하시려면"),
                  Text("'설정' 버튼을 눌러주세요"),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("설치", style: TextStyle(color: Colors.brown,  fontWeight: FontWeight.bold),),
                onPressed: () async {
                  const String url = 'https://play.google.com/store/apps/details?id=com.google.android.apps.healthdata&pcampaignid=web_share';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    // Could not launch the URL
                    resultText = 'Could not launch the Play Store';
                    _updateResultText();
                  }
                },
              ),
              TextButton(
                child: const Text("설정", style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await HealthConnectFactory.isApiSupported();
                  await HealthConnectFactory.isAvailable();
                  try {
                    await HealthConnectFactory.openHealthConnectSettings();
                    resultText = 'Settings activity started';
                  } catch (e) {
                    resultText = e.toString();
                  }
                  _updateResultText();
                },
              ),
              TextButton(
                child: const Text("취소", style: TextStyle(color: Colors.grey)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

}
