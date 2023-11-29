import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/home/user_caffeine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_health_connect/flutter_health_connect.dart';

import '../menu/menu_page.dart';

class DrinkListWidget extends StatefulWidget {
  final bool isControlMode;
  const DrinkListWidget({Key? key, required this.isControlMode}) : super(key: key);

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
          margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
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
                        color: widget.isControlMode ? Colors.black : Colors.white,
                      ),
                    ),
                    Text(
                      '$userName',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffD4936F),
                      ),
                    ),
                    Text(
                      " 님이 마신 카페인 음료",
                      style: TextStyle(
                        fontSize: 20,
                        color: widget.isControlMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
                },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: widget.isControlMode? Color(0xff93796A) : Color(0xffF9F8F7),
                    minimumSize: const Size(20, 20),
                  ),
                  child: Text('+', style: TextStyle(color: widget.isControlMode? Color(0xffF9F8F7) : Color(0xff93796A), fontSize: 22),)),
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
                          color: widget.isControlMode? Colors.black : Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: "300mg ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xffD4936F),
                        ),
                      ),
                      TextSpan(
                        text: "마실 수 있어요!",
                        style: TextStyle(
                          color: widget.isControlMode? Colors.black : Colors.white,
                        ),
                      ),
                    ]
                  )
              ),
            ],
          ),
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