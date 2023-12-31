import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/menu/conveni_add_page.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/user_favorite_drink.dart';
import '../../provider/star_provider.dart';
import '../../service/user_favorite_drink_service.dart';
import 'menu_add_page_shot.dart';

class StarPage extends ConsumerWidget {
  final Function starCallback;
  const StarPage({super.key, required this.starCallback});
  Future<void> _fetchBrand(DocumentSnapshot documentSnapshot, BuildContext context, String brand) async{
    DocumentSnapshot<Map<String,dynamic>> brandDoc =
    await FirebaseFirestore.instance.collection('Cafe_brand').doc(brand).get();
    var brandDocument = brandDoc;
    Navigator.push(context, MaterialPageRoute(builder: (
        context) =>
        MenuAddPageShot(menuSnapshot: documentSnapshot,
          brandSnapshot: brandDocument,
          size: '',
          shot: '',)));
    //setState(() {});
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserFavoriteDrinkService userFavoriteDrinkService = UserFavoriteDrinkService();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        title: Text(
          '즐겨찾기',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection('Users').doc(uid).collection('user_favorite').doc('favorite_drink').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var userFavoriteDrinkList = snapshot.data!;
            if(userFavoriteDrinkList['drink_list'].length == 0){
              return Center(child: Text('즐겨찾기에 등록된 메뉴가 없습니다.'));
            }
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
                    if(temp['brand']=='편의점'){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ConveniAddPage(menuSnapshot: documentSnapshot, brandName: temp['brand'])));
                    }
                    else{
                      _fetchBrand(documentSnapshot,context,temp['brand']);
                    }
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
                                userFavoriteDrinkService.deleteUserFavoriteDrink(userFavDrink);
                                starCallback('${userFavDrink.brand}_${userFavDrink.menuId}');
                                //ref.watch(starsProvider.notifier).remove('${userFavDrink.brand}_${userFavDrink.menuId}');
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
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    userFavDrink.brand,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    userFavDrink.menuId,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
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
              },

            );
          }
          else {
            return Text('즐겨찾기에 등록된 메뉴가 없습니다.');
          }
        },
      ),
    );
  }
}
