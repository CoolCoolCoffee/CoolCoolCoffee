import 'package:flutter/material.dart';

import '../../model/user_caffeine.dart';
import '../../service/user_caffeine_service.dart';

class CalendarDrinkListWidget extends StatefulWidget {
  final DateTime selectedDay;
  CalendarDrinkListWidget({required this.selectedDay});
  @override
  _CalendarDrinkListWidgetState createState() => _CalendarDrinkListWidgetState();
}

class _CalendarDrinkListWidgetState extends State<CalendarDrinkListWidget> {

  @override
  Widget build(BuildContext context) {
    String selecteddate = widget.selectedDay!.toLocal().toIso8601String().split('T')[0];
    UserCaffeineService userCaffeineService = UserCaffeineService();
    userCaffeineService.checkExits(selecteddate);
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          '${selecteddate}에 마신 음료',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
        ),
        Container(
          height: 100,
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
          child: StreamBuilder(
            stream: userCaffeineService.userCaffeineCollection.doc(selecteddate).snapshots(),
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
                            heightFactor: 1,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 4 - 10,
                              height:  MediaQuery.of(context).size.width / 4 - 10,
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
                              width: MediaQuery.of(context).size.width / 4 - 10,
                              height:  MediaQuery.of(context).size.width / 4 - 10,
                              alignment: Alignment.bottomLeft,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20)
                                ),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    spreadRadius: 0,
                                    blurRadius: 5.0,
                                    offset: Offset(0, 5)
                                  )
                                ]
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment:
                                CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    userCaffeine.brand,
                                    style: TextStyle(
                                    fontSize: 5, color: Colors.grey),
                                  ),
                                  Text(
                                    userCaffeine.menuId,
                                    style: TextStyle(
                                      fontSize: 7,
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
                    '커피를 마시지 않았어요!',
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
        ),
                  // child: Center(
          //   child: Text(
          //     '${selecteddate}에 마신 음료',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 18.0,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
        ),
      ],
    );
  }
}

