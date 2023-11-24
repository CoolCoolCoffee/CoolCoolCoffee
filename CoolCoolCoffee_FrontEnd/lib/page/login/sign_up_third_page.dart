import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/login/brand_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../page_state/page_state.dart';
import 'login_page.dart';


class SignUpThirdPage extends StatefulWidget {
  final String userName;
  final int userAge;
  final String bedTime;
  final String goodSleepTime;
  final int caffeineHalfLife;
  final double tw;
  const SignUpThirdPage({Key? key, required this.userName, required this.userAge, required this.bedTime, required this.goodSleepTime, required this.caffeineHalfLife, required this.tw,}) : super(key: key);

  @override
  State<SignUpThirdPage> createState() => _UserFormState();
}

class _UserFormState extends State<SignUpThirdPage> {
  User? user = FirebaseAuth.instance.currentUser;
  List<String> brandBtns = [];

  @override
  void initState() {
    super.initState();
  }


  void handleSelectedBtn(String brandName){
    setState(() {
      if(brandBtns.contains(brandName)) {
        brandBtns.remove(brandName);
      } else{
        if(brandBtns.length <= 2) {
          brandBtns.add(brandName);
        }
      }
        print(brandBtns);
    });
  }

  void _onNextButtonPressed() async {
    // brandlist가 3개 이하로 선택 되었으면
    // db에 저장하고 page_states 불러오기
    BuildContext currentContext = context;
      try {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .set({
          'user_name': widget.userName,
          'user_age': widget.userAge,
          'avg_bed_time': widget.bedTime,
          'good_sleep_time': widget.goodSleepTime,
          'caffeine_half_life' : widget.caffeineHalfLife,
          'tw' : widget.tw,
        }, SetOptions(merge: true));

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user!.uid)
            .collection('user_favortie')
            .doc('favorite_drink')
            .set({
              'drink_list' : [],
            });
        
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .collection('user_favorite')
            .doc('favorite_brand')
            .set({
              'brand_list': brandBtns,
            });

        print('유저 회원가입 정보 db에 저장 성공!');

        if(!mounted) return;
        Navigator.popUntil(context, (route) => route.isFirst);
        // Navigator.push(
        //   currentContext,
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );

      } catch(e) {
        print("유저 회원가입 정보 db 저장 에러: $e");
      }
    }

  Widget textInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: [
            Text(widget.userName, style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.brown.withOpacity(0.6)),),
            const Text(' 님이 자주 이용하시는', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, textBaseline: TextBaseline.ideographic),),
          ],
        ),
        const Text('브랜드를 알려주세요! ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        const SizedBox(height: 4),
        const Text('디카페인 음료 추천 시스템에 활용할거에요!', style: TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Colors.brown.withOpacity(0.1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('마지막 페이지', style: TextStyle(color: Colors.black),)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              textInfo(),
              const SizedBox(height: 25,),
              Container(width: screenWidth*0.9, height: 1, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 25,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  const Text('10개의 브랜드 중 ', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                  Text('3개', style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown.withOpacity(0.6)),),
                  const Text('를 골라주세요.', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(30,10,30,10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BrandBtn(
                                  brandName: '더벤티',
                                  pressedNum: brandBtns.length,
                                  isSelected: brandBtns.contains('더벤티'),
                                  onPressed: (isSelected){
                                    handleSelectedBtn('더벤티');
                                  },
                              ),
                              BrandBtn(
                                brandName: '투썸플레이스',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('투썸플레이스'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('투썸플레이스');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BrandBtn(
                                brandName: '할리스',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('할리스'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('할리스');
                                },
                              ),
                              BrandBtn(
                                brandName: '컴포즈커피',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('컴포즈커피'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('컴포즈커피');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BrandBtn(
                                brandName: '이디야',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('이디야'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('이디야');
                                },
                              ),
                              BrandBtn(
                                brandName: '매머드커피',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('매머드커피'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('매머드커피');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BrandBtn(
                                brandName: '커피빈',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('커피빈'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('커피빈');
                                },
                              ),
                              BrandBtn(
                                brandName: '스타벅스',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('스타벅스'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('스타벅스');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BrandBtn(
                                brandName: '빽다방',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('빽다방'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('빽다방');
                                },
                              ),
                              BrandBtn(
                                brandName: '메가커피',
                                pressedNum: brandBtns.length,
                                isSelected: brandBtns.contains('메가커피'),
                                onPressed: (isSelected){
                                  handleSelectedBtn('메가커피');
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: BrandBtn(
                              brandName: '편의점',
                              pressedNum: brandBtns.length,
                              isSelected: brandBtns.contains('편의점'),
                              onPressed: (isSelected){
                                handleSelectedBtn('편의점');
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.withOpacity(0.6)),
                      ),
                    onPressed: _onNextButtonPressed,
                    child: const Text('다음')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


