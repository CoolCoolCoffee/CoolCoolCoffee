import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/home/user_caffeine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

import '../menu/menu_page.dart';

class DrinkListWidget extends StatefulWidget {
  const DrinkListWidget({Key? key,}) : super(key: key);

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
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(0,0,10,0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Text(
                      "오늘 ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '$userName',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffD4936F),
                      ),
                    ),
                    Text(
                      "님이 마신 카페인 음료",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      backgroundColor: Color(0xff93796A),
                      minimumSize: const Size(20, 20),
                    ),
                    child: Text('+', style: TextStyle(color: Color(0xffF9F8F7), fontSize: 22),)),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RichText(
                  text : TextSpan(
                    children: [
                      TextSpan(
                        text: "앞으로 ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const TextSpan(
                        text: "300 mg ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffD4936F),
                        ),
                      ),
                      TextSpan(
                        text: "마실 수 있어요!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ]
                  )
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: MediaQuery.of(context).size.width ,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const UserCaffeineList(),
          ),
        ),
      ],
    );
  }
}