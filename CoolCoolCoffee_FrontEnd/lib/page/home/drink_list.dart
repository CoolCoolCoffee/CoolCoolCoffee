import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/home/user_caffeine_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../function/mode_color.dart';
import '../../provider/color_mode_provider.dart';
import '../menu/menu_page.dart';

class DrinkListWidget extends ConsumerStatefulWidget {
  const DrinkListWidget({Key? key,}) : super(key: key);

  @override
  _DrinkListWidgetState createState() => _DrinkListWidgetState();
}

class _DrinkListWidgetState extends ConsumerState<DrinkListWidget> {
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
          margin: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Text(
                      "오늘 ",
                      style: TextStyle(
                        fontSize: 22,
                        color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['black_color']:modeColor.noSleepModeColor['white_color'],
                      ),
                    ),
                    Text(
                      '$userName',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: ref.watch(colorModeProvider).isControlMode ? modeColor.controlModeColor['sub_color']:modeColor.noSleepModeColor['sub_color'],
                      ),
                    ),
                    Text(
                      " 님이 마신 카페인 음료   ",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['black_color']:modeColor.noSleepModeColor['white_color'],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                //margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPage()));
                  },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      backgroundColor: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['main_color']:modeColor.noSleepModeColor['main_color'],
                      minimumSize: const Size(20, 20),
                    ),
                    child: Center(child: Text('추가', style: TextStyle(color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['background_color']:modeColor.noSleepModeColor['background_color'], fontSize: 18),))),
              ),
            ],
          ),
        ),
        const SizedBox(height: 7),
        Center(
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            width: MediaQuery.of(context).size.width ,
            height: 130,
            decoration: BoxDecoration(
              color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['white_color']:modeColor.noSleepModeColor['light_brown_color'],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const UserCaffeineList(),
          ),
        ),
      ],
    );
  }
}