import 'package:flutter/material.dart';

import '../../model/user.dart';

class UserFormSecondPage extends StatefulWidget {
  const UserFormSecondPage({Key? key, required this.onNext, required this.user}) : super(key: key);
  final VoidCallback onNext;
  final User user;

  @override
  State<UserFormSecondPage> createState() => _UserFormState();
}

class _UserFormState extends State<UserFormSecondPage> {
  late final VoidCallback onNext;
  late final User user;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    onNext = widget.onNext;
    user = widget.user;
    _nameController = TextEditingController(); // TextEditingController 초기화
    _ageController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Widget firstPage(){
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Widget textInfo() {
      return const Expanded(
        // width: screenWidth * 0.9,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('안녕하세요', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            Text('쿨쿨커피 입니다 :)', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 15),
            Text('커피 마시고도 쿨쿨 잘 자는 시간을 알려드릴게요!', style: TextStyle(fontSize: 18, color: Colors.black54)),
          ],
        ),
      );
    }

    Widget nameInput(){
      return Row(
        children: [
          Column(
            children: [
              const Row(
                children: [
                  Text('닉네임', style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue),),
                  Text('을 설정해주세요.', style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),),
                  SizedBox(width: 5),
                  Text('(한글 2~8자)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, textBaseline: TextBaseline.ideographic),),
                ],
              ),
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '닉네임을 입력하세요',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "닉네임을 입력해주세요";
                    }
                    return null;
                  },
                  onChanged: (value){
                    setState(() {
                      user.userName = value;
                    });
                  },
                ),
              ),
            ],
          )
        ],
      );
    }

    Widget ageInput(){
      return Row(
        children: [
          Column(
            children: [
              const Row(
                children: [
                  Text('만 나이', style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.blue),),
                  Text('를 알려주세요.', style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),),
                  SizedBox(width: 5),
                  Text('(필수)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, textBaseline: TextBaseline.ideographic),),
                ],
              ),
              Row(
                children: [
                  const SizedBox(width: 10,),
                  const Text('만'),
                  Expanded(
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: '닉네임을 입력하세요',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "이메일을 입력해주세요";
                        }
                        return null;
                      },
                      onChanged: (value){
                        setState(() {
                          user.userAge = int.parse(value);
                        });
                      },
                    ),
                  ),
                  const Text('세'),
                ],
              ),
            ],
          )
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          textInfo(),
          const SizedBox(height: 100,),
          nameInput(),
          const SizedBox(height: 80,),
          ageInput(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return firstPage();
  }

}

