import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login/brand_btn.dart';

class BrandInfo extends StatefulWidget {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  const BrandInfo({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  State<BrandInfo> createState() => _BrandInfoState();
}

class _BrandInfoState extends State<BrandInfo> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  getUserInfo() async {
    var result = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .collection('user_favorite')
        .doc('favorite_brand').get();
    return result.data();
  }

  Widget brandInfoWidget({required Map<String, dynamic> userData}){
    double screenWidth = MediaQuery.of(context).size.width;
    List<String> brand_list = List<String>.from(userData['brand_list'] ?? []);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(' 선호 브랜드', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),),
            IconButton(
              onPressed: (){
                showEditBrandDialog(context, brand_list);
              },
              icon: const Icon(Icons.edit),
              iconSize: 20,)
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        const Text('1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                        Text(brand_list[0], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('2', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      Text(brand_list[1], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(child: Container(width: screenWidth * 0.85, height: 1, color: Colors.grey.withOpacity(0.5))),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('3', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                      Text(brand_list[2], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                    ],
                  ),
                ]
            ),
          ),
        ),
      ],
    );
  }

  void showEditBrandDialog(BuildContext context, brand_list) {
    //  새로 수정된 브랜드 담을 변수(default는 기존 정보)
    List <String> new_brand_list = brand_list;

    // 브래드 정보 db에 업데이트하는 함수
    void updateBrandInfo(brand_list) async {
      var db = FirebaseFirestore.instance;
      final data = brand_list;

      try {
        await db
            .collection("Users")
            .doc(uid)
            .collection('user_favorite')
            .doc('favorite_brand')
            .set({
          'brand_list' : data,
        }, SetOptions(merge: true));

        print('브랜드 수정 성공!');
      } catch(e) {
        print("브랜드 수정 에러: $e");
      }

    }

    void handleSelectedBtn(String brandName, bool isSelected){
      setState(() {
        if (isSelected) {
          new_brand_list.remove(brandName);
        } else {
          if (new_brand_list.length <= 2) {
            new_brand_list.add(brandName);
          }
        }
        print(new_brand_list);
      });
    }

    // 브랜드 수정 alert dialog 화면
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: const Center(child: Text('브랜드 정보 수정')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20,10,20,10),
                    child: SizedBox(
                      // width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BrandBtn(
                                    brandName: '더벤티',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('더벤티'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('더벤티', isSelected);
                                    },
                                  ),
                                  BrandBtn(
                                    brandName: '투썸플레이스',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('투썸플레이스'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('투썸플레이스', isSelected);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BrandBtn(
                                    brandName: '매머드',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('매머드'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('매머드', isSelected);
                                    },
                                  ),
                                  BrandBtn(
                                    brandName: '컴포즈커피',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('컴포즈커피'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('컴포즈커피', isSelected);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BrandBtn(
                                    brandName: '이디야',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('이디야'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('이디야', isSelected);
                                    },
                                  ),
                                  BrandBtn(
                                    brandName: '메가커피',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('메가커피'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('메가커피', isSelected);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BrandBtn(
                                    brandName: '커피빈',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('커피빈'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('커피빈', isSelected);
                                    },
                                  ),
                                  BrandBtn(
                                    brandName: '스타벅스',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('스타벅스'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('스타벅스', isSelected);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BrandBtn(
                                    brandName: '빽다방',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('빽다방'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('빽다방', isSelected);
                                    },
                                  ),
                                  BrandBtn(
                                    brandName: '할리스',
                                    pressedNum: new_brand_list.length,
                                    isSelected: new_brand_list.contains('할리스'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('할리스', isSelected);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: const Text("취소", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: () {
                  updateBrandInfo(new_brand_list);
                  Navigator.pop(context);
                },
                child: const Text('수정', style: TextStyle(color: Colors.redAccent),),
              ),
            ],
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            var userData = snapshot.data as Map<String, dynamic>;

            return brandInfoWidget(userData: userData);
          } else {
            return const Text('No dadta available');
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
