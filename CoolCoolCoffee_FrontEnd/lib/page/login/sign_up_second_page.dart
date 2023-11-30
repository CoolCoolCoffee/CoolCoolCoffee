import 'dart:math';

import 'package:coolcoolcoffee_front/page/login/sign_up_third_page.dart';
import 'package:flutter/material.dart';


class SignUpSecondPage extends StatefulWidget {
  final String userEmail;
  final String userPassword;
  final String userName;
  final int userAge;
  const SignUpSecondPage({Key? key, required this.userName, required this.userAge, required this.userEmail, required this.userPassword}) : super(key: key);

  @override
  State<SignUpSecondPage> createState() => _UserFormState();
}

class _UserFormState extends State<SignUpSecondPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _bedHourController;
  late TextEditingController _bedMinController;
  late TextEditingController _goodSleepHourController;
  late TextEditingController _goodSleepMinController;

  late int bedHour; late int bedMin;
  late int goodSleepHour; late int goodSleepMin;

  late String bedTime;
  late String goodSleepTime;

  bool isAm1 = true; bool isPm1 = false;
  late List<bool> isSelected1 = [isAm1, isPm1];

  void toggleSelect1(value) {
    if(value == 0){
      isAm1 = true;
      isPm1 = false;
    } else{
      isAm1 = false;
      isPm1 = true;
    }
    setState(() {
      isSelected1 = [isAm1, isPm1];
    });
  }

  int caffeineHalfLife = 5;
  bool little = false; bool medium = true;  bool many = false;
  late List<bool> caffeineSelected = [little, medium, many];

  void caffeineToggleSelected(value) {
    if(value == 0){
      little = true;
      medium = false;
      many = false;
      caffeineHalfLife = 4;

    } else if(value == 1){
      little = false;
      medium = true;
      many = false;
      caffeineHalfLife = 5;
    } else{
      little = false;
      medium = false;
      many = true;
      caffeineHalfLife = 6;
    }
    setState(() {
      caffeineSelected = [little, medium, many];
      caffeineHalfLife;
    });
  }

  @override
  void initState() {
    super.initState();
    _bedHourController = TextEditingController();
    _bedMinController = TextEditingController();
    _goodSleepHourController = TextEditingController();
    _goodSleepMinController = TextEditingController();
  }

  @override
  void dispose() {
    _bedHourController.dispose();
    _bedMinController.dispose();
    _goodSleepHourController.dispose();
    _goodSleepMinController.dispose();
    super.dispose();
  }

  void _onNextButtonPressed() {
    double h1 = 0.75; double h2 = 0.2469; double a = 0.09478; double C = 0.45145833333;
    // bedTime, goodSleepTime 모두 string으로 변화 시키자
    if(isAm1 == true) {
      bedTime = '${bedHour.toString()}:${bedMin.toString().padLeft(2,'0')}';
    } else if(isPm1 == true) {
      bedTime = '${(bedHour+12).toString()}:${bedMin.toString().padLeft(2,'0')}';
    }

    goodSleepTime = '${goodSleepHour.toString()}:${goodSleepMin.toString().padLeft(2,'0')}';
    var good_sleep = goodSleepHour + goodSleepMin/60;
    var t0 = bedHour + bedMin/60 + good_sleep;
    if(t0 >= 24.0) t0 = t0 - 24.0;
    t0 = t0/24-C;
    var delta = (24 - good_sleep)/24;
    var x0 = h2 + a*sin(2*pi*t0);
    var x1 = h1 + a*sin(2*pi*(t0 + delta));
    var tw = double.parse((-delta / (log(1-x1)-log(1-x0))).toStringAsFixed(10));

    print(caffeineHalfLife);
    if(_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
        SignUpThirdPage(
          // required 인자 5개 넣기(이름,나이,취침,기상,수면)
          userEmail: widget.userEmail,
          userPassword: widget.userPassword,
          userName: widget.userName,
          userAge: widget.userAge,
          bedTime: bedTime!,
          goodSleepTime: goodSleepTime!,
          caffeineHalfLife: caffeineHalfLife,
          tw: tw,
        )),
      );
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
                fontSize: 25, fontWeight: FontWeight.bold, color: Colors.brown.withOpacity(0.6))),
        const Text(' 님의 수면 주기를 파악하려면', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, textBaseline: TextBaseline.ideographic),),
          ],
        ),
        const Text('아래 정보들이 필요해요!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        const SizedBox(height: 4),
        const Text('사용자 맞춤 서비스를 제공해드릴게요!', style: TextStyle(fontSize: 13, color: Colors.black54)),
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
        title: const Text('두 번째 페이지', style: TextStyle(color: Colors.black),),
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
                  Container(width: screenWidth * 0.9, height: 1, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 40,),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // 평균 취침시간 입력 받는 위젯
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                const Text('평균 ', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                Text('취침 ', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown.withOpacity(0.6))),
                                const Text('시간을 알려주세요.', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                const SizedBox(width: 4),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Column(
                                    children: [
                                      ToggleButtons(
                                        direction: Axis.vertical,
                                          isSelected: isSelected1,
                                          onPressed: toggleSelect1,
                                          selectedColor: Colors.white,
                                          fillColor: Colors.brown.withOpacity(0.6),
                                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                                          constraints: const BoxConstraints(
                                            minHeight: 45.0,
                                            minWidth: 60.0,
                                          ),
                                          children: const [
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text('AM', style: TextStyle(fontSize: 16),),),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Text('PM', style: TextStyle(fontSize: 16),),),
                                          ]
                                      ),
                                    ],
                                  ),
                                ),
                                // 취침 시간 '시'
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: 70,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _bedHourController,
                                    decoration: const InputDecoration(
                                      labelText: '시',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "필수입력란 입니다";
                                      }else if (int.parse(value) < 1 || int.parse(value) > 12) {
                                        return "잘못된 형식입니다";
                                      }
                                      return null;
                                    },
                                    onChanged: (value){
                                      setState(() {
                                        print('취침 시간 $value 시');
                                        bedHour = int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                                const Text(':', style: TextStyle(fontSize: 30),),
                                // 취침 시간 '분'
                                Container(
                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  width: 70,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _bedMinController,
                                    decoration: const InputDecoration(
                                      labelText: '분',
                                      border: OutlineInputBorder(),
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "필수입력란 입니다";
                                      }else if (int.parse(value) < 0 || int.parse(value) > 60) {
                                        return "잘못된 형식입니다";
                                      }
                                      return null;
                                    },
                                    onChanged: (value){
                                      setState(() {
                                        print('취침 시간 $value 분');
                                        bedMin = int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                              ],
                            ),
                            const SizedBox(height: 40),
                            // 적정 수면 시간을 입력받는 위젯
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.ideographic,
                                  children: [
                                    Text('적정 수면 ', style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown.withOpacity(0.6)),),
                                    const Text('시간을 알려주세요.', style: TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const SizedBox(width: 50,),
                                    // 취침 시간 '시'
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      width: 70,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: _goodSleepHourController,
                                        decoration: const InputDecoration(
                                          labelText: '시',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "필수입력란 입니다";
                                          }else if (int.parse(value) < 1 || int.parse(value) > 12) {
                                            return "잘못된 형식입니다";
                                          }
                                          return null;
                                        },
                                        onChanged: (value){
                                          setState(() {
                                            print('적정수면시간 $value 시');
                                            goodSleepHour = int.parse(value);
                                          });
                                        },
                                      ),
                                    ),
                                    const Text('시간', style: TextStyle(fontSize: 15),),
                                    // 취침 시간 '분'
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      width: 70,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: _goodSleepMinController,
                                        decoration: const InputDecoration(
                                          labelText: '분',
                                          border: OutlineInputBorder(),
                                        ),
                                        validator: (value) {
                                          if (value == null) {
                                            return "필수입력란 입니다";
                                          }else if (int.parse(value) < 0 || int.parse(value) > 60) {
                                            return "잘못된 형식입니다";
                                          }
                                          return null;
                                        },
                                        onChanged: (value){
                                          setState(() {
                                            print('적정수면시간 $value 분');
                                            goodSleepMin = int.parse(value);
                                          });
                                        },
                                      ),
                                    ),
                                    const Text('분', style: TextStyle(fontSize: 15),),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text('평소 ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black)),
                                Text('카페인 영향', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.brown.withOpacity(0.6))),
                                const Text('을 얼마나 받으시나요? ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.black)),
                              ]
                            ),
                            const SizedBox(height: 14),
                            ToggleButtons(
                                isSelected: caffeineSelected,
                                onPressed: caffeineToggleSelected,
                                selectedColor: Colors.white,
                                fillColor: Colors.brown.withOpacity(0.6),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                                constraints: const BoxConstraints(
                                  minHeight: 45.0,
                                  minWidth: 60.0,
                                ),
                                children: const [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('조금', style: TextStyle(fontSize: 16),),),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('보통', style: TextStyle(fontSize: 16),),),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Text('많이', style: TextStyle(fontSize: 16),),),
                                ]
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown.withOpacity(0.6),
                      minimumSize: const Size.fromHeight(70),
                      shape: const BeveledRectangleBorder(),
                    ),
                    onPressed: _onNextButtonPressed,
                    child: const Text('다음', style: TextStyle(fontSize: 22, color: Colors.white),)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

