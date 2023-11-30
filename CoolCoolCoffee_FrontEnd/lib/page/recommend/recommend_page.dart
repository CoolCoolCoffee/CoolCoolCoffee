import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../menu/menu_add_page.dart';

class RecommendPage extends ConsumerStatefulWidget {
  const RecommendPage({super.key});

  @override
  _RecommendPageState createState() => _RecommendPageState();
}

class _RecommendPageState extends ConsumerState<RecommendPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  var db = FirebaseFirestore.instance;
  int userCaffeine = 0;
  // 나중에 마실 수 있는 카페인 값 받아오기

  @override
  Widget build(BuildContext context) {
    userCaffeine = ref.watch(sleepParmaProvider).recommendCaff;
    /*var userFavBrand;
    var wait = FirebaseFirestore.instance.collection('Users').doc('ZZDgEPAMHTeb57Ox1aSgtqOXpMB2').collection('user_favorite').doc('favorite_brand').get().then((value){
      userFavBrand = value['brand_list'];
      print(userFavBrand);
    });
    print("$userFavBrand  dfdfdfdfd");*/
    return Scaffold(
        backgroundColor: Colors.brown.withOpacity(0.1),
        appBar: AppBar(
          title: const Text('추천', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          toolbarHeight: 50,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 12,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                      '앞으로 $userCaffeine mg 마실 수 있어요!',
                    style: const TextStyle(
                      fontSize: 20
                    ),
                  ),
              ),
            ),
            StreamBuilder(
                stream: db.collection('Users').doc(uid).collection('user_favorite').doc('favorite_brand').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    var userFavoriteBrandList = snapshot.data!;
                    var brand_list = userFavoriteBrandList['brand_list'];
                    //print(brand_list);
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for(var brand in brand_list)
                            SizedBox(
                              height: MediaQuery.of(context).size.height *(2/9),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Text(
                                        "  $brand 추천 메뉴",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ),
                                  StreamBuilder(
                                    stream: db.collection('Cafe_brand').doc(brand)
                                        .collection('menus')
                                        .where('caffeine', isLessThanOrEqualTo: userCaffeine)
                                        .where('caffeine',isGreaterThan: userCaffeine-50)
                                        .limit(3).snapshots(),
                                    builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot){
                                      if(streamSnapshot.hasData){
                                        return GridView.builder(
                                          shrinkWrap: true,
                                          itemCount: streamSnapshot.data!.docs.length,
                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            childAspectRatio: 1,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 5,
                                          ),
                                          itemBuilder: (context, index){
                                            final DocumentSnapshot documentSnapshot = streamSnapshot.data!.docs[index];
                                            return GestureDetector(
                                              onTap: (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => MenuAddPage(menuSnapshot: documentSnapshot, brandName: brand, size: documentSnapshot['basic_size'], shot: '',)));
                                              },
                                              child:
                                                Container(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.all(5),
                                                        decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: [BoxShadow(
                                                          color: Colors.grey.withOpacity(0.7),
                                                          spreadRadius: 0,
                                                          blurRadius: 5.0,
                                                          offset: const Offset(0,5)
                                                        )],
                                                        //color: Colors.green,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(documentSnapshot['menu_img'])
                                                        )
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomCenter,
                                                      child: Container(
                                                      alignment: Alignment.bottomLeft,
                                                      height: 40,
                                                      margin: const EdgeInsets.all(5),
                                                      decoration: BoxDecoration(
                                                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20)),
                                                        color: Colors.white,
                                                        boxShadow: [BoxShadow(
                                                        color: Colors.grey.withOpacity(0.7),
                                                        spreadRadius: 0,
                                                        blurRadius: 5.0,
                                                        offset: const Offset(0,5)
                                                        )]
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          Text(
                                                            brand,
                                                            style: const TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.grey
                                                            ),
                                                          ),
                                                         Text(
                                                             documentSnapshot.id,
                                                           maxLines: 1,
                                                         ),
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
                                      else{
                                        return const CircularProgressIndicator(color: Colors.blue,);
                                      }
                                   },
                                  ),
                                ],
                              ),
                            ),
                        ],
                    );
                  }
                  else{
                    return Container(
                      color: Colors.transparent,
                    );
                  }
                }
            )
          ],
        )
    );
  }
}
