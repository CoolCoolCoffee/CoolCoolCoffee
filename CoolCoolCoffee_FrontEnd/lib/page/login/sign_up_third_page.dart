import 'package:flutter/material.dart';


class SignUpThirdPage extends StatefulWidget {
  final String userName;
  final int userAge;
  final String bedTime;
  final String wakeTime;
  final String goodSleepTime;

  const SignUpThirdPage({Key? key, required this.userName, required this.userAge, required this.bedTime, required this.wakeTime, required this.goodSleepTime,}) : super(key: key);

  @override
  State<SignUpThirdPage> createState() => _UserFormState();
}

class _UserFormState extends State<SignUpThirdPage> {
  final _formKey = GlobalKey<FormState>();

  // late final VoidCallback onNext;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // onNext = widget.onNext;
    _nameController = TextEditingController(); // TextEditingController 초기화
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onNextButtonPressed() {
    if(_formKey.currentState?.validate() ?? false) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => SignUpSecondPage()),
      // );
    }
  }

  Widget textInfo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('안녕하세요', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        Text('쿨쿨커피 입니다 :)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
        SizedBox(height: 4),
        Text('커피 마시고도 쿨쿨 잘 자는 시간을 알려드릴게요!', style: TextStyle(fontSize: 13, color: Colors.black54)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('마지막 페이지'),
      ),
      body: Center(
        child: Column(
          children: [
            Text('사용자 이름 : ${widget.userName}'),
            Text('사용자 나이 : ${widget.userAge}'),
            Text('취침 시간 : ${widget.bedTime}'),
            Text('기상 시간 : ${widget.wakeTime}'),
            Text('적정 수면 시간 : ${widget.goodSleepTime}'),
          ],
        ),
      ),
    );
  }
}

