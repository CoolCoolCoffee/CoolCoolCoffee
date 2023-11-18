import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coolcoolcoffee_front/page/login/sign_up_first_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _pass2Controller = TextEditingController();

  String _email = '';
  String _password = '';
  String _password2 = '';


  String errorMessage = '';

  void _handleSignUp() async{

      try{
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        print('사용자 회원가입 완료: ${userCredential.user!.email}');

        // 다른 앱 접근 권한 기본(false)으로 설정해놓음
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.uid)
            .set({'app_access' : false})
            .onError((error, stackTrace) => print('앱 권한 정보 추가 에러!'));

        // 사용자 이메일 주소도 넣어놓음
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCredential.user!.uid)
            .set({'user_email' : userCredential.user!.email})
            .onError((error, stackTrace) => print('이메일 정보 추가 에러!'));
      // 왜 토스트 안 되냐 ㅡㅡ
      // Fluttertoast.showToast(
      //   msg: '회원가입이 완료되었습니다!',
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   backgroundColor: Colors.grey,
      //   textColor: Colors.blue,ㅅ
      // );

      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const SignUpFirstPage()),
      );

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


  Widget _userEmailWidget(){
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이메일',
        hintText: '이메일을 입력하세요',
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
          _email = value;
        });
      },
    );
  }

  Widget _userPwWidget(){
    return TextFormField(
      controller: _passController,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호',
        hintText: '비밀번호를 입력하세요',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return "비밀번호를 입력해주세요.";
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          _password = value;
        });
      },
    );
  }

  Widget _userPw2Widget(){
    return TextFormField(
      controller: _pass2Controller,
      obscureText: true,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '비밀번호 확인',
        hintText: '비밀번호를 입력하세요.',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return "비밀번호를 입력해주세요.";
        } else if(value != _password){
          return "비밀번호가 일치하지 않습니다.";
        }
        return null;
      },
      onChanged: (value){
        setState(() {
          _password2 = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.brown.withOpacity(0.1),
      appBar: AppBar(
        title: Text(''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('회원가입 화면'),
                const SizedBox(height: 30,),
                _userEmailWidget(),
                const SizedBox(height: 20,),
                _userPwWidget(),
                const SizedBox(height: 20,),
                _userPw2Widget(),
                const SizedBox(height: 30,),
                ElevatedButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      _handleSignUp();
                    }
                  },
                  child: Text('회원가입'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
  }
  @override
  void dispose() {
    // 해당 클래스가 사라질떄
    _emailController.dispose();
    _passController.dispose();
    _pass2Controller.dispose();
    super.dispose();
  }
}

