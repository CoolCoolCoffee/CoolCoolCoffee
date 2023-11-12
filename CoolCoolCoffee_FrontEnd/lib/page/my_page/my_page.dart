import 'package:coolcoolcoffee_front/page/menu/brand_list_view.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_page.dart';
import 'package:coolcoolcoffee_front/page/login/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('마이 페이지'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('로그인 상태입니다.'),
                SizedBox(height: 50,),
                ElevatedButton(
                    onPressed: (){
                      _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(),
                        ));
                    },
                    child: Text('로그아웃')),
              ],
            ),
          ),
        )
    );

  }
}
