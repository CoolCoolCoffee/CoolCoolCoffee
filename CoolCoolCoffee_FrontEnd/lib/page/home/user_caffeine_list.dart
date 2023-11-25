import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_caffeine.dart';
import 'package:coolcoolcoffee_front/page/home/user_caffeine_detail_page.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:coolcoolcoffee_front/provider/user_caffeine_provider.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class UserCaffeineList extends ConsumerStatefulWidget {
  const UserCaffeineList({super.key});

  @override
  _UserCaffeineListState createState() => _UserCaffeineListState();
}

class _UserCaffeineListState extends ConsumerState<UserCaffeineList> {
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateFormat dayFormatter = DateFormat('yyyy-MM-dd');
    DateFormat timeFormatter = DateFormat('HH:mm:ss');
    String today = dayFormatter.format(now);
    UserCaffeineService userCaffeineService = UserCaffeineService();
    userCaffeineService.checkExits(today);
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Users').doc(userCaffeineService.uid).collection('user_caffeine').doc(today).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          var userCaffeineSnapshot= snapshot.data!;
          if(userCaffeineSnapshot['caffeine_list'].length == 0) ref.watch(sleepParmaProvider.notifier).clearCaffList();
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
                  ref.watch(sleepParmaProvider.notifier).addCaffList(userCaffeine);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) =>
                          UserCaffeineDetailPage(userCaffeine: userCaffeine, date: today,))
                      );
                    },
                    child: Container(
                      //color: Colors.blue,
                      child: Stack(
                        children: [
                            Container(
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
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(top: 5,left: 5),
                                height: 10,
                                width: 10,
                                child:
                                //StarIconButton(isStared: _isStared[index], callback: _changeStaredCallback, index: index, userFavoriteDrink: userFavDrink,),
                                IconButton(
                                  icon: Icon(Icons.delete,color: Colors.white,), onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (
                                      context) =>
                                      UserCaffeineDetailPage(userCaffeine: userCaffeine, date: today,))
                                  );
                                },
                                ),
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
          return CircularProgressIndicator(color: Colors.blue,);
        }
      },
    );
  }
}
