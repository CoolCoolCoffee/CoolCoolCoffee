import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_caffeine.dart';
import 'package:coolcoolcoffee_front/page/home/user_caffeine_detail_page.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:coolcoolcoffee_front/provider/user_caffeine_provider.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../menu/menu_page.dart';

class UserCaffeineList extends ConsumerStatefulWidget {
  const UserCaffeineList({super.key,});

  @override
  _UserCaffeineListState createState() => _UserCaffeineListState();
}

class _UserCaffeineListState extends ConsumerState<UserCaffeineList> {
  DateTime now = DateTime.now();
  DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
  String date = '';
  //DateFormat timeFormatter = DateFormat('HH:mm:ss');
  @override
  void initState() {
    super.initState();
    _initializeSleepParam();
  }
  Future<void> _initializeSleepParam() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime today = DateTime.now();
    int now_hour = today.hour;
    String todaydate = today.toLocal().toIso8601String().split('T')[0];

    DateTime yesterday = today.subtract(Duration(days: 1));
    String yesterdaydate = yesterday.toLocal().toIso8601String().split('T')[0];

    DocumentSnapshot<Map<String, dynamic>> userSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(todaydate).get();

    DocumentSnapshot<Map<String, dynamic>> yesUserSleepDoc =
    await FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_sleep').doc(yesterdaydate).get();
    //오늘의 수면 정보 받아오기
    if(now_hour<6){
      if (userSleepDoc.exists &&
          userSleepDoc.data()!.containsKey('wake_time') &&
          userSleepDoc.data()!.containsKey('sleep_quality_score')) {
      }
      //오늘 꺼가 없으면 어제꺼로
      else if (yesUserSleepDoc.exists &&
          yesUserSleepDoc.data()!.containsKey('wake_time') &&
          yesUserSleepDoc.data()!.containsKey('sleep_quality_score')) {
        setState(() {
          now = yesterday;
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    date = dayFormatter.format(now);
    print('caff build');
    /*DateTime now = DateTime.now();
    DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
    DateFormat timeFormatter = DateFormat('HH:mm:ss');
    String today = dayFormatter.format(now);*/
    UserCaffeineService userCaffeineService = UserCaffeineService();
    userCaffeineService.checkExits(date);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').doc(userCaffeineService.uid).collection('user_caffeine').doc(date).snapshots(),
      builder: (context, snapshot){
        ref.watch(sleepParmaProvider.notifier).clearCaffList();
        print('바뀜???????????/');
        if(snapshot.hasData){
          var userCaffeineSnapshot= snapshot.data!;
          if(userCaffeineSnapshot['caffeine_list'].length != 0){
            print('카페인 리스트 삭제');
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userCaffeineSnapshot['caffeine_list'].length,
                itemBuilder: (context, index) {
                  var temp = userCaffeineSnapshot['caffeine_list'][index];
                  print('카페인 추가요~~ , ${temp['menu_id']}');
                  UserCaffeine userCaffeine = UserCaffeine(
                      drinkTime: temp['drink_time'],
                      menuId: temp['menu_id'],
                      brand: temp['brand'],
                      menuImg: temp['menu_img'],
                      menuSize: temp['menu_size'],
                      shotAdded: temp['shot_added'],
                      caffeineContent: temp['caffeine_content']);
                  ref.watch(sleepParmaProvider.notifier).addCaffList(userCaffeine);
                  print('${temp['menu_id']} 추가함요');
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) =>
                          UserCaffeineDetailPage(userCaffeine: userCaffeine, date: date,))
                      );
                    },
                    child: Stack(
                      children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3 - 5,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.7),
                                      spreadRadius: 0,
                                      blurRadius: 5.0,
                                      offset: const Offset(0, 5))
                                ],
                                //color: Colors.green,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        NetworkImage(userCaffeine.menuImg))),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.only(top: 5,left: 5),
                              height: 10,
                              width: 10,
                              child:
                              IconButton(
                                icon: const Icon(Icons.delete,color: Colors.white,), onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (
                                    context) =>
                                    UserCaffeineDetailPage(userCaffeine: userCaffeine, date: date,))
                                );
                              },
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: 0.4,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3 - 5,
                                alignment: Alignment.bottomLeft,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                        bottomRight: Radius.circular(20)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 0,
                                          blurRadius: 5.0,
                                          offset: const Offset(0, 5))
                                    ]),
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Center(
                                        child: Text(
                                          userCaffeine.brand,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          userCaffeine.menuId,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  );
                });
          } else {
            return const Center(
              child: Text('오늘 마신 음료가 없어요!', style: TextStyle(fontSize: 20),),
            );
          }
        }
        else{
          return const CircularProgressIndicator(color: Colors.blue,);
        }
      },
    );
  }
}
