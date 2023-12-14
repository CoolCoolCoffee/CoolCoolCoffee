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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passController;
  late TextEditingController _pass2Controller;

  String _email = '';
  String _password = '';
  String _password2 = '';

  late bool _passwordVisible1;
  late bool _passwordVisible2;

  @override
  void initState(){
    super.initState();
    _emailController = TextEditingController();
    _passController = TextEditingController();
    _pass2Controller = TextEditingController();
    _passwordVisible1 = false;
    _passwordVisible2 = false;
  }

  @override
  void dispose(){
    _emailController.dispose();
    _passController.dispose();
    _pass2Controller.dispose();
    super.dispose();
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
      obscureText: !_passwordVisible1,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: '비밀번호',
        hintText: '6자 이상 입력해주세요',
        hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible1 = !_passwordVisible1;
              });
            },
            icon: Icon(
              _passwordVisible1
                  ? Icons.visibility
                  : Icons.visibility_off,),
          )
      ),
      validator: (value){
        if(value == null || value.isEmpty){
          return "비밀번호를 입력해주세요.";
        } else if(value.length < 6){
          return "비밀번호 6자 이상 입력해주세요.";
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
      obscureText: !_passwordVisible2,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: '비밀번호 확인',
        hintText: '비밀번호를 입력하세요.',
        hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible2 = !_passwordVisible2;
              });
            },
            icon: Icon(
              _passwordVisible2
                  ? Icons.visibility
                  : Icons.visibility_off,),
          )
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
        backgroundColor: Colors.white,
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
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('쿨쿨커피가 처음이신가요?'),
                  const SizedBox(height: 20,),
                  _userEmailWidget(),
                  const SizedBox(height: 20,),
                  _userPwWidget(),
                  const SizedBox(height: 20,),
                  _userPw2Widget(),
                  const SizedBox(height: 30,),
                  Container(
                    height: 70,
                    width: 150,
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.withOpacity(0.6)),
                      ),
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUpFirstPage(userEmail: _email, userPassword: _password))
                          );
                        }
                      },
                      child: const Text('회원가입', style: TextStyle(color: Colors.white, fontSize: 17),),
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

