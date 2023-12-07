import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/provider/short_term_noti_provider.dart';
import 'package:coolcoolcoffee_front/provider/sleep_param_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../function/mode_color.dart';
import '../../provider/color_mode_provider.dart';
import '../menu/conveni_add_page.dart';
import '../menu/menu_add_page_shot.dart';

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

  Future<void> _fetchBrand(DocumentSnapshot documentSnapshot, String brand) async{
    DocumentSnapshot<Map<String,dynamic>> brandDoc =
    await FirebaseFirestore.instance.collection('Cafe_brand').doc(brand).get();
    var brandDocument = brandDoc;
    Navigator.push(context, MaterialPageRoute(builder: (
        context) =>
        MenuAddPageShot(menuSnapshot: documentSnapshot,
          brandSnapshot: brandDocument,
          size: documentSnapshot['basic_size'],
          shot: '',)));
    //setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    userCaffeine = ref.watch(sleepParmaProvider).recommendCaff;
    return Scaffold(
        backgroundColor: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['background_color']:modeColor.noSleepModeColor['background_color'],
        appBar: AppBar(
          title: const Text('추천', style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            fontSize: 24,
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
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                  child: ref.watch(colorModeProvider).isControlMode?
                        Text('$userCaffeine mg 까지 마실 수 있어요!',
                            style: const TextStyle(fontSize: 20, color: Colors.black,)) :
                        Text('밤샘을 위해 $userCaffeine mg 이상 마셔봐요!',
                            style: const TextStyle(fontSize: 20, color: Colors.black,)),
              ),
            ),
            StreamBuilder(
                stream: db.collection('Users').doc(uid).collection('user_favorite').doc('favorite_brand').snapshots(),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    var userFavoriteBrandList = snapshot.data!;
                    var brand_list = userFavoriteBrandList['brand_list'];
                    //print(brand_list);
                    return Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
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
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                          color: ref.watch(colorModeProvider).isControlMode?modeColor.controlModeColor['black_color']:modeColor.noSleepModeColor['white_color'],
                                        ),
                                      ),
                                    ),
                                    StreamBuilder(
                                      stream: ref.watch(shortTermNotiProvider).isControlMode?
                                      db.collection('Cafe_brand').doc(brand)
                                          .collection('menus')
                                          .where('caffeine', isLessThanOrEqualTo: userCaffeine)
                                          .where('caffeine',isGreaterThan: userCaffeine-100)
                                          .limit(3).snapshots():
                                      db.collection('Cafe_brand').doc(brand)
                                          .collection('menus')
                                          .where('caffeine', isLessThanOrEqualTo: userCaffeine+100)
                                          .where('caffeine',isGreaterThan: userCaffeine)
                                          .limit(3).snapshots()
                                      ,
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
                                                  if(brand =='편의점'){
                                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ConveniAddPage(menuSnapshot: documentSnapshot, brandName: brand)));
                                                  }else {
                                                    _fetchBrand(documentSnapshot,brand);
                                                  }
                                                  },
                                                child:
                                                  Stack(
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
                                                      height: 50,
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
                                                      child: Container(
                                                        margin: const EdgeInsets.all(3),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                                          children: [
                                                            Center(
                                                              child: Text(
                                                                brand,
                                                                style: const TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.grey,
                                                                  overflow: TextOverflow.ellipsis,
                                                                ),
                                                              ),
                                                            ),
                                                           Center(
                                                             child: Text(
                                                                 documentSnapshot.id,style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis,),
                                                               maxLines: 1,
                                                             ),
                                                           ),
                                                          ],
                                                          ),
                                                      ),
                                                     ),
                                                    )
                                                  ],
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
                      ),
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
