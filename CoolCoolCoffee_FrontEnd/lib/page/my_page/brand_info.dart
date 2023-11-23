import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login/brand_btn.dart';

class EditBrandDialog extends StatefulWidget {
  List<String> brand_list;

  EditBrandDialog({Key? key, required this.brand_list}) : super(key: key);
  @override
  State<EditBrandDialog> createState() => _EditBrandDialogState();
}

class _EditBrandDialogState extends State<EditBrandDialog> {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  late List <String> new_brand_list;

  @override
  void initState(){
    new_brand_list = widget.brand_list;
    super.initState();
  }

  // 브래드 정보 db에 업데이트하는 함수
  void updateBrandInfo(new_brand_list) async {
    var db = FirebaseFirestore.instance;
    final data = new_brand_list;

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

  void handleSelectedBtn(String brandName){
    setState(() {
      if (new_brand_list.contains(brandName)) {
        new_brand_list.remove(brandName);
      } else {
        if (new_brand_list.length <= 2) {
          new_brand_list.add(brandName);
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.all(10),
              child: SizedBox(
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
                            handleSelectedBtn('더벤티');
                          },
                        ),
                        const SizedBox(width: 10),
                        BrandBtn(
                          brandName: '투썸플레이스',
                          pressedNum: new_brand_list.length,
                          isSelected: new_brand_list.contains('투썸플레이스'),
                          onPressed: (isSelected){
                            handleSelectedBtn('투썸플레이스');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BrandBtn(
                          brandName: '할리스',
                          pressedNum: new_brand_list.length,
                          isSelected: new_brand_list.contains('할리스'),
                          onPressed: (isSelected){
                            handleSelectedBtn('할리스');
                          },
                        ),
                        BrandBtn(
                          brandName: '컴포즈커피',
                          pressedNum: new_brand_list.length,
                          isSelected: new_brand_list.contains('컴포즈커피'),
                          onPressed: (isSelected){
                            handleSelectedBtn('컴포즈커피');
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
                            handleSelectedBtn('이디야');
                          },
                        ),
                        BrandBtn(
                          brandName: '매머드커피',
                          pressedNum: new_brand_list.length,
                          isSelected: new_brand_list.contains('매머드커피'),
                          onPressed: (isSelected){
                            handleSelectedBtn('매머드커피');
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
                            handleSelectedBtn('커피빈');
                          },
                        ),
                        BrandBtn(
                          brandName: '스타벅스',
                          pressedNum: new_brand_list.length,
                          isSelected: new_brand_list.contains('스타벅스'),
                          onPressed: (isSelected){
                            handleSelectedBtn('스타벅스');
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
                            handleSelectedBtn('빽다방');
                          },
                        ),
                        BrandBtn(
                          brandName: '메가커피',
                          pressedNum: new_brand_list.length,
                          isSelected: new_brand_list.contains('메가커피'),
                          onPressed: (isSelected){
                            handleSelectedBtn('메가커피');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: BrandBtn(
                        brandName: '편의점',
                        pressedNum: new_brand_list.length,
                        isSelected: new_brand_list.contains('편의점'),
                        onPressed: (isSelected){
                          handleSelectedBtn('편의점');
                        },
                      ),
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
}






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
  late Map<String, dynamic> userData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var result = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('user_favorite')
        .doc('favorite_brand')
        .get();
    setState(() {
      userData = result.data() ?? {};
    });
  }


  getUserInfo() async {
    var result = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .collection('user_favorite')
        .doc('favorite_brand').get();
    return result.data();
  }

  // 홈 화면에 보여질 브랜드 정보 위젯
  Widget brandInfoWidget({required Map<String, dynamic> userData}){
    double screenWidth = MediaQuery.of(context).size.width;

    // 브랜드 정보 받아와서
    List<String> brand_list = List<String>.from(userData['brand_list']);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(' 선호 브랜드', style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500),),
            IconButton(
              onPressed: (){
                // 수정 화면 보여주는 함수
                _showEditBrandDialog(context, brand_list);
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

  void _showEditBrandDialog(BuildContext context, brand_list) async {
    await showDialog(
      context: context,
      builder: (BuildContext context){
        return EditBrandDialog(brand_list: brand_list);
      },
    );
    fetchData();
  }
}
