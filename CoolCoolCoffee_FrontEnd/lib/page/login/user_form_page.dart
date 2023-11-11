// import 'package:coolcoolcoffee_front/provider/user_provider.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// import '../../page_state/page_state.dart';
// import 'package:coolcoolcoffee_front/page/login/user_form_first_page.dart';
// import 'package:coolcoolcoffee_front/page/login/user_form_second_page.dart';
// import 'package:coolcoolcoffee_front/page/login/user_form_third_page.dart';
//
// class UserFormPage extends StatefulWidget {
//   const UserFormPage({super.key});
//
//   @override
//   State<UserFormPage> createState() => _UserFormPageState();
// }
//
// class _UserFormPageState extends State<UserFormPage> {
//   final PageController _pageController = PageController();
//   int _currentPage = 0;
//
//   UserProvider userProvider = UserProvider();
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       setState(() {
//         _currentPage = _pageController.page?.round() ?? 0;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('사용자 정보 입력 페이지'),
//       ),
//       body: Column(
//         children: [
//           PreferredSize(
//             preferredSize: const Size.fromHeight(5),
//             child: CustomPaint(
//               size: Size(MediaQuery.of(context).size.width, 5),
//               painter: ChangingLinePainter(_currentPage),
//             ),
//           ),
//           Expanded(
//             child: PageView.builder(
//               controller: _pageController,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: 3,
//               onPageChanged: (int page) {
//                 setState(() {
//                   _currentPage = page;
//                 });
//               },
//               itemBuilder: (BuildContext context, int index) {
//                 if(index == 0){
//                   return const UserFormFirstPage();
//                 } else if(index == 1){
//                   return const UserFormSecondPage();
//                 } else if(index == 2){
//                   return const UserFormThirdPage();
//                 }
//               },
//             ),
//           ),
//           AnimatedBuilder(
//               animation: _pageController,
//               builder: (BuildContext context, Widget? child){
//                 return Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     if(_currentPage > 0)
//                       ElevatedButton(
//                         onPressed: () {
//                             _pageController.previousPage(
//                               duration: const Duration(milliseconds: 500),
//                               curve: Curves.easeInOut,
//                           );
//                         },
//                         child: const Text('이전'),
//                       ),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_currentPage < 2) {
//                           _pageController.nextPage(
//                             duration: const Duration(milliseconds: 500),
//                             curve: Curves.easeInOut,
//                           );
//                         }
//                       },
//                       child: Text(_currentPage == 1 ? '다음' : '완료'),
//                   ),
//                   ],
//                 );
//               })
//         ],
//       ),
//     );
//   }
//
//   void finishPageAction(){
//     // user 정보 db에 저장하기는 코드 넣기 : provider 사용
//     Navigator.push(context, MaterialPageRoute(builder: (context) => const PageStates()));
//   }
// }
//
// class ChangingLinePainter extends CustomPainter {
//   final int currentPage;
//
//   ChangingLinePainter(this.currentPage);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()..color = Colors.grey;
//
//     double segmentWidth = size.width / 3;
//     double lineHeight = size.height;
//
//     if (currentPage == 0) {
//       // 첫 번째 페이지: 왼쪽 선 파란색
//       paint.color = Colors.blue;
//       canvas.drawLine(
//         const Offset(0, 0),
//         Offset(segmentWidth, lineHeight),
//         paint,
//       );
//     } else if (currentPage == 1) {
//       // 두 번째 페이지: 중앙 선 파란색
//       paint.color = Colors.blue;
//       canvas.drawLine(
//         Offset(segmentWidth, 0),
//         Offset(segmentWidth * 2, lineHeight),
//         paint,
//       );
//     } else if (currentPage == 2) {
//       // 세 번째 페이지: 오른쪽 선 파란색
//       paint.color = Colors.blue;
//       canvas.drawLine(
//         Offset(segmentWidth * 2, 0),
//         Offset(size.width, lineHeight),
//         paint,
//       );
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
