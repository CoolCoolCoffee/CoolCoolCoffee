import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:coolcoolcoffee_front/page/login/sign_up_page.dart';
import '../../page_state/page_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String errorMessage = '';
  String _email = '';
  String _password = '';

  late bool _passwordVisible;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _userIdWidget(){
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: '이메일',
        hintText: '이메일을 입력하세요.',
        hintStyle: TextStyle(color: Colors.grey),
      ),
      validator: (String? value){
        if(value!.isEmpty){
          return '이메일을 입력해주세요.';
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
      controller: _passwordController,
      obscureText: !_passwordVisible,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: '비밀번호',
        hintText: '비밀번호를 입력하세요.',
        hintStyle: const TextStyle(color: Colors.grey),
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
              },
            icon: Icon(
                _passwordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,),
        )
      ),
      validator: (String? value){
        if(value!.isEmpty){
          return '비밀번호를 입력해주세요.';
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

  void _handleLogin() async{
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      print('사용자 로그인 완료: ${userCredential.user!.email}');

      // if(!mounted) return;
      // Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => const PageStates()),);

      // if(!mounted) return;
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const PageStates(),
      //     ));
    } on FirebaseAuthException catch (e) {
      //로그인 예외처리
      switch (e.code) {
        case 'user-not-found':
          setState(() {
            errorMessage = '유효하지 않는 이메일 주소입니다.';
            print(errorMessage);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage, style: const TextStyle(color: Colors.red),),
              backgroundColor: Colors.brown.withOpacity(0.4),
            ),
          );
          break;

        case 'wrong-password':
          setState(() {
            errorMessage = '비밀번호가 틀렸습니다.';
            print(errorMessage);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage, style: const TextStyle(color: Colors.red),),
              backgroundColor: Colors.brown.withOpacity(0.4),
            ),
          );
          break;

        case 'user-not-found':
          setState(() {
            errorMessage = '존재하지 않는 이메일 주소입니다.';
            print(errorMessage);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage, style: const TextStyle(color: Colors.red),),
              backgroundColor: Colors.brown.withOpacity(0.4),
            ),
          );
          break;

        case 'user-disabled':
          setState(() {
            errorMessage = '비활성화된 계정입니다.';
            print(errorMessage);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage, style: const TextStyle(color: Colors.red),),
              backgroundColor: Colors.brown.withOpacity(0.4),
            ),
          );
          break;

        default:
          errorMessage = e.code;
          print('오류가 발생했습니다. : $errorMessage');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('오류가 발생했습니다(error code : $errorMessage', style: const TextStyle(color: Colors.red),),
              backgroundColor: Colors.brown.withOpacity(0.6),
            ),
          );
          break;
      }


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.brown.withOpacity(0.1),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('안녕하세요'),
              const Text('쿨쿨커피입니다 :)'),
              const SizedBox(height: 20.0),
              _userIdWidget(),
              const SizedBox(height: 20.0),
              _userPwWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                      alignment: Alignment.topRight,
                      child: const Text('계정이 없으신가요?')
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const SignUpPage()),
                        );
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        minimumSize: MaterialStateProperty.all(Size(0,0)),
                      ),
                      child: Text('계정 생성하기',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.brown.withOpacity(0.6),
                        ),
                      )
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Container(
                height: 70,
                width: 150,
                padding: const EdgeInsets.only(top: 8.0), // 8단위 배수가 보기 좋음
                child: ElevatedButton(
                    style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.brown.withOpacity(0.6)),

                    ),
                    onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        _handleLogin();
                      }
                    },
                    child: const Text("로그인", style: TextStyle(color: Colors.white, fontSize: 17),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

