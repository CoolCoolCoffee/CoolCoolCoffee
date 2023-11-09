import 'package:flutter/material.dart';

class CaffeineLeftWidget extends StatefulWidget {
  const CaffeineLeftWidget({Key? key}) : super(key: key);

  @override
  _CaffeineLeftWidgetState createState() => _CaffeineLeftWidgetState();
}

class _CaffeineLeftWidgetState extends State<CaffeineLeftWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 300,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // 그림자 위치 조정
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '체내 잔여 카페인 양',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '230/320 (mg)',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _showPopup(context); // 버튼을 누르면 팝업 창 표시
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.brown, // 버튼의 배경색
                minimumSize: Size(5, 100),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5, // 그림자 효과
              ),
              child: Text('그래프'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('카페인 반감기 그래프'),
          content: Container(
            width: double.maxFinite,
            height: 200,
            color: Colors.brown[100], // Set the color of the rectangular box
            child: Center(
              child: Text(
                '그래프',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: Text('닫기'),
            ),
          ],
        );
      },
    );
  }
}