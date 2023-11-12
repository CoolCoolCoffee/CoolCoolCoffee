import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_caffeine.dart';
import 'package:coolcoolcoffee_front/provider/user_caffeine_provider.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserCaffeineList extends StatefulWidget {
  const UserCaffeineList({super.key});

  @override
  State<UserCaffeineList> createState() => _UserCaffeineListState();
}

class _UserCaffeineListState extends State<UserCaffeineList> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
    DateFormat timeFormatter = DateFormat('HH:mm:ss');
    String today = dayFormatter.format(now);
    UserCaffeineService userCaffeineService = UserCaffeineService();
    userCaffeineService.checkExits(today);
    return StreamBuilder(
      stream: userCaffeineService.userCaffeineCollection.doc(today).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          var userCaffeineSnapshot= snapshot.data!;
          if(userCaffeineSnapshot['caffeine_list'].length != 0){
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: userCaffeineSnapshot['caffeine_list'].length,
                itemBuilder: (context, index) {
                  var temp = userCaffeineSnapshot['caffeine_list'][index];
                  UserCaffeine userCaffeine = UserCaffeine(
                      drinkTime: temp['drink_time'],
                      menuId: temp['menu_id'],
                      brand: temp['brand'],
                      menuImg: temp['menu_img'],
                      menuSize: temp['menu_size'],
                      shotAdded: temp['shot_added'],
                      caffeineContent: temp['caffeine_content']);
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      //color: Colors.blue,
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            heightFactor: 0.9,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3 - 5,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.7),
                                        spreadRadius: 0,
                                        blurRadius: 5.0,
                                        offset: Offset(0, 5))
                                  ],
                                  //color: Colors.green,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          NetworkImage(userCaffeine.menuImg))),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: 0.3,
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width / 3 - 5,
                                alignment: Alignment.bottomLeft,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.7),
                                          spreadRadius: 0,
                                          blurRadius: 5.0,
                                          offset: Offset(0, 5))
                                    ]),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      userCaffeine.brand,
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.grey),
                                    ),
                                    Text(
                                      userCaffeine.menuId,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                });
          }else{
            return Center(
              child: Text(
                  '아직 커피를 안 마셨어요!',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            );
          }
        }
        else{
          return Text('failed');
        }
      },
    );
  }
}
