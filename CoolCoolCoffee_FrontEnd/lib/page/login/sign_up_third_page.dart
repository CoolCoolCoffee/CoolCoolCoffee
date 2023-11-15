import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/login/brand_btn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../page_state/page_state.dart';


class SignUpThirdPage extends StatefulWidget {
  final String userName;
  final int userAge;
  final String bedTime;
  final String goodSleepTime;

  const SignUpThirdPage({Key? key, required this.userName, required this.userAge, required this.bedTime, required this.goodSleepTime,}) : super(key: key);

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
      brandBtns.contains(brandName)
          ? brandBtns.remove(brandName)
          : brandBtns.add(brandName);
      print(brandBtns);
    });
  }

  void handleSelectedBtn2(String brandName){
    setState(() {
      if(brandBtns.contains(brandName)) {
        brandBtns.remove(brandName);
        print(brandBtns);
      }
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
        }, SetOptions(merge: true));
        
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user!.uid)
            .collection('user_favorite')
            .doc('favorite_brand')
            .set({
              'brand_list': brandBtns,
            });

        print('유저 회원가입 정보 db에 저장 성공!');

        Navigator.push(
          currentContext,
          MaterialPageRoute(builder: (context) => PageStates()),
        );

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
            Text(widget.userName, style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),),
            const Text(' 님이 자주 이용하시는', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, textBaseline: TextBaseline.ideographic),),
          ],
        ),
        const Text('카페 브랜드를 알려주세요! (최대 3개)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
        title: const Text('마지막 페이지'),
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
              const SizedBox(height: 30,),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.ideographic,
                children: [
                  Text('9개의 브랜드 중 ', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),),
                  Text('최대 3개', style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),),
                  Text('를 골라주세요.', style: TextStyle(
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
                                  onPressed: (isSelected){
                                    if (brandBtns.length <= 2) {
                                      handleSelectedBtn('더벤티');
                                    } else if(brandBtns.length == 3){
                                      handleSelectedBtn2('더벤티');
                                    }
                                  },
                              ),
                              BrandBtn(
                                brandName: '메가커피',
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('메가커피');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('메가커피');
                                  }
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
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('매머드');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('매머드');
                                  }
                                },
                              ),
                              BrandBtn(
                                brandName: '스타벅스',
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('스타벅스');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('스타벅스');
                                  }
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
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('이디야');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('이디야');
                                  }
                                },
                              ),
                              BrandBtn(
                                brandName: '투썸플레이스',
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('투썸플레이스');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('투썸플레이스');
                                  }
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
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('커피빈');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('커피빈');
                                  }
                                },
                              ),
                              BrandBtn(
                                brandName: '컴포즈커피',
                                pressedNum: brandBtns.length,
                                onPressed: (isSelected){
                                  if (brandBtns.length <= 2) {
                                    handleSelectedBtn('컴포즈커피');
                                  } else if(brandBtns.length == 3){
                                    handleSelectedBtn2('컴포즈커피');
                                  }
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      BrandBtn(
                        brandName: '빽다방',
                        pressedNum: brandBtns.length,
                        onPressed: (isSelected){
                          if (brandBtns.length <= 2) {
                            handleSelectedBtn('빽다방');
                          } else if(brandBtns.length == 3){
                            handleSelectedBtn2('빽다방');
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: _onNextButtonPressed,
                  child: Text('다음')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


