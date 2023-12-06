import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coolcoolcoffee_front/page/login/brand_btn.dart';

import '../../health.dart';


class SignUpThirdPage extends StatefulWidget {
  final String userEmail;
  final String userPassword;
  final String userName;
  final int userAge;
  final String bedTime;
  final String goodSleepTime;
  final int caffeineHalfLife;
  final double tw;
  const SignUpThirdPage({Key? key, required this.userName, required this.userAge, required this.bedTime, required this.goodSleepTime, required this.caffeineHalfLife, required this.userEmail, required this.userPassword, required this.tw}) : super(key: key);

  @override
  State<SignUpThirdPage> createState() => _UserFormState();
}

class _UserFormState extends State<SignUpThirdPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> brandBtns = [];

  @override
  void initState() {
    super.initState();
  }

  String errorMessage = '';

  void _handleSignUp() async {
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: widget.userEmail,
        password: widget.userPassword,
      );
      print('사용자 회원가입 완료: ${userCredential.user!.email}');

    } on FirebaseAuthException catch (e) {
      //회원가입 예외처리
      switch (e.code) {
        case 'email-already-in-use':
          setState(() {
            errorMessage = '이미 존재하는 이메일 계정입니다.';
            print(errorMessage);
          });
          break;
        case 'invalid-email':
          setState(() {
            errorMessage = '이메일 주소가 올바른 형식이 아닙니다.';
            print(errorMessage);
          });
          break;
        case 'operation-no-allowed':
          setState(() {
            errorMessage = '이메일/패스워드 계정 생성이 허용되지 않습니다.';
            print(errorMessage);
          });
          break;
        case 'weak-password':
          setState(() {
            errorMessage = '비밀번호는 6자 이상이어야 합니다.';
            print(errorMessage);
          });
          break;
        default:
          errorMessage = e.code;
          print('오류가 발생했습니다. : $errorMessage');
      }
    }
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
    try {

      // Sign up the user
      try{
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: widget.userEmail,
          password: widget.userPassword,
        );
        print('사용자 회원가입 완료: ${userCredential.user!.email}');

      } on FirebaseAuthException catch (e) {
        //회원가입 예외처리
        switch (e.code) {
          case 'email-already-in-use':
            setState(() {
              errorMessage = '이미 존재하는 이메일 계정입니다.';
              print(errorMessage);
            });
            break;
          case 'invalid-email':
            setState(() {
              errorMessage = '이메일 주소가 올바른 형식이 아닙니다.';
              print(errorMessage);
            });
            break;
          case 'operation-no-allowed':
            setState(() {
              errorMessage = '이메일/패스워드 계정 생성이 허용되지 않습니다.';
              print(errorMessage);
            });
            break;
          case 'weak-password':
            setState(() {
              errorMessage = '비밀번호는 6자 이상이어야 합니다.';
              print(errorMessage);
            });
            break;
          default:
            errorMessage = e.code;
            print('오류가 발생했습니다. : $errorMessage');
        }
      }

      // Get the current user after sign up
      User? user = FirebaseAuth.instance.currentUser;
      Map<String,dynamic> longterm_feedback= {"same":0, "over":0, "less":0};
      // Check if the user is not null
      if (user != null) {
        // Save data to the database
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .set({
          'app_access' : false,
          'user_email' : widget.userEmail,
          'user_name': widget.userName,
          'user_age': widget.userAge,
          'avg_bed_time': widget.bedTime,
          'good_sleep_time': widget.goodSleepTime,
          'caffeine_half_life' : widget.caffeineHalfLife,
          'tw' : widget.tw,
          'longterm_feedback':longterm_feedback,
        }, SetOptions(merge: true));

        // Create nested collections
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .collection('user_favorite')
            .doc('favorite_drink')
            .set({
          'drink_list': [],
        });

        await FirebaseFirestore.instance
            .collection("Users")
            .doc(user.uid)
            .collection('user_favorite')
            .doc('favorite_brand')
            .set({
          'brand_list': brandBtns,
        });

        print('User registration and data saving to the database successful!');

        // if(!mounted) return;
        // Navigator.popUntil(context, (route) => route.isFirst);

        if(!mounted) return;
        Navigator.popUntil(context, (route) => route.isFirst);

      }
    } catch (e) {
      print("Error during user registration or saving data to the database: $e");
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
        title: const Text('마지막 페이지', style: TextStyle(color: Colors.black),),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  BrandBtn(
                                    brandName: '편의점',
                                    pressedNum: brandBtns.length,
                                    isSelected: brandBtns.contains('편의점'),
                                    onPressed: (isSelected){
                                      handleSelectedBtn('편의점');
                                    },
                                  ),
                                ],
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
            const SizedBox(height: 5),
            Center(
              child: Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.withOpacity(0.6),
                      minimumSize: const Size.fromHeight(70),
                      shape: const BeveledRectangleBorder(),
                    ),
                    onPressed: _onNextButtonPressed,
                    child: const Text('제출', style: TextStyle(fontSize: 22, color: Colors.white),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


