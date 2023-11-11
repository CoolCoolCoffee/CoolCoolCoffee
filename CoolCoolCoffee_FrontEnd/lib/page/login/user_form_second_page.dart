import 'package:coolcoolcoffee_front/page/login/user_form_third_page.dart';
import 'package:coolcoolcoffee_front/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserFormSecondPage extends StatefulWidget {
  final UserProvider userProvider;

  const UserFormSecondPage({Key? key, required this.userProvider,}) : super(key: key);

  @override
  State<UserFormSecondPage> createState() => _UserFormState();
}

class _UserFormState extends State<UserFormSecondPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      widget.userProvider.userName = _nameController.text;
    });

    _ageController.addListener(() {
      widget.userProvider.userAge = int.tryParse(_ageController.text) ?? 0;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _onNextButtonPressed() {
    if(_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const UserFormThirdPage()),
      );
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
        title: Text('두 번째 페이지'),
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
              const SizedBox(height: 80,),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.ideographic,
                          children: [
                            Text('닉네임', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                            Text('을 설정해주세요.', style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                            SizedBox(width: 4),
                            Text('(한글 2~8자)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, textBaseline: TextBaseline.ideographic),),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: '닉네임을 입력하세요',
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "필수입력란 입니다";
                                  }else if (value.length < 2 || value.length > 8) {
                                    return "한글 2~8자 이내로 입력해주세요";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 60),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Text('만 나이', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),),
                                Text('를 알려주세요.', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),),
                                SizedBox(width: 4),
                                Text('(필수)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black, textBaseline: TextBaseline.ideographic),),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: _ageController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: '만 나이를 입력하세요',
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return "필수입력란 입니다";
                                      } else if(value == '0'){
                                        return "1 이상의 숫자를 입력해주세요";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Text('세', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 125),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Text('사용자 이름 : ${widget.userProvider.userName}'),
              Text('사용자 나이 : ${widget.userProvider.userAge}'),
              const SizedBox(height: 100,),
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

