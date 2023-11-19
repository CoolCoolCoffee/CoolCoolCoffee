import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/model/menu.dart';
import 'package:coolcoolcoffee_front/model/user_favorite_drink.dart';
import 'package:coolcoolcoffee_front/page/menu/menu_add_page.dart';
import 'package:coolcoolcoffee_front/provider/star_provider.dart';
import 'package:coolcoolcoffee_front/service/user_favorite_drink_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/star.dart';

class MenuListView extends ConsumerStatefulWidget {
  //final String brandName;
  const MenuListView({Key? key, this.brandName}) : super(key: key);
  final brandName;

  @override
  MenuListViewState createState() => MenuListViewState();
}
class MenuListViewState extends ConsumerState<MenuListView>{
  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.watch(starsProvider);
      final userFavDrinkList = UserFavoriteDrinkService().getUserFavoriteDrink().then((value) {
        for(var drink in value['drink_list']){
          ref.watch(starsProvider.notifier).add(Star(id: drink['brand'] + '_'+drink['menu_id']));
        }
      });
    });
  }
  @override
  Widget build(BuildContext context){
    final String brandName = widget.brandName;
    final CollectionReference _menu = FirebaseFirestore.instance.collection('Cafe_brand').doc(brandName).collection('menus');

          return StreamBuilder(
            stream: _menu.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              //_isStared.clear();
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
                    UserFavoriteDrink userFavDrink = UserFavoriteDrink(menuId: documentSnapshot.id, brand: brandName, menuImg: documentSnapshot['menu_img']);

                    //print(reisStared);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            MenuAddPage(menuSnapshot: documentSnapshot,
                              brandName: brandName,
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
                                        ref.watch(starsProvider.notifier).isStar('${brandName}_${documentSnapshot.id}')?
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
                                    bool isStared = ref.watch(starsProvider.notifier)
                                        .isStar('${brandName}_${documentSnapshot
                                        .id}');
                                    print('before : ${isStared}');
                                    if (isStared) {
                                      setState(() {
                                        UserFavoriteDrinkService()
                                            .deleteUserFavoriteDrink(
                                            userFavDrink);
                                        ref
                                            .watch(starsProvider.notifier)
                                            .remove(
                                            '${userFavDrink
                                                .brand}_${userFavDrink
                                                .menuId}');
                                        String id = userFavDrink.brand + '_' +
                                            userFavDrink.menuId;
                                        print('after : ${userFavDrink
                                            .menuId}  ${userFavDrink
                                            .brand}  ${ref.watch(
                                            starsProvider.notifier).isStar(
                                            id)}');
                                      });
                                    } else {
                                      setState(() {
                                        UserFavoriteDrinkService()
                                            .addNewUserFavoriteDrink(
                                            userFavDrink);
                                        ref.watch(starsProvider.notifier).add(
                                            Star(id: '${userFavDrink
                                                .brand}_${userFavDrink
                                                .menuId}'));
                                        String id = userFavDrink.brand + '_' +
                                            userFavDrink.menuId;
                                        print('after : ${userFavDrink
                                            .menuId}  ${userFavDrink
                                            .brand}  ${ref.watch(
                                            starsProvider.notifier).isStar(
                                            id)}');
                                      });
                                    }
                                  }
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
                                      brandName,
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
                return Center(child: Container(
                  child: CircularProgressIndicator(color: Colors.blue,),
                  height: 50,
                  width: 50,
                ));
              }
            },
          );

  }
}


