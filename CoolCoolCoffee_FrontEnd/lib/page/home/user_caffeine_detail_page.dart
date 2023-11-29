import 'package:coolcoolcoffee_front/model/user_caffeine.dart';
import 'package:coolcoolcoffee_front/service/user_caffeine_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCaffeineDetailPage extends StatelessWidget {
  final UserCaffeine userCaffeine;
  final String date;
  const UserCaffeineDetailPage({super.key, required this.userCaffeine, required this.date});

  @override
  Widget build(BuildContext context) {
    final UserCaffeineService userCaffeineService = UserCaffeineService();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          "${formatTime(userCaffeine.drinkTime)}에 마신 음료",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete,color: Colors.blue,),
            onPressed: (){
              userCaffeineService.deleteUserCaffeine(date, userCaffeine);
              Navigator.pop(context);
           },

          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 50,right: 50),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userCaffeine.menuImg)
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      height: 80,
                      margin: EdgeInsets.only(right: 50,left: 50),
                      decoration: BoxDecoration(
                        //border: Border.all(color: Colors.grey,width: 1),
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                          color: Colors.white,
                          boxShadow: [BoxShadow(
                              color: Colors.grey.withOpacity(0.7),
                              spreadRadius: 0,
                              blurRadius: 5.0,
                              offset: Offset(0,5)
                          )]
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start ,
                        children: [
                          Container(height: 5,),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              userCaffeine.brand,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              userCaffeine.menuId,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          )],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(height: 20,),
                Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('사이즈',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                        Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text(userCaffeine.menuSize,style: TextStyle(fontSize: 20),)),
                      ],
                    )
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('샷 조절',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text(userCaffeine.shotAdded.toString(),style: TextStyle(fontSize: 20),)),
                  ],
                )
            ),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text('카페인 함량',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                    Container(padding: EdgeInsets.only(left: 5,bottom: 10),child: Text(userCaffeine.caffeineContent.toString(),style: TextStyle(fontSize: 20),)),
                  ],
                )
            ),
          ),
        ],
      ),
    );
  }
  String formatTime(String time){
    bool isAM = false;
    var split = time.split(' ');
    var timeComponents = split[0].split(':');
    String hour = timeComponents[0];
    if(int.parse(hour)<12) {
      isAM = true;
    }else {
      hour = (int.parse(hour)-12).toString();
    }
      String ret = hour +':'+ timeComponents[1] + (isAM ? ' AM':' PM');
      return ret;
    }
  }
