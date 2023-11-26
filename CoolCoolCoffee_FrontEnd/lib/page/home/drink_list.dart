import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/home/user_caffeine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

import '../menu/menu_page.dart';

class DrinkListWidget extends StatefulWidget {
  const DrinkListWidget({Key? key}) : super(key: key);

  @override
  _DrinkListWidgetState createState() => _DrinkListWidgetState();
}

class _DrinkListWidgetState extends State<DrinkListWidget> {
  String? userName;

  Future<void> fetchUserName() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      setState(() {
        userName = userSnapshot['user_name'];
      });
    } catch (error) {
      print('Error : $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }


  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              //"    오늘 쿨쿨님이 마신 카페인 음료",
              "오늘 ${userName ?? '님'} 님이 마신 카페인 음료",
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
              },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown.withOpacity(0.2),
                  minimumSize: Size(20, 20),
                ),
                child: Text('+')),
          ],
        ),
        RichText(
            text : TextSpan(
              children: [
                TextSpan(
                  text: "앞으로 ",
                  style: TextStyle(
                    color: Colors.black
                  ),
                ),
                TextSpan(
                  text: "300mg ",
                  style: TextStyle(
                      color: Colors.orange
                  ),
                ),
                TextSpan(
                  text: "마실 수 있어요!",
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ]
            )
        ),
        SizedBox(height: 7),
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width ,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: UserCaffeineList(),
          ),
        ),
      ],
    );
  }
}