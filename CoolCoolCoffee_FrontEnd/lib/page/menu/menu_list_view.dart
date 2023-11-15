import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_add_page.dart';
import 'package:coolcoolcoffee_front/page/menu/star_icon_button.dart';
import 'package:coolcoolcoffee_front/provider/star_provider.dart';
import 'package:coolcoolcoffee_front/service/user_favorite_drink_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuListView extends StatefulWidget {
  final String brandName;
  const MenuListView({super.key, required this.brandName,});

  @override
  State<MenuListView> createState() => _MenuListViewState();
}

class _MenuListViewState extends State<MenuListView> {
  List<bool> _isStared = [];
  @override
  Widget build(BuildContext context) {
    String brand_name = widget.brandName;
    final CollectionReference _menu = FirebaseFirestore.instance.collection('Cafe_brand').doc(brand_name).collection('menus');

    return FutureBuilder(
      future: UserFavoriteDrinkService().getUserFavoriteDrink(),
      builder:(context, snapshot){
        final userFavDrinkList = snapshot.data!['drink_list'];
        return StreamBuilder(
            stream: _menu.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              _isStared.clear();
              if (streamSnapshot.hasData) {
                //_isStared.clear();
                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: streamSnapshot.data!.docs.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot = streamSnapshot.data!
                        .docs[index];
                    UserFavoriteDrink userFavDrink = UserFavoriteDrink(menuId: documentSnapshot.id, brand: brand_name, menuImg: documentSnapshot['menu_img']);
                    if(userFavDrinkList.length != 0){
                      for (var list in userFavDrinkList) {
                        if ((list['brand'] == brand_name) &&
                            (list['menu_id'] == documentSnapshot.id)) {
                          _isStared.add(true);
                        }
                      }
                    }
                    if(_isStared.length == index){
                      _isStared.add(false);
                    }
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            MenuAddPage(menuSnapshot: documentSnapshot,
                              brandName: brand_name,
                              size: '',
                              shot: '',)));
                      },
                      child:
                      Container(
                        //color: Colors.blue,
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
                                          documentSnapshot['menu_img'])
                                  )
                              ),
                            ),
                            Align(
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
                                        _isStared[index]?
                                        Image.asset(
                                          "assets/filled_star.png",
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.fill,
                                        ):
                                        Image.asset(
                                          "assets/star_unfilled_without_outer.png",
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
                                    setState(() {
                                      if(_isStared[index]){
                                        UserFavoriteDrinkService().deleteUserFavoriteDrink(userFavDrink);
                                        //_isStared[index] = !_isStared[index];
                                      }else{
                                        UserFavoriteDrinkService().addNewUserFavoriteDrink(userFavDrink);
                                      }
                                    });
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
                                      brand_name,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey
                                      ),
                                    ),
                                    Text(
                                      documentSnapshot.id,
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
    );
  }
}
