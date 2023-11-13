import 'package:coolcoolcoffee_front/page/login/sign_up_third_page.dart';
import 'package:flutter/material.dart';


class SignUpSecondPage extends StatefulWidget {
  final String userName;
  final int userAge;
  const SignUpSecondPage({Key? key, required this.userName, required this.userAge}) : super(key: key);

  @override
  State<SignUpSecondPage> createState() => _UserFormState();
}

class _UserFormState extends State<SignUpSecondPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _bedHourController = TextEditingController();
  TextEditingController _bedMinController = TextEditingController();
  TextEditingController _wakeHourController = TextEditingController();
  TextEditingController _wakeMinController = TextEditingController();
  TextEditingController _goodSleepHourController = TextEditingController();
  TextEditingController _goodSleepMinController = TextEditingController();

  late int bedHour; late int bedMin;
  late int wakeHour; late int wakeMin;
  late int goodSleepHour; late int goodSleepMin;

  late String bedTime;
  late String wakeTime;
  late String goodSleepTime;

  bool isAm1 = false; bool isPm1 = false;
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

  bool isAm2 = false; bool isPm2 = false;
  late List<bool> isSelected2 = [isAm1, isPm1];

  void toggleSelect2(value) {
    if(value == 0){
      isAm2 = true;
      isPm2 = false;
    } else{
      isAm2 = false;
      isPm2 = true;
    }
    setState(() {
      isSelected2 = [isAm2, isPm2];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bedHourController.dispose();
    _bedMinController.dispose();
    _wakeHourController.dispose();
    _wakeMinController.dispose();
    _goodSleepHourController.dispose();
    _goodSleepMinController.dispose();
    super.dispose();
  }

  void _onNextButtonPressed() {
    // bedTime, wakeTime, goodSleepTime 모두 string으로 변화 시키자
    if(isAm1 == true) {
      bedTime = '${bedHour.toString()}:${bedMin.toString().padLeft(2,'0')}';
    } else if(isPm1 == true) {
      bedTime = '${(bedHour+12).toString()}:${bedMin.toString().padLeft(2,'0')}';
    }

    if(isAm2 == true) {
      wakeTime = '${wakeHour.toString()}:${wakeMin.toString().padLeft(2,'0')}';
    } else if(isPm2 == true) {
      wakeTime = '${(wakeHour+12).toString()}:${wakeMin.toString().padLeft(2,'0')}';
    }

    goodSleepTime = '${goodSleepHour.toString()}:${goodSleepMin.toString().padLeft(2,'0')}';

    if(_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>
        SignUpThirdPage(
          // required 인자 5개 넣기(이름,나이,취침,기상,수면)
          userName: widget.userName,
          userAge: widget.userAge,
          bedTime: bedTime!,
          wakeTime: wakeTime!,
          goodSleepTime: goodSleepTime!,
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
            Text(widget.userName, style: const TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.blue),),
        const Text(' 님의 수면 주기를 파악하려면', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, textBaseline: TextBaseline.ideographic),),
          ],
        ),
        const Text('아래의 정보들이 필요해요!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
      appBar: AppBar(
        title: const Text('두 번째 페이지'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              textInfo(),
              const SizedBox(height: 25,),
              Container(width: screenWidth*0.9, height: 1, color: Colors.grey.withOpacity(0.5)),
              const SizedBox(height: 30,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 평균 취침시간 입력 받는 위젯
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text('평균 ', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                            Text('취침 ', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                            Text('시간을 알려주세요.', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                            SizedBox(width: 4),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Column(
                              children: [
                                ToggleButtons(
                                  direction: Axis.vertical,
                                    isSelected: isSelected1,
                                    onPressed: toggleSelect1,
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
                            const SizedBox(width: 20,),
                            // 취침 시간 '시'
                            SizedBox(
                              width: 100,
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
                            const SizedBox(width: 10,),
                            const Text(':', style: TextStyle(fontSize: 30),),
                            const SizedBox(width: 10,),
                            // 취침 시간 '분'
                            SizedBox(
                              width: 100,
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

                        // 평균 기상시간 입력 받는 위젯
                        Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text('평균 ', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                Text('기상 ', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                                Text('시간을 알려주세요.', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                SizedBox(width: 4),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    ToggleButtons(
                                        direction: Axis.vertical,
                                        isSelected: isSelected2,
                                        onPressed: toggleSelect2,
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
                                const SizedBox(width: 20,),
                                // 취침 시간 '시'
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _wakeHourController,
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
                                        print('기상 시간 $value 시');
                                        wakeHour = int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                const Text(':', style: TextStyle(fontSize: 30),),
                                const SizedBox(width: 10,),
                                // 취침 시간 '분'
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _wakeMinController,
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
                                        wakeMin = int.parse(value);
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10,),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        // 적정 수면 시간을 입력받는 위젯
                        Column(
                          children: [
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.ideographic,
                              children: [
                                Text('적정 수면 ', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                                Text('시간을 알려주세요.', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                SizedBox(width: 4),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(width: 50,),
                                // 취침 시간 '시'
                                SizedBox(
                                  width: 100,
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
                                const SizedBox(width: 10,),
                                const Text('시간', style: TextStyle(fontSize: 15),),
                                const SizedBox(width: 10,),
                                // 취침 시간 '분'
                                SizedBox(
                                  width: 100,
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
                                const SizedBox(width: 10,),
                                const Text('분', style: TextStyle(fontSize: 15),),
                                const SizedBox(width: 10,),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
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

