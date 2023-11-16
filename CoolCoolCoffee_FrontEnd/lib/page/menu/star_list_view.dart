import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:coolcoolcoffee_front/service/user_favorite_drink_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'menu_add_page.dart';

class StarListView extends StatefulWidget {
  const StarListView({super.key});

  @override
  State<StarListView> createState() => _StarListViewState();
}

class _StarListViewState extends State<StarListView> {

  @override
  Widget build(BuildContext context) {
    final UserFavoriteDrinkService userFavoriteDrinkService = UserFavoriteDrinkService();
    userFavoriteDrinkService.checkExits();
    return StreamBuilder(
      stream: userFavoriteDrinkService.userFavoriteDrinkCollection.doc('favorite_drink').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var userFavoriteDrinkList = snapshot.data!;
          return GridView.builder(
            shrinkWrap: true,
            itemCount: userFavoriteDrinkList['drink_list'].length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              var temp = userFavoriteDrinkList['drink_list'][index];
              var documentSnapshot;
              var wait = FirebaseFirestore.instance.collection('Cafe_brand').doc(temp['brand']).collection('menus').doc(temp['menu_id']).snapshots();
              wait.forEach((element) {documentSnapshot = element;});
              UserFavoriteDrink userFavDrink = UserFavoriteDrink(menuId: temp['menu_id'], brand: temp['brand'], menuImg: temp['menu_img']);
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (
                      context) =>
                      MenuAddPage(menuSnapshot: documentSnapshot,
                        brandName: temp['brand'],
                        size: '',
                        shot: '',)));
                },
                child: //SingleChildScrollView(
                //scrollDirection: Axis.vertical,
                //child:
                Container(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(
                                color: Colors.grey.withOpacity(0.7),
                                spreadRadius: 0,
                                blurRadius: 5.0,
                                offset: Offset(0, 5)
                            )
                            ],
                            //color: Colors.green,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    userFavDrink.menuImg)
                            )
                        ),
                      ),Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.only(top: 5, right: 5),
                          height: 50,
                          width: 50,
                          child:
                          //StarIconButton(isStared: _isStared[index], callback: _changeStaredCallback, index: index, userFavoriteDrink: userFavDrink,),
                          IconButton(
                            icon: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    "assets/filled_star.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                  Image.asset(
                                    "assets/star_unfilled_with_outer.png",
                                    width: 20,
                                    height: 20,
                                    fit: BoxFit.fill,
                                  ),
                                ]
                            ),
                            onPressed: () {
                              UserFavoriteDrinkService().deleteUserFavoriteDrink(userFavDrink);
                            },
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          height: 50,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20)),
                              color: Colors.white,
                              boxShadow: [BoxShadow(
                                  color: Colors.grey.withOpacity(0.7),
                                  spreadRadius: 0,
                                  blurRadius: 5.0,
                                  offset: Offset(0, 5)
                              )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                userFavDrink.brand,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey
                                ),
                              ),
                              Text(
                                userFavDrink.menuId,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },

          );
        }
        else {
          return Text('failed');
        }
      },
    );
  }
}