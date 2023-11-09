import 'package:coolcoolcoffee_front/page/login/user_form_first_page.dart';
import 'package:coolcoolcoffee_front/page/login/user_form_second_page.dart';
import 'package:coolcoolcoffee_front/page/login/user_form_third_page.dart';
import 'package:flutter/material.dart';

import '../../page_state/page_state.dart';
import '../../model/user.dart';

class UserFormPage extends StatefulWidget {
  const UserFormPage({super.key});

  @override
  State<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 3;

  User user = User();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입 정보 받는 페이지'),
      ),
      body: Expanded(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(5),
              child: CustomPaint(
                size: Size(MediaQuery.of(context).size.width, 5),
                painter: ChangingLinePainter(_currentPage),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  UserFormFirstPage(onNext: nextPage, user: user,),
                  UserFormSecondPage(onNext: nextPage, user: user),
                  UserFormThirdPage(onNext: nextPage, user: user),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: (_currentPage == _totalPages - 1) ? finishPage : nextPage,
                child: Text((_currentPage == _totalPages - 1) ? '완료' : '다음'),
            ),
          ],
        ),
      ),
    );
  }

  void nextPage(){
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void finishPage(){
    // user 정보 db에 저장하기는 코드 넣기
    print(user);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PageStates()));
  }
}

class ChangingLinePainter extends CustomPainter {
  final int currentPage;

  ChangingLinePainter(this.currentPage);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.grey;

    double segmentWidth = size.width / 3;
    double lineHeight = size.height;

    if (currentPage == 0) {
      // 첫 번째 페이지: 왼쪽 선 파란색
      paint.color = Colors.blue;
      canvas.drawLine(
        const Offset(0, 0),
        Offset(segmentWidth, lineHeight),
        paint,
      );
    } else if (currentPage == 1) {
      // 두 번째 페이지: 중앙 선 파란색
      paint.color = Colors.blue;
      canvas.drawLine(
        Offset(segmentWidth, 0),
        Offset(segmentWidth * 2, lineHeight),
        paint,
      );
    } else if (currentPage == 2) {
      // 세 번째 페이지: 오른쪽 선 파란색
      paint.color = Colors.blue;
      canvas.drawLine(
        Offset(segmentWidth * 2, 0),
        Offset(size.width, lineHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
